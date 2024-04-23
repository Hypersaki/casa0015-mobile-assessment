import 'package:flutter/material.dart';
import 'package:airqualityalarm/sensordata.dart';
import 'package:airqualityalarm/notification.dart'; // Import the NotificationService
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import shared_preferences

class SmokeDetailScreen extends StatefulWidget {
  final SensorData sensorData;

  SmokeDetailScreen({Key? key, required this.sensorData}) : super(key: key);

  @override
  _SmokeDetailScreenState createState() => _SmokeDetailScreenState();
}

class _SmokeDetailScreenState extends State<SmokeDetailScreen> {
  Map<String, bool> starStatus = {'Good': false, 'Poor': false, 'Bad': false};
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    NotificationService().init();
    _loadSettings();
  }

  void _loadSettings() async {
    prefs = await SharedPreferences.getInstance();
    starStatus['Poor'] = prefs.getBool('SMKPoor') ?? false;
    starStatus['Bad'] = prefs.getBool('SMKBad') ?? false;
    setState(() {});
  }

  void onStarTap(String status) {
    setState(() {
      starStatus[status] = !starStatus[status]!;
      prefs.setBool('SMK' + status, starStatus[status]!);
      widget.sensorData.updateStarStatus('SMK' + status, starStatus[status]!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Details of Smoke Levels'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Placeholder(fallbackHeight: 200.0), // TODO: change to a picture
            SizedBox(height: 20),
            Center(
              child: Consumer<SensorData>(
                builder: (context, sensorData, child) {
                  return Text(
                    '${sensorData.smoke.toStringAsFixed(1)} ppm',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: Text(
                'Reference Threshold',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 10),
            ThresholdIndicator(
              value: widget.sensorData.smoke,
              goodMin: widget.sensorData.SMKGoodMin,
              goodMax: widget.sensorData.SMKGoodMax,
              poorMin: widget.sensorData.SMKPoorMin,
              poorMax: widget.sensorData.SMKPoorMax,
              starStatus: starStatus,
              onStarTap: onStarTap,
            ),
          ],
        ),
      ),
    );
  }
}

class ThresholdIndicator extends StatelessWidget {
  final double value;
  final double goodMin;
  final double goodMax;
  final double poorMin;
  final double poorMax;
  final Map<String, bool> starStatus;
  final Function(String) onStarTap;

  const ThresholdIndicator({
    Key? key,
    required this.value,
    required this.goodMin,
    required this.goodMax,
    required this.poorMin,
    required this.poorMax,
    required this.starStatus,
    required this.onStarTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String threshold = value >= goodMin && value <= goodMax
        ? 'Good'
        : (value >= poorMin && value <= poorMax ? 'Poor' : 'Bad');

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ThresholdLabel(
          threshold: 'Poor',
          value: 'Poor: ≥${poorMin} ppm',
          isActive: starStatus['Poor'] ?? false,
          onSelected: () => onStarTap('Poor'),
        ),
        ThresholdLabel(
          threshold: 'Bad',
          value: 'Bad: ≥${poorMax} ppm',
          isActive: starStatus['Bad'] ?? false,
          onSelected: () => onStarTap('Bad'),
        ),
      ],
    );
  }
}

class ThresholdLabel extends StatelessWidget {
  final String threshold;
  final String value;
  final bool isActive;
  final VoidCallback onSelected;

  const ThresholdLabel({
    Key? key,
    required this.threshold,
    required this.value,
    required this.isActive,
    required this.onSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onSelected,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            Icon(
              isActive ? Icons.star : Icons.star_border,
              color: Colors.orange,
            ),
          ],
        ),
      ),
    );
  }
}
