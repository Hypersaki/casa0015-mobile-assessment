import 'package:flutter/material.dart';
import 'package:airqualityalarm/navigationbar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: "Air Ring",home: const BtmNavigationBar());
  }
}
