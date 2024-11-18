import 'package:flutter/material.dart';

class Climate extends StatefulWidget {
  const Climate({super.key});

  @override
  State<Climate> createState() => _ClimateState();
}

class _ClimateState extends State<Climate> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ClimateApp'),
        backgroundColor: Colors.red,
        actions: <widget>[
          IconButton(
            icon: Icon(icon.menu),
            onPressed: () => print('clicked'),
          ),
        ],
      ),
    );
  }
}
