import 'package:flutter/foundation.dart';

class VOCsModel with ChangeNotifier {
  double _vocs = 0.0;
  double get vocs => _vocs;
  set vocs(double value) {
    if (_vocs != value) {
      _vocs = value;
      notifyListeners();
    }
  }
//threshold settings
  final double goodMax = 100.0;
  final double poorMin = 100.0;
  final double poorMax = 200.0;

  String get status {
    if (_vocs < goodMax) {
      return 'Good';
    } else if (_vocs >= poorMin && _vocs <= poorMax) {
      return 'Poor';
    } else {
      return 'Bad';
    }
  }
}
