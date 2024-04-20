import 'package:flutter/material.dart';
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
        _buildThresholdLabel('Good', '${goodMin}%-${goodMax}%', threshold == 'Good'),
        _buildThresholdLabel('Poor', '${poorMin}%-${poorMax}%', threshold == 'Poor'),
        _buildThresholdLabel('Bad', '<${poorMin}% or >${poorMax}%', threshold == 'Bad'),
      ],
    );
  }

  Widget _buildThresholdLabel(String label, String range, bool isActive) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isActive ? Colors.blue : Colors.grey,
          ),
        ),
        Text(
          range,
          style: TextStyle(
            fontSize: 16,
            color: isActive ? Colors.black : Colors.grey,
          ),
        ),
      ],
    );
  }
}
