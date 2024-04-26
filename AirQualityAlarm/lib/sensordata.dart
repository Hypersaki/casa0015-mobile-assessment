import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:airqualityalarm/notification.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  final double HrGoodMax = 60.0; // Hr
  final double HrPoorMin = 20.0;
  final double HrPoorMax = 80.0; // Hr
  final double TempGoodMin = 18.0;
  final double TempGoodMax = 27.0; // Temp
  final double TempPoorMin = 9.0;
  final double TempPoorMax = 34.0; // Temp
  final double VOCsGoodMin = 0.0;
  final double VOCsGoodMax = 100.0; // VOCs
  final double VOCsPoorMin = 100.0;
  final double VOCsPoorMax = 200.0; // VOCs
  final double SMKGoodMin = 0.0;
  final double SMKGoodMax = 110.0; // Smoke
  final double SMKPoorMin = 110.0;
  final double SMKPoorMax = 230.0; // Smoke
  final double COGoodMin = 0.0;
  final double COGoodMax = 80.0; // CO
  final double COPoorMin = 80.0;
  final double COPoorMax = 210.0; // CO

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

  String get VOCsStatus {
    if (_vocs < VOCsGoodMax) {
      return 'Good';
    } else if (_vocs >= VOCsPoorMin && _vocs <= VOCsPoorMax) {
      return 'Poor';
    } else {
      return 'Bad';
    }
  }

  String get SMKStatus {
    if (_smoke < SMKGoodMax) {
      return 'Good';
    } else if (_smoke >= SMKPoorMin && _smoke <= SMKPoorMax) {
      return 'Poor';
    } else {
      return 'Bad';
    }
  }

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

  Map<String, bool> starredStatuses = {
    'HrPoor': false,
    'HrBad': false,
    'TempPoor': false,
    'TempBad': false,
    'VOCsPoor': false,
    'VOCsBad': false,
    'COPoor': false,
    'COBad': false,
    'SMKPoor': false,
    'SMKBad': false
  };

  String getStatus(String key) {
    switch (key) {
      case 'HrPoor':
      case 'HrBad':
        return HrStatus;
      case 'TempPoor':
      case 'TempBad':
        return TempStatus;
      case 'VOCsPoor':
      case 'VOCsBad':
        return VOCsStatus;
      case 'COPoor':
      case 'COBad':
        return COStatus;
      case 'SMKPoor':
      case 'SMKBad':
        return SMKStatus;
      default:
        return 'Unknown';
    }
  }

  SensorData() {
    _loadSettings();
  }

  void updateStarStatus(String key, bool isStarred) {
    starredStatuses[key] = isStarred;
    notifyListeners();
    if (isStarred) {
      checkAndTriggerNotificationForKey(key);
    }
  }

  void checkAndTriggerNotificationForKey(String key) {
    if (starredStatuses[key] ?? false) {
      String message = key + " status is activated and marked as critical.";
      NotificationService().showNotification("Alert", message);
    }
  }

  // overallscore calculation
  double OverallScoreCalculation() {
    double overallscore = 0.0;
    overallscore += HrStatus == 'Good'
        ? 20 * 0.8
        : HrStatus == 'Poor'
        ? 10 * 0.8
        : 0;
    overallscore += TempStatus == 'Good'
        ? 20 * 0.7
        : TempStatus == 'Poor'
        ? 10 * 0.7
        : 0;
    overallscore += VOCsStatus == 'Good'
        ? 20 * 1.3
        : VOCsStatus == 'Poor'
        ? 10 * 1.3
        : 0;
    overallscore += COStatus == 'Good'
        ? 20 * 1.1
        : COStatus == 'Poor'
        ? 10 * 1.1
        : 0;
    overallscore += SMKStatus == 'Good'
        ? 20 * 1.1
        : SMKStatus == 'Poor'
        ? 10 * 1.1
        : 0;
    return overallscore;
  }

  bool _monitorStarredStatuses = false; // monitor stars or not

  bool get monitorStarredStatuses => _monitorStarredStatuses;

  set monitorStarredStatuses(bool value) {
    _monitorStarredStatuses = value;
    notifyListeners();
  }

  bool _enableNotifications = false; // monitor stars or not

  bool get enableNotifications => _enableNotifications;

  set enableNotifications(bool value) {
    _enableNotifications = value;
    notifyListeners();
  }

  bool enableNotifications1 = false;
  bool enableNotifications2 = false;
  bool enableNotifications3 = false;

  setEnableNotifications1(bool value) async {
    enableNotifications1 = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('enableNotifications1', enableNotifications1);
    notifyListeners();
  }

  setEnableNotifications2(bool value) async {
    enableNotifications2 = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('enableNotifications2', enableNotifications2);
    notifyListeners();
  }

  setEnableNotifications3(bool value) async {
    enableNotifications3 = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('enableNotifications3', enableNotifications3);
    notifyListeners();
  }

  TextEditingController poorOrBadCountController = TextEditingController();
  TextEditingController overallScoreThresholdController =
  TextEditingController();

  void _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    poorOrBadCountController.text =
        (prefs.getInt('poorOrBadCountThreshold') ?? 1).toString();
    overallScoreThresholdController.text =
        (prefs.getDouble('overallScoreThreshold') ?? 80.0).toString();
    enableNotifications = prefs.getBool('enableNotifications') ?? true;
    enableNotifications1 = prefs.getBool('enableNotifications1') ?? true;
    enableNotifications2 = prefs.getBool('enableNotifications2') ?? true;
    enableNotifications3 = prefs.getBool('enableNotifications3') ?? true;
    starredStatuses.forEach((key, value) {
      starredStatuses[key] = prefs.getBool(key) ?? false;
    });

    poorOrBadCountController.addListener(() async {
      final prefs = await SharedPreferences.getInstance();

      try {
        await prefs.setInt('poorOrBadCountThreshold',
            int.parse(poorOrBadCountController.text));
      } catch (e) {}
    });
    overallScoreThresholdController.addListener(() async {
      final prefs = await SharedPreferences.getInstance();
      try {
        await prefs.setDouble('overallScoreThreshold',
            double.parse(overallScoreThresholdController.text));
      } catch (e) {}
    });
  }

  void checkPoorOrBadCountThresholdStatusNotifications() async {
    if (enableNotifications1) {
      int errCount = 0;
      int poorCount = 0;
      int badCount = 0;
      if (HrStatus == 'Poor' || HrStatus == 'Bad') {
        errCount++;
        if (HrStatus == 'Poor') {
          poorCount++;
        }
        if (HrStatus == 'Bad') {
          badCount++;
        }
      }
      if (TempStatus == 'Poor' || TempStatus == 'Bad') {
        errCount++;
        if (TempStatus == 'Poor') {
          poorCount++;
        }
        if (TempStatus == 'Bad') {
          badCount++;
        }
      }
      if (VOCsStatus == 'Poor' || VOCsStatus == 'Bad') {
        errCount++;
        if (VOCsStatus == 'Poor') {
          poorCount++;
        }
        if (VOCsStatus == 'Bad') {
          badCount++;
        }
      }
      if (COStatus == 'Poor' || COStatus == 'Bad') {
        errCount++;
        if (COStatus == 'Poor') {
          poorCount++;
        }
        if (COStatus == 'Bad') {
          badCount++;
        }
      }
      if (SMKStatus == 'Poor' || SMKStatus == 'Bad') {
        errCount++;
        if (SMKStatus == 'Poor') {
          poorCount++;
        }
        if (SMKStatus == 'Bad') {
          badCount++;
        }
      }
      try {
        print('------>errCount:$errCount');
        int setCount = int.parse(poorOrBadCountController.text);
        if (setCount <= errCount) {
          NotificationService().showNotification("Error Notification",
              "${poorCount} poor status and ${badCount} bad status detected",
              id: 1, channelId: '1', channelName: 'PoorOrBad');
        }
      } catch (e) {
        print('error:------>$e');
      }
    }
  }

  // notification 2
  void checkMonitorStarredStatusNotifications() async {
    if (enableNotifications2) {
      print(starredStatuses);
      if ((starredStatuses['HrPoor']! && HrStatus == 'Poor') ||
          (starredStatuses['HrBad']! && HrStatus == 'Bad') ||
          (starredStatuses['TempPoor']! && HrStatus == 'Poor') ||
          (starredStatuses['TempBad']! && HrStatus == 'Bad') ||
          (starredStatuses['VOCsPoor']! && HrStatus == 'Poor') ||
          (starredStatuses['VOCsBad']! && HrStatus == 'Bad') ||
          (starredStatuses['COPoor']! && HrStatus == 'Poor') ||
          (starredStatuses['COBad']! && HrStatus == 'Bad') ||
          (starredStatuses['SMKPoor']! && HrStatus == 'Poor') ||
          (starredStatuses['SMKBad']! && HrStatus == 'Bad')) {
        try {
          NotificationService().showNotification(
              "Error Notification", "starred status detected",
              id: 2, channelId: '2', channelName: 'MonitorStarred');
        } catch (e) {
          print('error:------>$e');
        }
      }
    }
  }

  // notification 3
  void checkAndTriggerOverallScoreNotification() async {
    final prefs = await SharedPreferences.getInstance();
    double notificationThreshold =
        prefs.getDouble('notificationThreshold') ?? 80.0;
    double overallScore = OverallScoreCalculation();
    if (enableNotifications3 && overallScore < notificationThreshold) {
      NotificationService().showNotification("Error Notification",
          "overall score is lower than $notificationThreshold",
          id: 3, channelId: '3', channelName: 'TriggerOverall');
    }
  }

  void update(double newHumidity, double newTemperature, double newVocs,
      double newCo, double newSmoke) {
    _humidity = newHumidity;
    _temperature = newTemperature;
    _vocs = newVocs;
    _co = newCo;
    _smoke = newSmoke;
    notifyListeners();
    // checkAndTriggerStarredStatusNotifications();
    // checkAndTriggerOverallScoreNotification();
    checkPoorOrBadCountThresholdStatusNotifications();
    checkMonitorStarredStatusNotifications();
    checkAndTriggerOverallScoreNotification();
    notifyListeners(); //
  }

  void updateConnectionStatus(bool status) {
    _isConnected = status;
    notifyListeners();
  }
}
