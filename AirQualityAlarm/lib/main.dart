import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:airqualityalarm/notification.dart';
import 'package:airqualityalarm/sensordata.dart';
import 'package:airqualityalarm/navigationbar.dart';
import 'package:airqualityalarm/btmanager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var d = await check();
  print('------->${d}');
  await NotificationService().init(); //
  runApp(
    Provider<SensorData>(
      create: (context) => SensorData(),
      child: MyApp(),
    ),
  );
}

Future<bool> check() async {
  bool isGranted = false;
  Map<Permission, PermissionStatus> statuses = await [
    Permission.location,
    Permission.bluetooth,
    Permission.bluetoothConnect,
    Permission.bluetoothScan,
    Permission.bluetoothAdvertise,
  ].request();
  isGranted = await Permission.bluetoothScan.request().isGranted;
  print(isGranted);
  statuses.forEach((key, value) {
    print('$key------>$value');
    isGranted = isGranted && value.isGranted;

  });
  return isGranted;
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
