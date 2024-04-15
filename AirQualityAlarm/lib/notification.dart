// import 'package:flutter/material.dart';
//
// class notification extends StatefulWidget {
//   const notification({super.key});
//
//   @override
//   State<notification> createState() => _notificationState();
// }
//
// class _notificationState extends State<notification> {
//   @override
//   Widget build(BuildContext context) {
//     return const Placeholder();
//   }
//
// }
import 'package:flutter/material.dart';

class notification extends StatefulWidget {
  @override
  _notificationstate createState() => _notificationstate();
}

class _notificationstate extends State<notification> {
  bool singlePoorIndicator = true;
  bool overallScoreLow = true;
  bool overallScoreStarred = false;
  bool anyPoorIndicator = true;
  bool overallScoreCritical = false;
  bool overallScoreCriticalStarred = false;
  TextEditingController scoreController = TextEditingController(text: "80");
  TextEditingController criticalScoreController = TextEditingController(text: "65");

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Notifications'),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'System Notifications:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              SwitchListTile(
                title: const Text('Single poor indicator'),
                value: singlePoorIndicator,
                onChanged: (bool value) {
                  setState(() {
                    singlePoorIndicator = value;
                  });
                },
              ),
              ListTile(
                title: const Text('Overall Score <'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 80,
                      child: TextFormField(
                        controller: scoreController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'Value',
                        ),
                      ),
                    ),
                    Switch(
                      value: overallScoreLow,
                      onChanged: (bool value) {
                        setState(() {
                          overallScoreLow = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
              CheckboxListTile(
                title: const Text('Mark with star'),
                value: overallScoreStarred,
                onChanged: (bool? value) {
                  setState(() {
                    overallScoreStarred = value!;
                  });
                },
                secondary: const Icon(
                  Icons.star,
                  color: Colors.orange,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'System Alarms:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              SwitchListTile(
                title: const Text('Any poor indicator'),
                value: anyPoorIndicator,
                onChanged: (bool value) {
                  setState(() {
                    anyPoorIndicator = value;
                  });
                },
              ),
              ListTile(
                title: const Text('Overall Score <'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 80,
                      child: TextFormField(
                        controller: criticalScoreController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'Value',
                        ),
                      ),
                    ),
                    Switch(
                      value: overallScoreCritical,
                      onChanged: (bool value) {
                        setState(() {
                          overallScoreCritical = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
              CheckboxListTile(
                title: const Text('Mark with star'),
                value: overallScoreCriticalStarred,
                onChanged: (bool? value) {
                  setState(() {
                    overallScoreCriticalStarred = value!;
                  });
                },
                secondary: const Icon(
                  Icons.star,
                  color: Colors.orange,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 40),
                    ),
                    onPressed: () {
                      // Handle save action
                    },
                    child: const Text('Save'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    scoreController.dispose();
    criticalScoreController.dispose();
    super.dispose();
  }
}