import 'package:flutter/material.dart';

class DataDetailScreen extends StatelessWidget {
  final String title;
  final String value;
  final String detailScreenName;

  DataDetailScreen({required this.title, required this.value, required this.detailScreenName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title + ' Details'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(value, style: TextStyle(fontSize: 24)),
            SizedBox(height: 20),
            Text('Details for ' + title),
            // Here add more UI elements to modify thresholds etc.
          ],
        ),
      ),
    );
  }
}