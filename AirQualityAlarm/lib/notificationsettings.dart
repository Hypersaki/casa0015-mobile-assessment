import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:airqualityalarm/sensordata.dart';
// import 'package:airqualityalarm/notification.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class NotificationSettings extends StatefulWidget {
  @override
  _NotificationSettingsState createState() =>
      _NotificationSettingsState();
}

class _NotificationSettingsState
    extends State<NotificationSettings> {


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
    // final sensorData = Provider.of<SensorData>(context);
    return Scaffold(
      appBar: AppBar(title: Text('Notification Settings')),
      body: Consumer<SensorData>(
        builder: (context, sensorData, child) {
          return SingleChildScrollView(
            child: Column(
              children: [
                SwitchListTile(
                  title: Text('Poor or Bad Count Threshold'),
                  value: sensorData.enableNotifications1,
                  onChanged: (bool value) {
                    sensorData.setEnableNotifications1(value);
                  },
                  subtitle: TextField(
                    controller: sensorData.poorOrBadCountController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(suffixText: 'count'),
                  ),
                ),
                Consumer<SensorData>(
                  builder: (context, provider, child) {
                    return SwitchListTile(
                      title: Text('Monitor Starred Statuses'),
                      value: sensorData.enableNotifications2,
                      onChanged: (bool value) {
                        sensorData.setEnableNotifications2(value);
                      },
                    );
                  },
                ),
                SwitchListTile(
                  title: Text('Overall Score Threshold'),
                  value: sensorData.enableNotifications3,
                  onChanged: (bool value) {
                    sensorData.setEnableNotifications3(value);
                  },
                  subtitle: TextField(
                    controller: sensorData.overallScoreThresholdController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(suffixText: 'points'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
