import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:airqualityalarm/sensordata.dart';
import 'package:airqualityalarm/datadetailscreen.dart';

class DataViewer extends StatefulWidget {
  @override
  _DataViewerState createState() => _DataViewerState();
}

class _DataViewerState extends State<DataViewer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Viewer'),
      ),
      body: Consumer<SensorData>(
        builder: (context, sensorData, child) {
          return ListView(
            children: <Widget>[
              _buildSensorTile(context, 'humidity', 'HumidityDataScreen'),
              _buildSensorTile(context, 'temperature', 'TemperatureDataScreen'),
              _buildSensorTile(context, 'vocs', 'VOCsDataScreen'),
              _buildSensorTile(context, 'co', 'CODataScreen'),
              _buildSensorTile(context, 'smoke', 'SmokeDataScreen'),
            ],
          );
        },
      ),
    );
  }
}

  Widget _buildSensorTile(BuildContext context, String type, String detailScreenName) {
    final sensorData = Provider.of<SensorData>(context);
    String value = sensorData.getDataWithUnit(type);
    String title;
    switch (type) {
      case 'humidity':
        title = 'Humidity';
        break;
      case 'temperature':
        title = 'Temperature';
        break;
      case 'vocs':
        title = 'VOCs';
        break;
      case 'co':
        title = 'CO';
        break;
      case 'smoke':
        title = 'Smoke';
        break;
      default:
        title = 'Unknown';
    }

    return ListTile(
      leading: Icon(
        Icons.sensors,
        color: Colors.blue,
        size: 30,
      ),
      title: Text(title),
      subtitle: Text(value),
      trailing: Icon(Icons.arrow_forward),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) {
            return DataDetailScreen(title: title, value: value, detailScreenName: detailScreenName);
          }),
        );
      },
    );
  }