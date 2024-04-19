import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:airqualityalarm/sensordata.dart'; //
import 'package:airqualityalarm/datadetailscreen.dart'; //

class DataViewer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Viewer'),
      ),
      body: Consumer<SensorData>(
        builder: (context, sensorData, child) => ListView(
          children: <Widget>[
            _buildSensorTile(context, 'Humidity', '${sensorData.humidity}%', 'HumidityDataScreen'),
            _buildSensorTile(context, 'Temperature', '${sensorData.temperature} °C', 'TemperatureDataScreen'),
            _buildSensorTile(context, 'VOCs', '${sensorData.vocs} ppm', 'VOCsDataScreen'),
            _buildSensorTile(context, 'CO', '${sensorData.co} ppm', 'CODataScreen'),
            _buildSensorTile(context, 'Smoke', '${sensorData.smoke} ppm', 'SmokeDataScreen'),
          ],
        ),
      ),
    );
  }

  Widget _buildSensorTile(BuildContext context, String title, String value, String detailScreenName) {
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
            // 这里根据传递的detailScreenName动态选择要导航的页面
            return DataDetailScreen(title: title, value: value, detailScreenName: detailScreenName);
          }),
        );
      },
    );
  }
}