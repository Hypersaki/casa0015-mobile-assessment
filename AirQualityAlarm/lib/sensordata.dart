import 'package:flutter/foundation.dart';

class SensorData with ChangeNotifier {
  double _humidity = 0.0;
  double _temperature = 0.0;
  double _vocs = 0.0;
  double _co = 0.0;
  double _smoke = 0.0;
  bool _isConnected = false;

  double get humidity => _humidity;
  double get temperature => _temperature;
  double get vocs => _vocs;
  double get co => _co;
  double get smoke => _smoke;
  bool get isConnected => _isConnected;

  final Map<String, String> units = {
    'humidity': '%',
    'temperature': '°C',
    'vocs': 'ppm',
    'co': 'ppm',
    'smoke': 'ppm',
  };

  String getDataWithUnit(String type) {
    double value;
    switch (type) {
      case 'humidity':
        value = _humidity;
        break;
      case 'temperature':
        value = _temperature;
        break;
      case 'vocs':
        value = _vocs;
        break;
      case 'co':
        value = _co;
        break;
      case 'smoke':
        value = _smoke;
        break;
      default:
        value = 0;
    }
    return '${value.toStringAsFixed(2)} ${units[type] ?? ""}';
  }

  void update(double newHumidity, double newTemperature, double newVocs, double newCo, double newSmoke) {
    _humidity = newHumidity;
    _temperature = newTemperature;
    _vocs = newVocs;
    _co = newCo;
    _smoke = newSmoke;
    notifyListeners();
  }

  void updateConnectionStatus(bool status) {
    _isConnected = status;
    notifyListeners();
  }
}