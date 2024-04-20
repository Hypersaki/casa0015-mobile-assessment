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

  final double HrGoodMin = 40.0;
  final double HrGoodMax = 60.0;
  final double HrPoorMin = 20.0;
  final double HrPoorMax = 80.0;

  String get HrStatus {
    if (_humidity >= HrGoodMin && _humidity <= HrGoodMax) {
      return 'Good';
    } else if ((_humidity >= HrPoorMin && _humidity < HrGoodMin) ||
        (_humidity > HrGoodMax && _humidity <= HrPoorMax)) {
      return 'Poor';
    } else {
      return 'Bad';
    }
  }

  final double TempGoodMin = 18.0;
  final double TempGoodMax = 27.0;
  final double TempPoorMin = 9.0;
  final double TempPoorMax = 34.0;

  String get TempStatus {
    if (_temperature >= TempGoodMin && _temperature <= TempGoodMax) {
      return 'Good';
    } else if ((_temperature >= TempPoorMin && _temperature < TempGoodMin) ||
        (_temperature > TempGoodMax && _temperature <= TempPoorMax)) {
      return 'Poor';
    } else {
      return 'Bad';
    }
  }

  final double VOCsGoodMin = 0.0;
  final double VOCsGoodMax = 100.0;
  final double VOCsPoorMin = 100.0;
  final double VOCsPoorMax = 200.0;

  String get VOCsStatus {
    if (_vocs < VOCsGoodMax) {
      return 'Good';
    } else if (_vocs >= VOCsPoorMin && _vocs <= VOCsPoorMax) {
      return 'Poor';
    } else {
      return 'Bad';
    }
  }

  final double SMKGoodMin = 0.0;
  final double SMKGoodMax = 110.0;
  final double SMKPoorMin = 110.0;
  final double SMKPoorMax = 230.0;

  String get SMKStatus {
    if (_smoke < SMKGoodMax) {
      return 'Good';
    } else if (_smoke >= SMKPoorMin && _smoke <= SMKPoorMax) {
      return 'Poor';
    } else {
      return 'Bad';
    }
  }

  final double COGoodMin = 0.0;
  final double COGoodMax = 80.0;
  final double COPoorMin = 80.0;
  final double COPoorMax = 210.0;

  String get COStatus {
    if (_co < COGoodMax) {
      return 'Good';
    } else if (_co >= COPoorMin && _co <= COPoorMax) {
      return 'Poor';
    } else {
      return 'Bad';
    }
  }

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