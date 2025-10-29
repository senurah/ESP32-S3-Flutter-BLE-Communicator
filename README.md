# ESP32-S3 BLE Flutter Application

A Bluetooth Low Energy (BLE) communication system demonstrating bidirectional data exchange between an ESP32-S3 development board and a Flutter mobile application.

## Features

- Device discovery and connection management for ESP32-S3 BLE devices
- Bidirectional data transmission between mobile app and ESP32
- Real-time notification handling and display
- Intuitive user interface with device scanning capabilities
- Graceful connection termination and error handling

## Screenshots

| Device Scanning | Active Connection |
|----------------|-------------------|
|![scanning](https://github.com/user-attachments/assets/f78d2c8b-cdfb-4ff1-9090-4c8d77a1085c)|![version 1](https://github.com/user-attachments/assets/6e8ff4dd-a590-4ed6-ae28-5d9854c94951)|

## Project Structure

```
ESP32-S3-BLE-App/
├── flutter_app/              # Flutter mobile application
├── esp32_ble_firmware/       # ESP32 Arduino firmware
└── README.md                 # Project documentation
```

## Getting Started

### Prerequisites

- Arduino IDE 1.8.x or later
- Flutter SDK 3.0 or later
- ESP32-S3 development board
- Physical Android or iOS device (BLE not supported in emulators)

### ESP32-S3 Firmware Setup

1. **Install Arduino IDE**
   
   Download from the [official Arduino website](https://www.arduino.cc/en/software).

2. **Configure ESP32 Board Support**
   
   - Navigate to File > Preferences
   - Add the following URL to Additional Boards Manager URLs:
     ```
     https://raw.githubusercontent.com/espressif/arduino-esp32/gh-pages/package_esp32_index.json
     ```
   - Open Tools > Board > Boards Manager
   - Search for "ESP32" and install "ESP32 by Espressif Systems"

3. **Install Required Libraries**
   
   - Open Tools > Manage Libraries
   - Search and install "ESP32 BLE Arduino"

4. **Upload Firmware**
   
   - Open `esp32_ble_firmware.ino` from the `esp32_ble_firmware/` directory
   - Select your ESP32-S3 board from Tools > Board
   - Connect your ESP32-S3 via USB
   - Click Upload
   - Open Serial Monitor (115200 baud) to verify BLE advertising status

### Flutter Application Setup

1. **Install Flutter**
   
   Follow the [official Flutter installation guide](https://flutter.dev/docs/get-started/install) for your operating system.

2. **Clone Repository**
   
   ```bash
   https://github.com/senurah/ESP32-S3-Flutter-BLE-Communicator.git
   ```

3. **Install Dependencies**
   
   ```bash
   flutter pub get
   ```

4. **Configure Permissions**
   
   **Android**: Ensure the following permissions are declared in `android/app/src/main/AndroidManifest.xml`:
   - `BLUETOOTH`
   - `BLUETOOTH_ADMIN`
   - `BLUETOOTH_SCAN`
   - `BLUETOOTH_CONNECT`
   - `ACCESS_FINE_LOCATION`

   **iOS**: Add required keys to `ios/Runner/Info.plist`:
   - `NSBluetoothAlwaysUsageDescription`
   - `NSBluetoothPeripheralUsageDescription`

5. **Deploy Application**
   
   ```bash
   flutter run
   ```

## Usage

### Connecting to ESP32-S3

1. Power on your ESP32-S3 device
2. Launch the Flutter application
3. Tap "Scan for Devices"
4. Select "ESP32-S3-BLE-Example" from the discovered devices list

### Sending Data

1. Enter your message in the text input field
2. Press Enter or tap Send
3. Verify receipt in the ESP32 Serial Monitor

### Receiving Data

The application automatically receives and displays notifications from the ESP32 in real-time through Snackbar messages.

### Disconnecting

Press the "Disconnect" button to terminate the BLE connection safely.

## Troubleshooting

| Issue | Resolution |
|-------|-----------|
| ESP32 not detected during scan | Verify ESP32 is powered and advertising. Check Serial Monitor output. Restart device if necessary. |
| Application crashes on launch | Verify all Flutter dependencies are properly installed. Run `flutter doctor` to check configuration. |
| Permission errors on Android | Manually grant Bluetooth and Location permissions in device settings. |
| BLE scan frequency errors | Implement scan throttling with minimum 10-second intervals between scans. |

## Contributing

Contributions are welcome and encouraged. To contribute:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/improvement`)
3. Commit your changes (`git commit -am 'Add new feature'`)
4. Push to the branch (`git push origin feature/improvement`)
5. Open a Pull Request

Areas for contribution include:
- Bug reports and fixes
- Performance optimizations
- Feature enhancements
- Documentation improvements

## License

This project is licensed under the MIT License. See the LICENSE file for details.

## Support

For bug reports, feature requests, or general questions:
- Open an issue on [GitHub Issues](https://github.com/senurah/ESP32-S3-BLE-App/issues)
- Contact the maintainer: [GitHub - senurah](https://github.com/senurah)

## Acknowledgments

Built with ESP32 Arduino Core and Flutter's flutter_blue_plus package.



