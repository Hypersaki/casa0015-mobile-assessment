import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dataviewerlist/data_hr.dart';
import 'package:airqualityalarm/sensordata.dart';


class DataViewer extends StatefulWidget {
  @override
  _DataViewerState createState() => _DataViewerState();
}

class _DataViewerState extends State<DataViewer> {
  @override
  Widget build(BuildContext context) {
    // 通过Provider来监听SensorData的变化
    return Consumer<SensorData>(
      builder: (context, sensorData, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Data Viewer'),
          ),
          body: ListView(
            children: <Widget>[
              _buildSensorTile('Humidity', '${sensorData.humidity}%', () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => HumidityDataScreen(humidity: sensorData.humidity)),
                );
              }),
              _buildSensorTile('Temperature', '${sensorData.temperature} °C', () {
                // 导航至Temperature修改页面
              }),
              _buildSensorTile('VOCs', '${sensorData.ppmVOCs} ppm', () {
                // 导航至VOCs修改页面
              }),
              _buildSensorTile('CO', '${sensorData.ppmCO} ppm', () {
                // 导航至CO修改页面
              }),
              _buildSensorTile('Smoke', '${sensorData.ppmSmoke} ppm', () {
                // 导航至Smoke修改页面
              }),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSensorTile(String title, String value, VoidCallback onTap) {
    return ListTile(
      leading: Icon(
        Icons.sensor_window, // 更换为更合适的图标
        color: Colors.blue,
        size: 30,
      ),
      title: Text(title),
      trailing: Text(
        value,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      onTap: onTap,
    );
  }
}
