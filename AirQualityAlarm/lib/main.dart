import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:airqualityalarm/sensordata.dart';
import 'package:airqualityalarm/navigationbar.dart';
import 'package:airqualityalarm/btmanager.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // create SensorData sl
    final sensorData = SensorData();
    // get BluetoothManager dl
    final btManager = BluetoothManager();
    // SensorData to BluetoothManager sl
    btManager.setSensorData(sensorData);
    // try to connect
    btManager.connect();

    return ChangeNotifierProvider(
      create: (context) => sensorData,
      child: MaterialApp(
        title: 'Air Quality Alarm',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const BtmNavigationBar(),
      ),
    );
  }
}
