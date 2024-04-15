import 'package:airqualityalarm/connection.dart';
import 'package:flutter/material.dart';
import 'package:airqualityalarm/overallscore.dart';
import 'package:airqualityalarm/dataviewer.dart';
import 'package:airqualityalarm/notification.dart';
import 'package:airqualityalarm/connection.dart';

class navigationbar extends StatefulWidget {
  const navigationbar({super.key});

  @override
  State<navigationbar> createState() => _navigationbarState();
}

class _navigationbarState extends State<navigationbar> {
  int _currentIndex=0;
  List _pageList=[
    overallscore(),
    dataviewer(),
    notification(),
    connection()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: this._pageList[this._currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: this._currentIndex,//配置默认选中的菜单，从下标零开始
        onTap: (int index){
          setState(() { //改变状态
            this._currentIndex=index;
          });
        },
        iconSize: 50,//icon大小
        fixedColor: Colors.red,//选中时颜色
        type: BottomNavigationBarType.fixed,//三个以上一定要设置type属性保证正常显示
        items: [
          BottomNavigationBarItem(
            label: 'Overall Score',
            icon: Icon(Icons.home_max_rounded),
            tooltip: 'Overall Score',  //长按显示的文本
          ),
          BottomNavigationBarItem(
            label: 'dataviewer',
            icon: Icon(Icons.data_thresholding_outlined),
            tooltip: 'dataviewer',
          ),
          BottomNavigationBarItem(
            label: 'notification',
            icon: Icon(Icons.notifications_active),
            tooltip: 'notification',
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