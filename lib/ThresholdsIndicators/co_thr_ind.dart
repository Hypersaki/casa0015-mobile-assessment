import 'package:flutter/material.dart';
import 'package:airqualityalarm/sensordata.dart';
import 'package:airqualityalarm/notification.dart'; // Import the NotificationService
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import shared_preferences

class CODetailScreen extends StatefulWidget {
  final SensorData sensorData;

  CODetailScreen({Key? key, required this.sensorData}) : super(key: key);

  @override
  _CODetailScreenState createState() => _CODetailScreenState();
}

class _CODetailScreenState extends State<CODetailScreen> {
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
    starStatus['Poor'] = prefs.getBool('COPoor') ?? false;
    starStatus['Bad'] = prefs.getBool('COBad') ?? false;
    setState(() {});
  }

  void onStarTap(String status) {
    setState(() {
      starStatus[status] = !starStatus[status]!;
      prefs.setBool('CO' + status, starStatus[status]!);
      widget.sensorData.updateStarStatus('CO' + status, starStatus[status]!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Details of CO Levels'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/images/env_img/png/co.png', height: 200.0),
            SizedBox(height: 20),
            Center(
              child: Consumer<SensorData>(
                builder: (context, sensorData, child) {
                  return Text(
                    '${sensorData.co.toStringAsFixed(1)} ppm',
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
              value: widget.sensorData.co,
              goodMin: widget.sensorData.COGoodMin,
              goodMax: widget.sensorData.COGoodMax,
              poorMin: widget.sensorData.COPoorMin,
              poorMax: widget.sensorData.COPoorMax,
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
        DefaultTextStyle(
          style: TextStyle(
            fontSize: 16.0,
            color: Colors.black,
          ),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Good: ≥ ${goodMin} ppm'),
              ),
              SizedBox(height: 10.0),  // Added spacing
              ThresholdLabel(
                threshold: 'Poor',
                value: 'Poor: ≥${poorMin} ppm',
                isActive: starStatus['Poor'] ?? false,
                onSelected: () => onStarTap('Poor'),
              ),
              SizedBox(height: 8.0),  // Added spacing
              ThresholdLabel(
                threshold: 'Bad',
                value: 'Bad: ≥${poorMax} ppm',
                isActive: starStatus['Bad'] ?? false,
                onSelected: () => onStarTap('Bad'),
              ),
            ],
          ),
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
