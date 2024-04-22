import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:airqualityalarm/sensordata.dart';
import 'package:airqualityalarm/notification.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationAlarmsettingsSettings extends StatefulWidget {
  @override
  _NotificationAlarmsettingsSettingsState createState() => _NotificationAlarmsettingsSettingsState();
}

class _NotificationAlarmsettingsSettingsState extends State<NotificationAlarmsettingsSettings> {
  late TextEditingController _poorOrBadCountController;
  late TextEditingController _overallScoreThresholdController;
  late bool _enableNotifications;

  @override
  void initState() {
    super.initState();
    _poorOrBadCountController = TextEditingController();
    _overallScoreThresholdController = TextEditingController();
    _loadSettings();
  }

  void _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _poorOrBadCountController.text = (prefs.getInt('poorOrBadCountThreshold') ?? 1).toString();
    _overallScoreThresholdController.text = (prefs.getDouble('overallScoreThreshold') ?? 80.0).toString();
    _enableNotifications = prefs.getBool('enableNotifications') ?? true;
    setState(() {});
  }

  void _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('poorOrBadCountThreshold', int.parse(_poorOrBadCountController.text));
    await prefs.setDouble('overallScoreThreshold', double.parse(_overallScoreThresholdController.text));
    await prefs.setBool('enableNotifications', _enableNotifications);
  }

  Widget buildStarSwitch(String key, String title, SensorData sensorData) {
    return SwitchListTile(
      title: Text(title),
      value: sensorData.starredStatuses[key] ?? false,
      onChanged: (bool value) {
        sensorData.updateStarStatus(key, value);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final sensorData = Provider.of<SensorData>(context);
    return Scaffold(
      appBar: AppBar(title: Text('Notification Settings')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SwitchListTile(
              title: Text('Enable Notifications'),
              value: _enableNotifications,
              onChanged: (bool value) {
                setState(() => _enableNotifications = value);
              },
            ),
            ListTile(
              title: Text('Poor or Bad Count Threshold'),
              subtitle: TextField(
                controller: _poorOrBadCountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(suffixText: 'count'),
              ),
            ),
            SwitchListTile(
              title: Text('Monitor Starred Stutuses'),
              value: sensorData.monitorStarredStatuses,
              onChanged: (bool value){
                sensorData.monitorStarredStatuses = value;
              },
            ),
            ListTile(
              title: Text('Overall Score Threshold'),
              subtitle: TextField(
                controller: _overallScoreThresholdController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(suffixText: 'points'),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: _saveSettings,
                child: Text('Save Settings'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _poorOrBadCountController.dispose();
    _overallScoreThresholdController.dispose();
    super.dispose();
  }
}