// import 'package:flutter/material.dart';
//
// class dataviewer extends StatefulWidget {
//   const dataviewer({super.key});
//
//   @override
//   State<dataviewer> createState() => _dataviewerState();
// }
//
// class _dataviewerState extends State<dataviewer> {
//   @override
//   Widget build(BuildContext context) {
//     return const Placeholder();
//   }
// }
import 'package:flutter/material.dart';

class dataviewer extends StatefulWidget {
  @override
  _dataviewerstate createState() => _dataviewerstate();
}

class _dataviewerstate extends State<dataviewer> {
  // Assuming these values are dynamic and can be updated
  double humidity = 12.5; // Initialize with a default value or fetch from a model
  int co2 = 400; // in ppm
  int co = 6; // in ppm
  double temperature = 22.0; // in Celsius

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Data Viewer'),
        ),
        body: ListView(
          children: <Widget>[
            _buildSensorTile('Humidity', '$humidity%'),
            _buildSensorTile('CO2', '$co2 ppm'),
            _buildSensorTile('CO', '$co ppm'),
            _buildSensorTile('Temperature', '$temperature °C'),
          ],
        ),
      ),
    );
  }

  Widget _buildSensorTile(String title, String value) {
    return ListTile(
      leading: Icon(
        Icons.square, // Replace with actual leading icon
        color: Colors.grey,
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
    );
  }
}