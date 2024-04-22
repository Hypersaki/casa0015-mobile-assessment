import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:airqualityalarm/sensordata.dart';

class BluetoothManager {
  static final BluetoothManager _instance = BluetoothManager._internal();

  factory BluetoothManager() => _instance;

  BluetoothConnection? connection;
  final String targetMac = "08:3A:8D:AC:49:FA";//ESP32 MAC address
  bool isConnecting = false;
  bool isConnected = false;

  SensorData? sensorData;

  BluetoothManager._internal();

  void setSensorData(SensorData data) {
    sensorData = data;
  }

  Future<void> connect() async {
    if (isConnected || isConnecting) return;

    isConnecting = true;

    try {
      connection = await BluetoothConnection.toAddress(targetMac);
      isConnected = true;
      print('Connected to the device');

      connection!.input!.listen((data) {
        String receivedData = String.fromCharCodes(data).trim();
        print('Received data: $receivedData');
        final values = receivedData.split(',');
        if (values.length == 5) {
          sensorData?.update(
            double.tryParse(values[0]) ?? 0.0,
            double.tryParse(values[1]) ?? 0.0,
            double.tryParse(values[2]) ?? 0.0,
            double.tryParse(values[3]) ?? 0.0,
            double.tryParse(values[4]) ?? 0.0,
          );
        }
      }).onDone(() {
        isConnected = false;
        isConnecting = false;
        sensorData?.updateConnectionStatus(false);
      });
    } catch (e) {
      isConnected = false;
      isConnecting = false;
      // process failure
      print('Cannot connect, exception occurred');
      sensorData?.updateConnectionStatus(false);
    }
  }

  void disconnect() async {
    await connection?.close();
    isConnected = false;
    sensorData?.updateConnectionStatus(false);
  }
}
