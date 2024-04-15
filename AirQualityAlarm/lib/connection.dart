import 'package:flutter/material.dart';

// class connection extends StatefulWidget {
//   const connection({super.key});
//
//   @override
//   State<connection> createState() => _connectionstate();
// }
//
// class _connectionstate extends State<connection> {
//   @override
//   Widget build(BuildContext context) {
//     return const Placeholder();
//   }
// }
import 'package:flutter_blue/flutter_blue.dart'; // Make sure to add flutter_blue to your pubspec.yaml

class connection extends StatefulWidget {
  @override
  _connectionstate createState() => _connectionstate();
}

class _connectionstate extends State<connection> {
  FlutterBlue flutterBlue = FlutterBlue.instance;
  bool isScanning = false;
  List<BluetoothDevice> devicesList = [];

  @override
  void initState() {
    super.initState();
    flutterBlue.connectedDevices
        .then((List<BluetoothDevice> connectedDevices) {
      setState(() {
        devicesList = connectedDevices;
      });
    });
  }

  void startScan() {
    setState(() {
      isScanning = true;
    });

    flutterBlue.startScan(timeout: Duration(seconds: 4));

    // Listen to scan results
    var subscription = flutterBlue.scanResults.listen((List<ScanResult> results) {
      // do something with scan results
      for (ScanResult result in results) {
        print('${result.device.name} found! rssi: ${result.rssi}');
      }
    });

    // Stop scanning
    flutterBlue.stopScan().then((_) {
      setState(() {
        isScanning = false;
      });
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
            Expanded(
              child: ListView.builder(
                itemCount: devicesList.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(devicesList[index].name),
                    subtitle: Text(devicesList[index].id.toString()),
                    onTap: () => _connectToDevice(devicesList[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _connectToDevice(BluetoothDevice device) async {
    await device.connect();
    // Update the UI or navigate to another screen after successful connection
  }

  @override
  void dispose() {
    super.dispose();
    flutterBlue.stopScan(); // Stop scanning when the widget is disposed
  }
}