import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:airqualityalarm/ModelsForData/model_hr.dart'; // 假设您有一个用于湿度模型的文件

class HumidityDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Humidity'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Consumer<HumidityModel>(
          builder: (context, humidityModel, child) => Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Placeholder(fallbackHeight: 200.0), // TODO: The placeholder needs to be changed to an image
              SizedBox(height: 20),
              Center(
                child: Text(
                  '${humidityModel.humidity.toStringAsFixed(1)}%',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                '参考阈值',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              ThresholdIndicator(value: humidityModel.humidity),
              ...buildStars(context, humidityModel.status),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> buildStars(BuildContext context, String status) {
    // 根据状态决定星标是否点亮
    return [
      Icon(
        status == 'Good' ? Icons.star : Icons.star_border,
        color: status == 'Good' ? Colors.blue : Colors.grey,
      ),
      Icon(
        status == 'Poor' ? Icons.star : Icons.star_border,
        color: status == 'Poor' ? Colors.blue : Colors.grey,
      ),
      Icon(
        status == 'Bad' ? Icons.star : Icons.star_border,
        color: status == 'Bad' ? Colors.blue : Colors.grey,
      ),
    ];
  }
}

class ThresholdIndicator extends StatelessWidget {
  final double value;

  const ThresholdIndicator({Key? key, required this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String threshold;
    Color color;

    if (value >= 40 && value <= 60) {
      threshold = 'Good';
      color = Colors.green;
    } else if ((value >= 20 && value < 40) || (value > 60 && value <= 80)) {
      threshold = 'Poor';
      color = Colors.amber;
    } else {
      threshold = 'Bad';
      color = Colors.red;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ThresholdLabel(threshold: 'Good', value: '40%-60%', isActive: threshold == 'Good'),
        ThresholdLabel(threshold: 'Poor', value: '20%-40% or 60%-80%', isActive: threshold == 'Poor'),
        ThresholdLabel(threshold: 'Bad', value: '<20% or >80%', isActive: threshold == 'Bad'),
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
