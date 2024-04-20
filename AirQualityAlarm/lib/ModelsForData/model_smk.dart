import 'package:flutter/foundation.dart';

class SmokeModel with ChangeNotifier {
  double _smoke = 0.0;
  double get smoke => _smoke;
  set smoke(double value) {
    if (_smoke != value) {
      _smoke = value;
      notifyListeners();
    }
  }
//threshold settings
  final double goodMax = 110.0;
  final double poorMin = 110.0;
  final double poorMax = 230.0;

  String get status {
    if (_smoke < goodMax) {
      return 'Good';
    } else if (_smoke >= poorMin && _smoke <= poorMax) {
      return 'Poor';
    } else {
      return 'Bad';
    }
  }
}
