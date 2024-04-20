import 'package:flutter/foundation.dart';

class COModel with ChangeNotifier {
  double _co = 0.0;
  double get co => _co;
  set co(double value) {
    if (_co != value) {
      _co = value;
      notifyListeners();
    }
  }
//threshold settings
  final double goodMax = 80.0;
  final double poorMin = 80.0;
  final double poorMax = 210.0;

  String get status {
    if (_co < goodMax) {
      return 'Good';
    } else if (_co >= poorMin && _co <= poorMax) {
      return 'Poor';
    } else {
      return 'Bad';
    }
  }
}
