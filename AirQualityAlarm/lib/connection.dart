// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:airqualityalarm/sensordata.dart';
// import 'package:airqualityalarm/btmanager.dart';  // Import the BluetoothManager class
//
// class BluetoothConnect extends StatefulWidget {
//   @override
//   _BluetoothConnectState createState() => _BluetoothConnectState();
// }
//
// class _BluetoothConnectState extends State<BluetoothConnect> {
//   final BluetoothManager bluetoothManager = BluetoothManager();
//
//   @override
//   void initState() {
//     super.initState();
//     // Check if already connected on init and reconnect if necessary
//     var sensorData = Provider.of<SensorData>(context, listen: false);
//     if (!bluetoothManager.isConnected && !bluetoothManager.isConnecting) {
//       bluetoothManager.connect(sensorData);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     var sensorData = Provider.of<SensorData>(context, listen: false);
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Sensor Device Connection'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Text(sensorData.isConnected ? 'Connected to the Sensor Device' : 'Press the button to connect to the Sensor Device'),
//             SizedBox(height: 10),
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: bluetoothManager.isConnecting ? Colors.grey : sensorData.isConnected ? Colors.green : Colors.blue,
//                 foregroundColor: Colors.white,
//               ),
//               onPressed: bluetoothManager.isConnecting ? null :
//               sensorData.isConnected ?
//                   () => bluetoothManager.disconnect() :
//                   () => bluetoothManager.connect(sensorData),
//               child: Text(bluetoothManager.isConnecting ? 'Connecting...' : sensorData.isConnected ? 'Disconnect' : 'Connect'),
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
//     bluetoothManager.disconnect();  // Ensure to disconnect when the widget is disposed
//     Provider.of<SensorData>(context, listen: false).updateConnectionStatus(false);
//   }
// }