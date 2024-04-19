import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:airqualityalarm/sensordata.dart';

class BluetoothConnect extends StatefulWidget {
  @override
  _BluetoothConnectState createState() => _BluetoothConnectState();
}

class _BluetoothConnectState extends State<BluetoothConnect> {
  final String targetMac = "08:3A:8D:AC:49:FA";
  BluetoothConnection? connection;
  bool isConnecting = false; // add isConnecting and ini

  @override
  void initState() {
    super.initState();
    var sensorData = Provider.of<SensorData>(context, listen: false);
    if (sensorData.isConnected && connection == null) {
      reconnect(); // try to reconnect
    }
  }

  void connect() async {
    setState(() {
      isConnecting = true; // when connecting - set true
      Provider.of<SensorData>(context, listen: false).updateConnectionStatus(true);
    });

    try {
      connection = await BluetoothConnection.toAddress(targetMac);
      print('Connected to the device');
      setState(() {
        isConnecting = false; // connection complete - set false
        Provider.of<SensorData>(context, listen: false).updateConnectionStatus(true);
      });

      connection!.input!.listen((data) {
        String receivedData = String.fromCharCodes(data).trim();
        print('Received data: $receivedData');
        final values = receivedData.split(',');
        if (values.length == 5) {
          final sensorData = Provider.of<SensorData>(context, listen: false);
          sensorData.update(
            double.tryParse(values[0]) ?? 0.0,
            double.tryParse(values[1]) ?? 0.0,
            double.tryParse(values[2]) ?? 0.0,
            double.tryParse(values[3]) ?? 0.0,
            double.tryParse(values[4]) ?? 0.0,
          );
        }
      }).onDone(() {
        Provider.of<SensorData>(context, listen: false).updateConnectionStatus(false);
        if (mounted) {
          showReconnectDialog();
        }
      });
    } catch (e) {
      print('Cannot connect, exception occurred');
      if (mounted) {
        setState(() {
          isConnecting = false; // connection fail - set false
          Provider.of<SensorData>(context, listen: false).updateConnectionStatus(false);
        });
        showFailedDialog();
      }
    }
  }

  void disconnect() async {
    await connection?.close();
    setState(() {
      connection = null; // 清除连接对象
      Provider.of<SensorData>(context, listen: false).updateConnectionStatus(false);
    });
  }

  void reconnect() {
    connect(); // Directly trying to reconnect
  }

  void showReconnectDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Connection lost'),
          content: const Text('The connection to the device was lost. Would you like to reconnect?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                connect(); // try to reconnect
              },
              child: const Text('Reconnect'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void showFailedDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Connection failed'),
          content: const Text('Could not connect to the device.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isConnected = Provider.of<SensorData>(context).isConnected;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sensor Device Connection'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(isConnected ? 'Connected to the Sensor Device' : 'Press the button to connect to the Sensor Device'),
            SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: isConnecting ? Colors.grey : isConnected ? Colors.green : Colors.blue,
                foregroundColor: Colors.white,
              ),
              onPressed: isConnecting ? null : isConnected ? disconnect : connect,
              child: Text(isConnecting ? 'Connecting...' : isConnected ? 'Disconnect' : 'Connect'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    connection?.dispose();
    Provider.of<SensorData>(context, listen: false).updateConnectionStatus(false);
  }
}
