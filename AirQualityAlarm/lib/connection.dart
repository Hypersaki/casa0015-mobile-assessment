import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:airqualityalarm/bt_model_class.dart';  // Assuming the model class is in this file

class BluetoothConnect extends StatefulWidget {
  @override
  _BluetoothConnectState createState() => _BluetoothConnectState();
}

class _BluetoothConnectState extends State<BluetoothConnect> {
  final String targetMac = "08:3A:8D:AC:49:FA";
  BluetoothConnection? connection;
  late BluetoothDataModel model;

  @override
  void initState() {
    super.initState();
    model = ScopedModel.of<BluetoothDataModel>(context, rebuildOnChange: false);
  }

  void connect() async {
    model.updateConnectionStatus('Connecting');
    try {
      connection = await BluetoothConnection.toAddress(targetMac);
      setState(() {
        model.updateConnectionStatus('Connected');
      });
      connection!.input!.listen((data) {
        model.updateData(String.fromCharCodes(data));
      }).onDone(() {
        model.updateConnectionStatus('Disconnected');
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Connection Lost'),
            content: Text('Do you want to reconnect?'),
            actions: <Widget>[
              TextButton(
                child: Text('Reconnect'),
                onPressed: () {
                  Navigator.pop(context);
                  connect();
                },
              ),
              TextButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      });
    } catch (e) {
      setState(() {
        model.updateConnectionStatus('Connection Failed');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Bluetooth Connection')),
      body: ScopedModelDescendant<BluetoothDataModel>(
        builder: (context, child, model) => Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Status: ${model.connectionStatus}'),
            ElevatedButton(
              onPressed: model.connectionStatus == 'Disconnected' ? connect : null,
              child: Text(model.connectionStatus == 'Connecting' ? 'Connecting' : 'Connect'),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
                  if (states.contains(MaterialState.disabled)) return Colors.grey;
                  return model.connectionStatus == 'Connected' ? Colors.green :
                  model.connectionStatus == 'Connection Failed' ? Colors.red : Colors.blue;
                }),
              ),
            ),
            Text('Humidity: ${model.humidity}'),
            Text('Temperature: ${model.temperature}'),
            Text('VOCs: ${model.vocs}'),
            Text('CO: ${model.co}'),
            Text('Smoke: ${model.smoke}'),
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