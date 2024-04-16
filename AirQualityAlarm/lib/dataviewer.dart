import 'package:flutter/material.dart';
// Make sure to import the humidity correctly
import 'data_hr.dart'; // Replace with the correct import path for your HumidityDataScreen

class DataViewer extends StatefulWidget {
  @override
  _DataViewerState createState() => _DataViewerState();
}

class _DataViewerState extends State<DataViewer> {
  // These values are assumed to be dynamic and updated accordingly
  double humidity = 0; // Initialize with a default value or fetch from a model
  int co2 = 400; // in parts per million (ppm)
  int co = 6; // in ppm
  double temperature = 0; // in Celsius

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Data Viewer'),
        ),
        body: ListView(
          children: <Widget>[
            _buildSensorTile('Humidity', '$humidity%', () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => HumidityDataScreen()),
              );
            }),
            _buildSensorTile('CO2', '$co2 ppm', () {
              // Add navigation logic to CO2 detail page
            }),
            _buildSensorTile('CO', '$co ppm', () {
              // Add navigation logic to CO detail page
            }),
            _buildSensorTile('Temperature', '$temperature °C', () {
              // Add navigation logic to Temperature detail page
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildSensorTile(String title, String value, VoidCallback onTap) {
    return ListTile(
      leading: Icon(
        Icons.square, // Replace with the actual icon
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
      onTap: onTap,
    );
  }
}
