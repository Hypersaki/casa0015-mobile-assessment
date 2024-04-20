import 'package:flutter/material.dart';
import 'package:airqualityalarm/sensordata.dart';

class SmokeDetailScreen extends StatefulWidget {
  final SensorData sensorData;

  SmokeDetailScreen({Key? key, required this.sensorData}) : super(key: key);

  @override
  _SmokeDetailScreenState createState() => _SmokeDetailScreenState();
}

class _SmokeDetailScreenState extends State<SmokeDetailScreen> {
  bool isGoodStarSelected = false;
  bool isPoorStarSelected = false;
  bool isBadStarSelected = false;

  @override
  Widget build(BuildContext context) {
    String thresholdStatus = widget.sensorData.SMKStatus;
    isGoodStarSelected = thresholdStatus == 'Good';
    isPoorStarSelected = thresholdStatus == 'Poor';
    isBadStarSelected = thresholdStatus == 'Bad';

    return Scaffold(
      appBar: AppBar(
        title: Text('Smoke'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Placeholder(fallbackHeight: 200.0),  // This can be replaced with an actual image
            SizedBox(height: 20),
            Center(
              child: Text(
                '${widget.sensorData.smoke.toStringAsFixed(1)} ppm',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Reference Threshold',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            ThresholdIndicator(
              value: widget.sensorData.smoke,
              goodMin: widget.sensorData.SMKGoodMin,
              goodMax: widget.sensorData.SMKGoodMax,
              poorMin: widget.sensorData.SMKPoorMin,
              poorMax: widget.sensorData.SMKPoorMax,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _buildSelectableStar(isGoodStarSelected, 'Good'),
                _buildSelectableStar(isPoorStarSelected, 'Poor'),
                _buildSelectableStar(isBadStarSelected, 'Bad'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectableStar(bool isSelected, String status) {
    return IconButton(
      icon: Icon(
        isSelected ? Icons.star : Icons.star_border,
        color: isSelected ? Colors.orange : Colors.grey,
      ),
      onPressed: () {
        setState(() {
          if (status == 'Good') {
            isGoodStarSelected = !isGoodStarSelected;
          } else if (status == 'Poor') {
            isPoorStarSelected = !isPoorStarSelected;
          } else if (status == 'Bad') {
            isBadStarSelected = !isBadStarSelected;
          }
        });
      },
    );
  }
}


class ThresholdIndicator extends StatelessWidget {
  final double value;
  final double goodMin;
  final double goodMax;
  final double poorMin;
  final double poorMax;

  const ThresholdIndicator({
    Key? key,
    required this.value,
    required this.goodMin,
    required this.goodMax,
    required this.poorMin,
    required this.poorMax,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String threshold;
    Color color;

    if (value >= goodMin && value <= goodMax) {
      threshold = 'Good';
      color = Colors.green;
    } else if ((value >= poorMin && value < goodMin) || (value > goodMax && value <= poorMax)) {
      threshold = 'Poor';
      color = Colors.amber;
    } else {
      threshold = 'Bad';
      color = Colors.red;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ThresholdLabel(threshold: 'Good', value: '${goodMin}%-${goodMax}%', isActive: threshold == 'Good'),
        ThresholdLabel(threshold: 'Poor', value: '${poorMin}%-${poorMax}%', isActive: threshold == 'Poor'),
        ThresholdLabel(threshold: 'Bad', value: '<${poorMin}% or >${poorMax}%', isActive: threshold == 'Bad'),
      ],
    );
  }
}

class ThresholdLabel extends StatelessWidget {
  final String threshold;
  final String value;
  final bool isActive;

  const ThresholdLabel({
    Key? key,
    required this.threshold,
    required this.value,
    required this.isActive,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          threshold,
          style: TextStyle(
            fontSize: 18,
            color: isActive ? Colors.blue : Colors.grey,
          ),
        ),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            color: isActive ? Colors.black : Colors.grey,
          ),
        ),
        if (isActive)
          Icon(
            Icons.star,
            color: Colors.orange,
          ),
      ],
    );
  }
}
