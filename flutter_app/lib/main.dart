import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'dart:convert';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BLEHomeScreen(),
    );
  }
}

class BLEHomeScreen extends StatefulWidget {
  const BLEHomeScreen({super.key});

  @override
  State<BLEHomeScreen> createState() => _BLEHomeScreenState();
}

class _BLEHomeScreenState extends State<BLEHomeScreen> {
  List<BluetoothDevice> scannedDevices = [];
  BluetoothDevice? connectedDevice;
  BluetoothCharacteristic? targetCharacteristic;
  List<Map<String, dynamic>> chatMessages = [];
  TextEditingController messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    requestPermissions();
    startScan();
  }

  /// Request necessary permissions for Bluetooth
  Future<void> requestPermissions() async {
    await Permission.bluetooth.request();
    await Permission.bluetoothScan.request();
    await Permission.bluetoothConnect.request();
    await Permission.locationWhenInUse.request();
  }

  /// Start scanning for BLE devices
  void startScan() async {
    scannedDevices.clear();
    await FlutterBluePlus.stopScan();
    FlutterBluePlus.startScan(timeout: const Duration(seconds: 10));

    FlutterBluePlus.scanResults.listen((List<ScanResult> results) {
      for (ScanResult result in results) {
        if (!scannedDevices.contains(result.device) &&
            result.device.name.isNotEmpty) {
          setState(() {
            scannedDevices.add(result.device);
          });
        }
      }
    });

    Future.delayed(const Duration(seconds: 10), () {
      FlutterBluePlus.stopScan();
    });
  }

  /// Connect to a BLE device
  void connectToDevice(BluetoothDevice device) async {
    await FlutterBluePlus.stopScan();
    await device.connect();
    setState(() {
      connectedDevice = device;
    });

    discoverServices(device);
  }

  /// Discover services & characteristics
  void discoverServices(BluetoothDevice device) async {
    List<BluetoothService> services = await device.discoverServices();
    for (var service in services) {
      for (var characteristic in service.characteristics) {
        if (characteristic.properties.notify || characteristic.properties.write) {
          targetCharacteristic = characteristic;
          await characteristic.setNotifyValue(true);
          characteristic.value.listen((value) {
            setState(() {
              chatMessages.insert(0, {
                "text": utf8.decode(value),
                "isSent": false, // False means received from ESP32
              });
            });
          });
        }
      }
    }
  }

  /// Send a message from the mobile app to the ESP32
  void sendMessage() async {
    if (targetCharacteristic != null && messageController.text.isNotEmpty) {
      String message = messageController.text.trim();
      await targetCharacteristic!.write(utf8.encode(message));
      setState(() {
        chatMessages.insert(0, {
          "text": message,
          "isSent": true, // True means sent from mobile to ESP32
        });
      });
      messageController.clear();
    }
  }

  /// Disconnect BLE device
  void disconnectDevice() async {
    if (connectedDevice != null) {
      await connectedDevice!.disconnect();
      setState(() {
        connectedDevice = null;
        targetCharacteristic = null;
        chatMessages.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("ESP32 BLE Chat"), backgroundColor: Colors.blue),
      body: connectedDevice == null ? _buildScanUI() : _buildChatUI(),
    );
  }

  /// UI for scanning devices
  Widget _buildScanUI() {
    return Column(
      children: [
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: startScan,
          child: const Text("Scan for Devices"),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: scannedDevices.length,
            itemBuilder: (context, index) {
              BluetoothDevice device = scannedDevices[index];
              return ListTile(
                title: Text(device.name),
                subtitle: Text(device.id.toString()),
                onTap: () => connectToDevice(device),
              );
            },
          ),
        ),
      ],
    );
  }

  /// UI for Chat Messages
  Widget _buildChatUI() {
    return Column(
      children: [
        const SizedBox(height: 10),
        Text(
          "Connected to: ${connectedDevice!.name}",
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: disconnectDevice,
          child: const Text("Disconnect"),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: ListView.builder(
            reverse: true, // Newest message on top
            itemCount: chatMessages.length,
            itemBuilder: (context, index) {
              return _buildChatBubble(chatMessages[index]);
            },
          ),
        ),
        _buildMessageInput(),
      ],
    );
  }

  /// Chat bubble for displaying messages
  Widget _buildChatBubble(Map<String, dynamic> message) {
    bool isSent = message["isSent"];
    return Align(
      alignment: isSent ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isSent ? Colors.blue[300] : Colors.grey[300],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          message["text"],
          style: TextStyle(fontSize: 16, color: isSent ? Colors.white : Colors.black),
        ),
      ),
    );
  }

  /// Message input field
  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: messageController,
              decoration: InputDecoration(
                hintText: "Type a message...",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.send, color: Colors.blue),
            onPressed: sendMessage,
          ),
        ],
      ),
    );
  }
}
