import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';  // Add this import

class ConnectionScreen extends StatefulWidget {
  @override
  _ConnectionScreenState createState() => _ConnectionScreenState();
}

class _ConnectionScreenState extends State<ConnectionScreen> {
  FlutterBlue flutterBlue = FlutterBlue.instance;
  bool isScanning = false;
  BluetoothDevice? connectedDevice;
  List<BluetoothService> bluetoothServices = [];
  StreamSubscription? scanSubscription;  // This is now recognized

  @override
  void initState() {
    super.initState();
    requestPermissions();
  }

  Future<void> requestPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.location,
    ].request();

    final info = statuses[Permission.location]?.isGranted ?? false;
    print('Location permission: $info');

    if ((statuses[Permission.bluetoothScan]?.isGranted ?? false) &&
        (statuses[Permission.bluetoothConnect]?.isGranted ?? false) &&
        info) {
      startScan();
    } else {
      print('Bluetooth or Location permission not granted');
    }
  }

  void startScan() {
    setState(() {
      isScanning = true;
    });
    flutterBlue.startScan(timeout: Duration(seconds: 4));

    scanSubscription = flutterBlue.scanResults.listen((List<ScanResult> results) {
      print('Scan results: ${results.length}');
      for (ScanResult result in results) {
        print('Device found: ${result.device.name} - ${result.device.id}');
        if (result.device.name == "ESP32_Sensor") {
          print('ESP32_Sensor found, trying to connect...');
          connectToDevice(result.device);
          scanSubscription?.cancel();
          break;
        }
      }
    });

    flutterBlue.stopScan().then((_) {
      setState(() {
        isScanning = false;
      });
      print('Scan stopped.');
      scanSubscription?.cancel();
    });
  }

  void connectToDevice(BluetoothDevice device) async {
    await device.connect();
    setState(() {
      connectedDevice = device;
    });
    discoverServices(device);
  }

  void discoverServices(BluetoothDevice device) async {
    List<BluetoothService> services = await device.discoverServices();
    setState(() {
      bluetoothServices = services;
    });
    readDataFromDevice(device);
  }

  void readDataFromDevice(BluetoothDevice device) async {
    for (BluetoothService service in bluetoothServices) {
      for (BluetoothCharacteristic characteristic in service.characteristics) {
        if (characteristic.properties.notify) {
          characteristic.value.listen((value) {
            String sensorData = String.fromCharCodes(value);
            print('New data: $sensorData');
          });
          await characteristic.setNotifyValue(true);
        }
      }
    }
  }

  void disconnectFromDevice(BluetoothDevice device) async {
    await device.disconnect();
    setState(() {
      connectedDevice = null;
      bluetoothServices = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Bluetooth Connect'),
        ),
        body: Column(
          children: <Widget>[
            ElevatedButton(
              child: Text(isScanning ? 'Stop Scan' : 'Start Scan'),
              onPressed: isScanning ? null : startScan,
            ),
            if (connectedDevice != null)
              ListTile(
                title: Text(connectedDevice!.name ?? 'Connected Device'),
                subtitle: Text(connectedDevice!.id.toString()),
                trailing: ElevatedButton(
                  child: const Text('Disconnect'),
                  onPressed: () => disconnectFromDevice(connectedDevice!),
                ),
              )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    flutterBlue.stopScan();
    scanSubscription?.cancel();  // Cancel the subscription when the widget is disposed
    if (connectedDevice != null) {
      disconnectFromDevice(connectedDevice!);
    }
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter_blue/flutter_blue.dart';
// import 'package:permission_handler/permission_handler.dart';
//
// class ConnectionScreen extends StatefulWidget {
//   @override
//   _ConnectionScreenState createState() => _ConnectionScreenState();
// }
//
// class _ConnectionScreenState extends State<ConnectionScreen> {
//   FlutterBlue flutterBlue = FlutterBlue.instance;
//   bool isScanning = false;
//   List<BluetoothDevice> devicesList = [];
//   BluetoothDevice? connectedDevice;
//   List<BluetoothService> bluetoothServices = [];
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
//     final info = statuses[Permission.location]?.isGranted ?? false;  // Checking location permissions
//     print('Location permission: $info');
//
//     // Automatically start scanning if permissions are granted
//     if ((statuses[Permission.bluetoothScan]?.isGranted ?? false) &&
//         (statuses[Permission.bluetoothConnect]?.isGranted ?? false) &&
//         info) {
//       startScan();
//     } else {
//       // Handle the scenario when permissions are denied
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
//     var subscription = flutterBlue.scanResults.listen((List<ScanResult> results) {
//       for (ScanResult result in results) {
//         print('${result.device.name} found! rssi: ${result.rssi}');
//         if (!devicesList.any((device) => device.id == result.device.id)) {
//           setState(() {
//             devicesList.add(result.device);
//           });
//         }
//       }
//     });
//
//     flutterBlue.stopScan().then((_) {
//       setState(() {
//         isScanning = false;
//       });
//       subscription.cancel();
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
//             //TODO: 解析sensorData字符串，并更新UI
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
//             Expanded(
//               child: ListView.builder(
//                 itemCount: devicesList.length,
//                 itemBuilder: (BuildContext context, int index) {
//                   BluetoothDevice device = devicesList[index];
//                   String deviceName = device.name ?? 'Unknown Device';
//                   if(deviceName.isEmpty){
//                     deviceName = device.id.toString(); //If the device name is empty, show the device ID
//                   }
//                   return ListTile(
//                     title: Text(devicesList[index].name ?? 'Unknown Device'),
//                     subtitle: Text(devicesList[index].id.toString()),
//                     onTap: () => connectToDevice(devicesList[index]),
//                   );
//                 },
//               ),
//             ),
//             ElevatedButton(
//               child: const Text('Disconnect'),
//               onPressed: connectedDevice != null ? () => disconnectFromDevice(connectedDevice!) : null,
//             ),
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
//     if (connectedDevice != null) {
//       disconnectFromDevice(connectedDevice!);
//     }
//   }
// }
