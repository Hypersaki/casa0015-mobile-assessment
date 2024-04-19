import 'package:flutter/foundation.dart';

class SensorData with ChangeNotifier {
  double _humidity = 0.0;
  double _temperature = 0.0;
  double _vocs = 0.0;
  double _co = 0.0;
  double _smoke = 0.0;

  double get humidity => _humidity;
  double get temperature => _temperature;
  double get vocs => _vocs;
  double get co => _co;
  double get smoke => _smoke;

  void update(double newHumidity, double newTemperature, double newVocs, double newCo, double newSmoke) {
    _humidity = newHumidity;
    _temperature = newTemperature;
    _vocs = newVocs;
    _co = newCo;
    _smoke = newSmoke;
    notifyListeners();
  }
}