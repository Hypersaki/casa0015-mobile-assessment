import 'package:flutter/material.dart';

class HumidityDataScreen extends StatefulWidget {
  @override
  _HumidityDataScreenState createState() => _HumidityDataScreenState();
}

class _HumidityDataScreenState extends State<HumidityDataScreen> {
  //
  bool isNormalRangeStarred = false;
  bool isHighRangeStarred = false;
  bool isLowRangeStarred = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Humidity Data'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Humidity:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'current value:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '55%', //this part needs to be modified
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Threshold:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            _buildThresholdRow('normal', '30% - 60%', isNormalRangeStarred, () {
              setState(() {
                isNormalRangeStarred = !isNormalRangeStarred;
              });
            }),
            _buildThresholdRow('high', '> 60%', isHighRangeStarred, () {
              setState(() {
                isHighRangeStarred = !isHighRangeStarred;
              });
            }),
            _buildThresholdRow('low', '< 30%', isLowRangeStarred, () {
              setState(() {
                isLowRangeStarred = !isLowRangeStarred;
              });
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildThresholdRow(String title, String range, bool isStarred, VoidCallback toggleStar) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
        ),
      ),
      subtitle: Text(range),
      trailing: IconButton(
        icon: Icon(
          isStarred ? Icons.star : Icons.star_border,
          color: isStarred ? Colors.orange : Colors.grey,
        ),
        onPressed: toggleStar,
      ),
    );
  }
}
