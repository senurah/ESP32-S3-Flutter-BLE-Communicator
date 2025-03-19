# 🚀 ESP32-S3 BLE Flutter App (Version 1)

This project demonstrates **Bluetooth Low Energy (BLE) communication** between an **ESP32-S3 development board** and a **Flutter mobile application**.

## **🛠 Features**
✅ Scan and connect to the **ESP32-S3 BLE device**  
✅ Send data from the **mobile app** to ESP32  
✅ Receive **notifications** from ESP32 and display in the app  
✅ User-friendly **Flutter UI** with device discovery  
✅ **Disconnect** feature to handle BLE disconnections  

---

## **📷 Screenshots**
| Scanning Devices | Connected & Receiving Data |
|-----------------|---------------------------|
|![scanning](https://github.com/user-attachments/assets/f78d2c8b-cdfb-4ff1-9090-4c8d77a1085c)|![version 1](https://github.com/user-attachments/assets/6e8ff4dd-a590-4ed6-ae28-5d9854c94951)|

---

## **📂 Project Structure**
````
📁 ESP32-S3-BLE-App
 │── 📂 flutter_app/          # Your Flutter app
 │── 📂 esp32_ble_firmware/   # ESP32 Arduino firmware  
 │── README.md                # Project documentation
````

---

## **📌 Step-by-Step Guide**

### **1️⃣ Setup the ESP32-S3 BLE Firmware**

1. Install **Arduino IDE**: [Download Here](https://www.arduino.cc/en/software)
2. Install the **ESP32 Board Package**:
   - Open **Arduino IDE**
   - Go to **File** > **Preferences** > Add this URL to **Board Manager**:
     ```
     https://raw.githubusercontent.com/espressif/arduino-esp32/gh-pages/package_esp32_index.json
     ```
   - Open **Tools** > **Board** > **Boards Manager** > Search for **ESP32** > Install **ESP32 by Espressif Systems**.
3. Install **ESP32 BLE Library**:
   - Open **Tools** > **Manage Libraries**
   - Search for **"ESP32 BLE Arduino"** and install it.
4. Open `esp32_ble_firmware.ino` from `esp32_ble_firmware/` folder.
5. Select **ESP32-S3 Board** from **Tools > Board**.
6. **Upload the sketch** to your ESP32-S3.
7. Open **Serial Monitor** (115200 baud) and confirm BLE advertising is active.

---

### **2️⃣ Setup the Flutter Mobile App**

1. Install **Flutter SDK**: [Download Here](https://flutter.dev/docs/get-started/install)

2. Clone this repository:
   ```sh
   git clone https://github.com/YOUR_GITHUB_USERNAME/ESP32-S3-BLE-App.git
   cd ESP32-S3-BLE-App/flutter_app

3. Install dependencies:
  ```
  flutter pub get
  ```

4. Run on a Physical Device (Emulators do not support BLE):
  ```
  flutter run
  ```

5. Grant Permissions:
  - Android: Ensure Location & Bluetooth permissions are enabled.
  - iOS: Add required permissions in ```Info.plist```.

---

## **📡 How to Use**

#### 🔍 Scan & Connect to ESP32
  1. Turn on your ESP32-S3 BLE device.
  2. Open the Flutter App and tap ```"Scan for Devices"```.
  3. Select ESP32-S3-BLE-Example from the list to connect.
     
#### 📨 Sending Data
  1. Type a message in the input field and press Enter.
  2. The ESP32 will receive & print the message in the Serial Monitor.
  3. Select ESP32-S3-BLE-Example from the list to connect.

#### 📩 Receiving Data
  1. ESP32 automatically sends notifications to the app.
  2. The app displays the received data in a Snackbar.

#### 🔌 Disconnecting
  - Press ```"Disconnect"``` to safely close the BLE connection

---

## **🔧 Known Issues & Fixes**

| Issue	| Solution |
|-----------------|---------------------------|
| ESP32 not appearing in scan	| Restart ESP32 and ensure it's advertising properly. |
| App crashes on start	| Ensure Flutter dependencies are installed correctly. |
| Permissions issue on Android	| Grant Bluetooth & Location permissions manually. |
| BLE scanning too frequent error	| Reduce scanning intervals to 10s or more. |

---

## **📜 License**

We welcome contributions! Feel free to:
- ✅ Report issues 
- ✅ Improve code efficiency  
- ✅ Add new features
  
Pull requests are always welcome! 🚀

---

## **📞 Support & Contact**

For any issues or suggestions, please open a GitHub Issue or contact me at:
[Github:senurah](https://github.com/senurah)

### **🎉 Happy Coding! Enjoy Your ESP32-S3 BLE App! 🚀**





