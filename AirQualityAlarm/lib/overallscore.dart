import 'package:flutter/material.dart';

class OverallScore extends StatefulWidget {
  @override
  _OverallScoreState createState() => _OverallScoreState();
}

class _OverallScoreState extends State<OverallScore> {
  // Assuming score is a dynamic value that can be updated
  int score = 73; // Initialize with a default value or fetch from a model

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Overall Score'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 20),
            Center(
              child: CircularProgressIndicator(
                value: score / 100, // Now this is dynamic and can be updated
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                strokeWidth: 6,
              ),
            ),
            SizedBox(height: 40),
            Text(
              '$score', // Now this is dynamic and can be updated
              style: TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: GridView.count(
                crossAxisCount: 3,
                children: List.generate(6, (index) {
                  return Card(
                    child: Center(
                      child: Icon(
                        Icons.data_usage_sharp, // Replace with the appropriate icon
                        size: 50,
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

