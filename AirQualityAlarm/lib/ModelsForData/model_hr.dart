import 'package:flutter/foundation.dart';

class HumidityModel with ChangeNotifier {
  double _humidity = 0.0;
  double get humidity => _humidity;
  set humidity(double value) {
    if (_humidity != value) {
      _humidity = value;
      notifyListeners();
    }
  }
  // Thresholds settings
  final double goodMin = 40.0;
  final double goodMax = 60.0;
  final double poorMin = 20.0;
  final double poorMax = 80.0;

  String get status {
    if (_humidity >= goodMin && _humidity <= goodMax) {
      return 'Good';
    } else if ((_humidity >= poorMin && _humidity < goodMin) ||
        (_humidity > goodMax && _humidity <= poorMax)) {
      return 'Poor';
    } else {
      return 'Bad';
    }
  }
}