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
  List<String> receivedMessages = [];

  @override
  void initState() {
    super.initState();
    requestPermissions(); // Ensure Bluetooth permissions
    startScan();
  }

  /// Request Bluetooth permissions for Android 12+
  Future<void> requestPermissions() async {
    await Permission.bluetooth.request();
    await Permission.bluetoothScan.request();
    await Permission.bluetoothConnect.request();
    await Permission.locationWhenInUse.request();
  }

  /// Start BLE scanning for ESP32 devices
  void startScan() async {
    scannedDevices.clear();
    await FlutterBluePlus.stopScan(); // Ensure previous scans are stopped
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

    // Stop scanning after 10 seconds
    Future.delayed(const Duration(seconds: 10), () {
      FlutterBluePlus.stopScan();
    });
  }

  /// Connect to a selected BLE device
  void connectToDevice(BluetoothDevice device) async {
    await FlutterBluePlus.stopScan();
    await device.connect();
    setState(() {
      connectedDevice = device;
    });

    discoverServices(device);
  }

  /// Discover services and characteristics of the connected BLE device
  void discoverServices(BluetoothDevice device) async {
    List<BluetoothService> services = await device.discoverServices();
    for (var service in services) {
      for (var characteristic in service.characteristics) {
        if (characteristic.properties.notify) {
          targetCharacteristic = characteristic;
          await characteristic.setNotifyValue(true);
          characteristic.value.listen((value) {
            setState(() {
              receivedMessages.insert(0, utf8.decode(value));
            });
          });
        }
      }
    }
  }

  /// Send a request to ESP32 to fetch sensor data
  void requestSensorData() async {
    if (targetCharacteristic != null) {
      await targetCharacteristic!.write(utf8.encode("GET_DATA"));
      print("Sent: GET_DATA");
    }
  }

  /// Disconnect from the BLE device
  void disconnectDevice() async {
    if (connectedDevice != null) {
      await connectedDevice!.disconnect();
      setState(() {
        connectedDevice = null;
        targetCharacteristic = null;
        receivedMessages.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("ESP32 BLE App"), backgroundColor: Colors.blue),
      body: connectedDevice == null ? _buildScanUI() : _buildConnectedUI(),
    );
  }

  /// UI for scanning and selecting BLE devices
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

  /// UI for connected device interaction
  Widget _buildConnectedUI() {
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
        ElevatedButton(
          onPressed: requestSensorData,
          child: const Text("Request Sensor Data"),
        ),
        const SizedBox(height: 10),
        const Text(
          "Received Messages:",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: receivedMessages.length,
            itemBuilder: (context, index) {
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                child: ListTile(
                  title: Text(receivedMessages[index]),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}