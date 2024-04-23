import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:airqualityalarm/sensordata.dart';
import 'package:airqualityalarm/ThresholdsIndicators/hr_thr_ind.dart';
import 'package:airqualityalarm/ThresholdsIndicators/temp_thr_ind.dart';
import 'package:airqualityalarm/ThresholdsIndicators/co_thr_ind.dart';
import 'package:airqualityalarm/ThresholdsIndicators/vocs_thr_ind.dart';
import 'package:airqualityalarm/ThresholdsIndicators/smk_thr_ind.dart';

class DataViewer extends StatefulWidget {
  @override
  _DataViewerState createState() => _DataViewerState();
}

class _DataViewerState extends State<DataViewer> {
  @override
  Widget build(BuildContext context) {
    SensorData sensorData = Provider.of<SensorData>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Data Viewer'),
      ),
      body: Consumer<SensorData>(
        builder: (context, sensorData, child) {
          return ListView(
            children: <Widget>[
              _buildSensorTile(context, 'humidity', sensorData.humidity),
              _buildSensorTile(context, 'temperature', sensorData.temperature),
              _buildSensorTile(context, 'vocs', sensorData.vocs),
              _buildSensorTile(context, 'co', sensorData.co),
              _buildSensorTile(context, 'smoke', sensorData.smoke),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSensorTile(BuildContext context, String type, double value) {
    String title;
    Widget destinationScreen;

    switch (type) {
      case 'humidity':
        title = 'Humidity';
        destinationScreen = HumidityDetailScreen(
            sensorData: Provider.of<SensorData>(context, listen: false));
        break;
      case 'temperature':
        title = 'Temperature';
        destinationScreen = TemperatureDetailScreen(
            sensorData: Provider.of<SensorData>(context, listen: false));
        break;
      case 'vocs':
        title = 'VOCs';
        destinationScreen = VOCsDetailScreen(
            sensorData: Provider.of<SensorData>(context, listen: false));
        break;
      case 'co':
        title = 'CO';
        destinationScreen = CODetailScreen(
            sensorData: Provider.of<SensorData>(context, listen: false));
        break;
      case 'smoke':
        title = 'Smoke';
        destinationScreen = SmokeDetailScreen(
            sensorData: Provider.of<SensorData>(context, listen: false));
        break;
      default:
        title = 'Unknown';
        destinationScreen = Text('Unknown type');
        break;
    }

    return ListTile(
      leading: Icon(Icons.sensors, color: Colors.blue, size: 30),
      title: Text(title),
      subtitle: Text('${value.toStringAsFixed(2)} ${Provider
          .of<SensorData>(context, listen: false)
          .units[type] ?? ""}'),
      trailing: Icon(Icons.arrow_forward),
      onTap: () {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => destinationScreen));
      },
    );
  }
}
