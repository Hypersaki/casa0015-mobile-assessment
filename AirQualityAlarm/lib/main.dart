import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
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
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()?.requestPermission();
  await NotificationService().init(); //
  runApp(
      MyApp()
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
  isGranted = await Permission.bluetoothScan
      .request()
      .isGranted;
  print(isGranted);
  statuses.forEach((key, value) {
    print('$key------>$value');
    isGranted = isGranted && value.isGranted;
  });
  return isGranted;
}

class MyApp extends StatelessWidget {
  MyApp({super.key});


  final btManager = BluetoothManager();
  @override
  Widget build(BuildContext context) {


    return ChangeNotifierProvider(
      create: (context)=>SensorData(),
      builder: (context, widget) {
        return Consumer<SensorData>(
          builder: (context, provider, child) {
            btManager.setSensorData(provider);
            btManager.connect();
            return MaterialApp(
              title: 'Air Quality Alarm',
              theme: ThemeData(
                primarySwatch: Colors.blue,
              ),
              home: const BtmNavigationBar(),
            );
          },
        );
      },
    );
  }
}
