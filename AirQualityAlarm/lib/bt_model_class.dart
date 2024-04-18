import 'package:scoped_model/scoped_model.dart';

class BluetoothDataModel extends Model {
  String _humidity = '';
  String _temperature = '';
  String _vocs = '';
  String _co = '';
  String _smoke = '';
  String _connectionStatus = 'Disconnected';

  String get humidity => _humidity;
  String get temperature => _temperature;
  String get vocs => _vocs;
  String get co => _co;
  String get smoke => _smoke;
  String get connectionStatus => _connectionStatus;

  void updateConnectionStatus(String newStatus) {
    _connectionStatus = newStatus;
    notifyListeners();
  }

  void updateData(String data) {
    List<String> parts = data.split(' ');
    bool updated = false;
    if (_humidity != parts[1]) {
      _humidity = parts[1];
      updated = true;
    }
    if (_temperature != parts[3]) {
      _temperature = parts[3];
      updated = true;
    }
    if (_vocs != parts[5]) {
      _vocs = parts[5];
      updated = true;
    }
    if (_co != parts[7]) {
      _co = parts[7];
      updated = true;
    }
    if (_smoke != parts[9]) {
      _smoke = parts[9];
      updated = true;
    }
    if (updated) {
      notifyListeners();
    }
  }
}