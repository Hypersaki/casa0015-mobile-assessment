import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';

void main() {
  runApp(MaterialApp(
    title: 'Bluetooth Connect',
    theme: ThemeData(
      primarySwatch: Colors.blue,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    ),
    home: BluetoothConnect(),
  ));
}

class BluetoothConnect extends StatefulWidget {
  @override
  _BluetoothConnectState createState() => _BluetoothConnectState();
}

class _BluetoothConnectState extends State<BluetoothConnect> {
  final FlutterBlue flutterBlue = FlutterBlue.instance;
  final String targetDeviceMac = "08:3A:8D:AC:49:FA";
  BluetoothDevice? connectedDevice;
  String connectionStatus = 'Disconnected';
  String sensorData = '';
  StreamSubscription? scanSubscription;

  void startConnection() async {
    setState(() {
      connectionStatus = 'Searching device...';
    });

    flutterBlue.startScan(timeout: Duration(seconds: 10));

    scanSubscription = flutterBlue.scanResults.listen((results) {
      for (ScanResult result in results) {
        if (result.device.id.toString() == targetDeviceMac) {
          flutterBlue.stopScan();
          scanSubscription?.cancel();
          result.device.connect().then((_) {
            setState(() {
              connectedDevice = result.device;
              connectionStatus = 'Connected';
              setupNotifications(connectedDevice!);
            });
          });
          break;
        }
      }
    });
  }

  void setupNotifications(BluetoothDevice device) async {
    List<BluetoothService> services = await device.discoverServices();
    for (var service in services) {
      for (var characteristic in service.characteristics) {
        if (characteristic.properties.notify) {
          characteristic.setNotifyValue(true);
          characteristic.value.listen((value) {
            setState(() {
              sensorData = String.fromCharCodes(value);
            });
          });
        }
      }
    }
  }

  void disconnectFromDevice() async {
    if (connectedDevice != null) {
      await connectedDevice!.disconnect();
      setState(() {
        connectedDevice = null;
        connectionStatus = 'Disconnected';
        sensorData = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bluetooth Connect'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Status: $connectionStatus', style: TextStyle(fontSize: 20)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: connectionStatus == 'Disconnected' ? startConnection : null,
              child: Text('Start Connection'),
            ),
            SizedBox(height: 10),
            if (connectionStatus == 'Connected')
              ElevatedButton(
                onPressed: disconnectFromDevice,
                child: Text('Disconnect'),
              ),
            SizedBox(height: 10),
            Text('Sensor Data: $sensorData', style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    flutterBlue.stopScan();
    scanSubscription?.cancel();
    if (connectedDevice != null) {
      disconnectFromDevice();
    }
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter_blue/flutter_blue.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'dart:async';  // Add this import
//
// class ConnectionScreen extends StatefulWidget {
//   @override
//   _ConnectionScreenState createState() => _ConnectionScreenState();
// }
//
// class _ConnectionScreenState extends State<ConnectionScreen> {
//   FlutterBlue flutterBlue = FlutterBlue.instance;
//   bool isScanning = false;
//   BluetoothDevice? connectedDevice;
//   List<BluetoothService> bluetoothServices = [];
//   StreamSubscription? scanSubscription;  // This is now recognized
//
//   @override
//   void initState() {
//     super.initState();
//     requestPermissions();
//   }
//
//   Future<void> requestPermissions() async {
//     Map<Permission, PermissionStatus> statuses = await [
//       Permission.bluetoothScan,
//       Permission.bluetoothConnect,
//       Permission.location,
//     ].request();
//
//     final info = statuses[Permission.location]?.isGranted ?? false;
//     print('Location permission: $info');
//
//     if ((statuses[Permission.bluetoothScan]?.isGranted ?? false) &&
//         (statuses[Permission.bluetoothConnect]?.isGranted ?? false) &&
//         info) {
//       startScan();
//     } else {
//       print('Bluetooth or Location permission not granted');
//     }
//   }
//
//   void startScan() {
//     setState(() {
//       isScanning = true;
//     });
//     flutterBlue.startScan(timeout: Duration(seconds: 4));
//
//     scanSubscription = flutterBlue.scanResults.listen((List<ScanResult> results) {
//       print('Scan results: ${results.length}');
//       for (ScanResult result in results) {
//         print('Device found: ${result.device.name} - ${result.device.id}');
//         if (result.device.name == "ESP32_Sensor") {
//           print('ESP32_Sensor found, trying to connect...');
//           connectToDevice(result.device);
//           scanSubscription?.cancel();
//           break;
//         }
//       }
//     });
//
//     flutterBlue.stopScan().then((_) {
//       setState(() {
//         isScanning = false;
//       });
//       print('Scan stopped.');
//       scanSubscription?.cancel();
//     });
//   }
//
//   void connectToDevice(BluetoothDevice device) async {
//     await device.connect();
//     setState(() {
//       connectedDevice = device;
//     });
//     discoverServices(device);
//   }
//
//   void discoverServices(BluetoothDevice device) async {
//     List<BluetoothService> services = await device.discoverServices();
//     setState(() {
//       bluetoothServices = services;
//     });
//     readDataFromDevice(device);
//   }
//
//   void readDataFromDevice(BluetoothDevice device) async {
//     for (BluetoothService service in bluetoothServices) {
//       for (BluetoothCharacteristic characteristic in service.characteristics) {
//         if (characteristic.properties.notify) {
//           characteristic.value.listen((value) {
//             String sensorData = String.fromCharCodes(value);
//             print('New data: $sensorData');
//           });
//           await characteristic.setNotifyValue(true);
//         }
//       }
//     }
//   }
//
//   void disconnectFromDevice(BluetoothDevice device) async {
//     await device.disconnect();
//     setState(() {
//       connectedDevice = null;
//       bluetoothServices = [];
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text('Bluetooth Connect'),
//         ),
//         body: Column(
//           children: <Widget>[
//             ElevatedButton(
//               child: Text(isScanning ? 'Stop Scan' : 'Start Scan'),
//               onPressed: isScanning ? null : startScan,
//             ),
//             if (connectedDevice != null)
//               ListTile(
//                 title: Text(connectedDevice!.name ?? 'Connected Device'),
//                 subtitle: Text(connectedDevice!.id.toString()),
//                 trailing: ElevatedButton(
//                   child: const Text('Disconnect'),
//                   onPressed: () => disconnectFromDevice(connectedDevice!),
//                 ),
//               )
//           ],
//         ),
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//     flutterBlue.stopScan();
//     scanSubscription?.cancel();  // Cancel the subscription when the widget is disposed
//     if (connectedDevice != null) {
//       disconnectFromDevice(connectedDevice!);
//     }
//   }
// }
//
