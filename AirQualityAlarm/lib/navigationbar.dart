import 'package:airqualityalarm/connection.dart';
import 'package:flutter/material.dart';
import 'package:airqualityalarm/overallscore.dart';
import 'package:airqualityalarm/dataviewer.dart';
import 'package:airqualityalarm/notification.dart';
import 'package:airqualityalarm/connection.dart';

class BtmNavigationBar extends StatefulWidget {
  const BtmNavigationBar({super.key});

  @override
  State<BtmNavigationBar> createState() => _BtmNavigationBarState();
}

class _BtmNavigationBarState extends State<BtmNavigationBar> {
  int _currentIndex=0;
  List _pageList=[
    OverallScore(),
    DataViewer(),
    Notifications(),
    Connection()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: this._pageList[this._currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: this._currentIndex,
        onTap: (int index){
          setState(() {
            this._currentIndex=index;
          });
        },
        iconSize: 50,
        fixedColor: Colors.red,//color showing when selected
        type: BottomNavigationBarType.fixed,//over 3, set type
        items: [
          BottomNavigationBarItem(
            label: 'Overall Score',
            icon: Icon(Icons.home_max_rounded),
            tooltip: 'Overall Score',  //
          ),
          BottomNavigationBarItem(
            label: 'Data Viewer',
            icon: Icon(Icons.data_thresholding_outlined),
            tooltip: 'Data Viewer',
          ),
          BottomNavigationBarItem(
            label: 'Notification',
            icon: Icon(Icons.notifications_active),
            tooltip: 'Notification',
          ),
          BottomNavigationBarItem(
            label: 'connection',
            icon: Icon(Icons.bluetooth_searching_rounded),
            tooltip: 'connection',
          )
        ],
      ),
    );
  }
}