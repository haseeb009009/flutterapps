// lib/main.dart

import 'package:flutter/material.dart';
import 'xylophone_key.dart';

void main() {
  runApp(XylophoneApp());
}

class XylophoneApp extends StatelessWidget {
  // Define a list of colors for the keys
  final List<Color> keyColors = [
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.green,
    Colors.teal,
    Colors.blue,
    Colors.purple,
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Xylophone',
      home: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.indigo.shade900, Colors.teal.shade200],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: List.generate(7, (index) {
                return XylophoneKey(
                  color: keyColors[index],
                  soundNumber: index + 1,
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
