import 'package:flutter/foundation.dart';

class TemperatureModel with ChangeNotifier {
  double _temperature = 0.0;
  double get temperature => _temperature;
  set temperature(double value) {
    if (_temperature != value) {
      _temperature = value;
      notifyListeners();
    }
  }
//threshold settings
  final double goodMin = 18.0;
  final double goodMax = 27.0;
  final double poorMin = 9.0;
  final double poorMax = 34.0;

  String get status {
    if (_temperature >= goodMin && _temperature <= goodMax) {
      return 'Good';
    } else if ((_temperature >= poorMin && _temperature < goodMin) ||
        (_temperature > goodMax && _temperature <= poorMax)) {
      return 'Poor';
    } else {
      return 'Bad';
    }
  }
}
