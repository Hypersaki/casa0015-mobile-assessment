import 'package:flutter/material.dart';
import 'package:airqualityalarm/sensordata.dart';
import 'package:airqualityalarm/notification.dart'; // Import the NotificationService
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import shared_preferences

class HumidityDetailScreen extends StatefulWidget {
  final SensorData sensorData;

  HumidityDetailScreen({Key? key, required this.sensorData}) : super(key: key);

  @override
  _HumidityDetailScreenState createState() => _HumidityDetailScreenState();
}

class _HumidityDetailScreenState extends State<HumidityDetailScreen> {
  // defined star status
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
    starStatus['Poor'] = prefs.getBool('HrPoor') ?? false;
    starStatus['Bad'] = prefs.getBool('HrBad') ?? false;
    setState(() {});
  }

  void onStarTap(String status) {
    if (status == 'Good') return; // no good

    setState(() {
      starStatus[status] = !starStatus[status]!;
      prefs.setBool('Hr' + status, starStatus[status]!);
      widget.sensorData.updateStarStatus('Hr' + status, starStatus[status]!);
    });
  }

  @override
  Widget build(BuildContext context) {
    final SensorData sensorData;
    String thresholdStatus = widget.sensorData.HrStatus;

    return Scaffold(
      appBar: AppBar(
        title: Text('Details of Humidity'),
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
                    '${sensorData.humidity.toStringAsFixed(1)}%',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            Center( // center reference threshold
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
              value: widget.sensorData.humidity,
              goodMin: widget.sensorData.HrGoodMin,
              goodMax: widget.sensorData.HrGoodMax,
              poorMin: widget.sensorData.HrPoorMin,
              poorMax: widget.sensorData.HrPoorMax,
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
                child: Text('Good: ${goodMin}% - ${goodMax}%'),
              ),
              SizedBox(height: 10.0),
              ThresholdLabel(
                threshold: 'Poor',
                value: 'Poor: ${poorMin}% - ${goodMin}% OR ${goodMax}% - ${poorMax}%',
                isActive: starStatus['Poor'] ?? false,
                onSelected: () => onStarTap('Poor'),
              ),
              SizedBox(height: 8.0),
              ThresholdLabel(
                threshold: 'Bad',
                value: 'Bad: <${poorMin}% OR >${poorMax}%',
                isActive: starStatus['Bad'] ?? false,
                onSelected: () => onStarTap('Bad'),
              ),
            ],
          ),
        ),
      ],
    );

    // return Column(
    //   mainAxisAlignment: MainAxisAlignment.center,
    //   children: [
    //     Padding(
    //         padding: EdgeInsets.all(8.0),
    //         child: Text(
    //           'Good: ${goodMin}% - ${goodMax}%',
    //         )
    //     ),
    //     ThresholdLabel(
    //       threshold: 'Poor',
    //       value: 'Poor: ${poorMin}%-${goodMin}% OR ${goodMax}-%${poorMax}%',
    //       isActive: starStatus['Poor'] ?? false,
    //       onSelected: () => onStarTap('Poor'),
    //     ),
    //     ThresholdLabel(
    //       threshold: 'Bad',
    //       value: 'Bad: <${poorMin}% OR >${poorMax}%',
    //       isActive: starStatus['Bad'] ?? false,
    //       onSelected: () => onStarTap('Bad'),
    //     ),
    //   ],
    // );
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
