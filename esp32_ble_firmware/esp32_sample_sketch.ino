#include <BLEDevice.h>
#include <BLEServer.h>
#include <BLEUtils.h>
#include <BLE2902.h>

// You can define your own UUIDs.:
#define SERVICE_UUID        "12345678-1234-1234-1234-1234567890ab"
#define CHARACTERISTIC_UUID "abcd1234-0000-1000-8000-00805f9b34fb"

BLEServer* pServer = nullptr;
BLECharacteristic* pCharacteristic = nullptr;

// Flags to keep track of device connection
bool deviceConnected = false;

// Create a callback class to handle server events
class MyServerCallbacks: public BLEServerCallbacks {
    void onConnect(BLEServer* pServer) {
      deviceConnected = true;
      Serial.println("BLE Client Connected!");
    }

    void onDisconnect(BLEServer* pServer) {
      deviceConnected = false;
      Serial.println("BLE Client Disconnected!");
      // Restart advertising so other devices can connect again
      pServer->getAdvertising()->start();
    }
};

  // Create a callback class to handle characteristic read/write requests
  class MyCallbacks: public BLECharacteristicCallbacks {
      
      //Return data onwrite "GET_DATA"
      void onWrite(BLECharacteristic *pCharacteristic) {
      String rxValue = pCharacteristic->getValue();

      if (rxValue == "GET_DATA") {
          // Example: Send fake sensor data
          String message = "Temp: 27.3°C | Humidity: 45%";
          pCharacteristic->setValue(message.c_str());
          pCharacteristic->notify();
          Serial.println("Sent sensor data to app.");
      }
  }

};

void setup() {
  Serial.begin(115200);
  Serial.println("Starting BLE work!");

  // 1. Initialize the BLE device
  BLEDevice::init("ESP32-S3-BLE-Example");  // This is the device name you’ll see on your phone

  // 2. Create the BLE Server
  pServer = BLEDevice::createServer();
  pServer->setCallbacks(new MyServerCallbacks());

  // 3. Create a BLE Service
  BLEService *pService = pServer->createService(SERVICE_UUID);

  // 4. Create a BLE Characteristic
  pCharacteristic = pService->createCharacteristic(
                      CHARACTERISTIC_UUID,
                      BLECharacteristic::PROPERTY_READ   |
                      BLECharacteristic::PROPERTY_WRITE  |
                      BLECharacteristic::PROPERTY_NOTIFY |
                      BLECharacteristic::PROPERTY_INDICATE
                    );

  pCharacteristic->setCallbacks(new MyCallbacks());

  // Add a 2902 descriptor if you want notify/indicate to work in many apps
  pCharacteristic->addDescriptor(new BLE2902());

  // 5. Start the Service
  pService->start();

  // 6. Start advertising
  BLEAdvertising* pAdvertising = BLEDevice::getAdvertising();
  pAdvertising->addServiceUUID(SERVICE_UUID);
  // By default, the ESP32 will advertise using the device name set above
  pAdvertising->setScanResponse(true);
  pAdvertising->setMinPreferred(0x06);  // functions that help with iPhone connections issue
  pAdvertising->setMinPreferred(0x12);

  BLEDevice::startAdvertising();
  Serial.println("BLE advertising started...");
}

void loop() {

  // If connected, we can send a periodic notification (optional example)
  if (deviceConnected) {
    // For demonstration, send a simple string (or sensor data)
    static unsigned long lastSend = 0;
    if (millis() - lastSend > 2000) { // send every 2 seconds
      lastSend = millis();

      // Example data
      String message = "Hello from ESP32-S3: ";
      message += String(millis()/1000);
      pCharacteristic->setValue(message.c_str());
      pCharacteristic->notify();  // push to the client if it's subscribed
      Serial.println("Notified value: " + message);
    }
  }
  delay(10);
}
