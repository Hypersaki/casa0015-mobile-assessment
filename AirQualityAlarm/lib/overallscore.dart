import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:airqualityalarm/sensordata.dart';

class OverallScoreScreen extends StatefulWidget {
  @override
  _OverallScoreScreenState createState() => _OverallScoreScreenState();
}

class _OverallScoreScreenState extends State<OverallScoreScreen> {
  int _statusPriority(String status) {
    switch (status) {
      case 'Bad':
        return 1;  // Highest priority
      case 'Poor':
        return 2;  // Poor priority
      case 'Good':
        return 3;  // Lowest priority
      default:
        return 4;  // Unknown status
    }
  }

  List<Widget> getStatusBars(SensorData sensorData) {
    List<StatusBar> bars = [
      StatusBar(status: sensorData.HrStatus, label: 'Humidity'),
      StatusBar(status: sensorData.TempStatus, label: 'Temperature'),
      StatusBar(status: sensorData.VOCsStatus, label: 'VOCs'),
      StatusBar(status: sensorData.COStatus, label: 'CO'),
      StatusBar(status: sensorData.SMKStatus, label: 'Smoke'),
    ];

    bars.sort((a, b) => _statusPriority(a.status).compareTo(_statusPriority(b.status)));
    return bars.map((bar) => bar.build(context)).toList();
  }

  double calculateOverallScore(SensorData sensorData) {
    double score = 0.0;
    score += sensorData.HrStatus == 'Good' ? 20 * 0.8 : sensorData.HrStatus == 'Poor' ? 10 * 0.8 : 0;
    score += sensorData.TempStatus == 'Good' ? 20 * 0.7 : sensorData.TempStatus == 'Poor' ? 10 * 0.7 : 0;
    score += sensorData.VOCsStatus == 'Good' ? 20 * 1.3 : sensorData.VOCsStatus == 'Poor' ? 10 * 1.3 : 0;
    score += sensorData.COStatus == 'Good' ? 20 * 1.1 : sensorData.COStatus == 'Poor' ? 10 * 1.1 : 0;
    score += sensorData.SMKStatus == 'Good' ? 20 * 1.1 : sensorData.SMKStatus == 'Poor' ? 10 * 1.1 : 0;
    return score;
  }

  Color getCircleColor(double score) {
    if (score >= 90) return Color.fromARGB(128, 54, 244, 215);
    else if (score >= 80) return Colors.green;
    else if (score >= 70) return Colors.yellow;
    else if (score >= 60) return Colors.orange;
    else if (score >= 50) return Colors.deepOrange;
    else if (score >= 40) return Colors.red;
    else return Color.fromARGB(196, 150, 0, 0);
  }

  double getCircleSize(BuildContext context, double score) {
    double screenWidth = MediaQuery.of(context).size.width;
    return screenWidth * (0.5 + (score / 100) * (0.35));
  }

  @override
  Widget build(BuildContext context) {
    SensorData sensorData = Provider.of<SensorData>(context);
    double overallScore = calculateOverallScore(sensorData);
    Color circleColor = getCircleColor(overallScore);
    double circleSize = getCircleSize(context, overallScore);
    List<Widget> statusBars = getStatusBars(sensorData);

    return Scaffold(
      appBar: AppBar(
        title: Text('Overall Score'),
      ),
      body: Column(
        children: [
          Container(
            width: circleSize,
            height: circleSize,
            decoration: BoxDecoration(
                color: circleColor,
                shape: BoxShape.circle
            ),
            child: Center(
              child: Text(
                overallScore.toStringAsFixed(1),
                style: TextStyle(
                    fontSize: 36,
                    color: Colors.black38,
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
          ),
          Spacer(),  // push the status bars to the bottom
          Container(
            child: ListView(
              shrinkWrap: true,  // This makes the ListView take the minimum amount of vertical space
              children: statusBars,
            ),
          ),
        ],
      ),
    );
  }
}

class StatusBar extends StatelessWidget {
  final String label;
  final String status;

  StatusBar({Key? key, required this.label, required this.status}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (status) {
      case 'Good':
        color = Colors.green;
        break;
      case 'Poor':
        color = Colors.yellow;
        break;
      case 'Bad':
        color = Colors.red;
        break;
      default:
        color = Colors.grey;
    }

    return Container(
      alignment: Alignment.center, // Make the container center
      color: color,
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Text(label,
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold
            )
        ),
      ),
    );
  }
}
