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
  final double COGoodMax = 80.0;
  final double COPoorMin = 80.0;
  final double COPoorMax = 210.0;

  String get status {
    if (_co < COGoodMax) {
      return 'Good';
    } else if (_co >= COPoorMin && _co <= COPoorMax) {
      return 'Poor';
    } else {
      return 'Bad';
    }
  }
}
