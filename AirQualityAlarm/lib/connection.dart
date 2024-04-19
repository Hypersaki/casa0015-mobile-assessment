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
  bool isConnecting = false;
  bool get isConnected => connection != null && connection!.isConnected;

  @override
  void initState() {
    super.initState();
  }

  void connect() async {
    setState(() {
      isConnecting = true;
    });

    try {
      connection = await BluetoothConnection.toAddress(targetMac);
      print('Connected to the device');
      setState(() {
        isConnecting = false;
      });

      connection!.input!.listen((data) {
        // TODO: Process the incoming data
        print('Data incoming: ${String.fromCharCodes(data)}');
        final values = String.fromCharCodes(data).trim().split(',');
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
        if (mounted) {
          setState(() {
            isConnecting = false;
            connection = null;
          });
          showReconnectDialog();
        }
      });
    } catch (e) {
      print('Cannot connect, exception occurred');
      if (mounted) {
        setState(() {
          isConnecting = false;
        });
        showFailedDialog();
      }
    }
  }

  void disconnect() async {
    await connection?.close();
    if (mounted) {
      setState(() {
        connection = null;
      });
    }
  }

  void showReconnectDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Connection lost'),
          content: const Text('The connection to the device was lost.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                if (!isConnected) {
                  connect();
                }
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('ESP32 Connection'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(isConnecting ? 'Connecting to $targetMac' : isConnected ? 'Connected to $targetMac' : 'Press the button to connect to $targetMac'),
            SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: isConnecting ? Colors.grey : isConnected ? Colors.green : Colors.blue,
                foregroundColor: Colors.white,
              ),
              onPressed: isConnecting ? null : isConnected ? disconnect : connect,
              child: Text(isConnected ? 'Disconnect' : 'Connect'),
            ),
            // Add additional UI to display data here
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    connection?.dispose();
  }
}