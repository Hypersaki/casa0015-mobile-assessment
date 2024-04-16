import 'package:flutter/material.dart';

class SystemAlarmsScreen extends StatefulWidget {
  @override
  _SystemAlarmsScreenState createState() => _SystemAlarmsScreenState();
}

class _SystemAlarmsScreenState extends State<SystemAlarmsScreen> {
  bool alarmSoundOn = true;
  bool vibrationOn = true;
  bool repeatOn = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('System Alarms'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            SwitchListTile(
              title: Text('Alarm Sound'),
              subtitle: Text('Homecoming'), // Example sound name
              value: alarmSoundOn,
              onChanged: (bool value) {
                setState(() {
                  alarmSoundOn = value;
                });
              },
            ),
            Divider(),
            SwitchListTile(
              title: Text('Vibration'),
              subtitle: Text('Basic call'), // Example vibration pattern name
              value: vibrationOn,
              onChanged: (bool value) {
                setState(() {
                  vibrationOn = value;
                });
              },
            ),
            Divider(),
            SwitchListTile(
              title: Text('Repeat'),
              value: repeatOn,
              onChanged: (bool value) {
                setState(() {
                  repeatOn = value;
                });
              },
            ),
            Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50), // make the button stretch to the full width
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
              onPressed: () {
                // Handle Save button press
              },
              child: Text('Save'),
            ),
            SizedBox(height: 30), // Provide some bottom padding
          ],
        ),
      ),
    );
  }
}
