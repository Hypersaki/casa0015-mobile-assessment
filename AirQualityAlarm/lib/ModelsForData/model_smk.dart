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
  final double SMKGoodMax = 110.0;
  final double SMKPoorMin = 110.0;
  final double SMKPoorMax = 230.0;

  String get status {
    if (_smoke < SMKGoodMax) {
      return 'Good';
    } else if (_smoke >= SMKPoorMin && _smoke <= SMKPoorMax) {
      return 'Poor';
    } else {
      return 'Bad';
    }
  }
}
