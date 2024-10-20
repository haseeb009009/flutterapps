import 'package:flutter/material.dart';

class TimerWidget extends StatelessWidget {
  final int timer;

  const TimerWidget({required this.timer, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      'Time Left: $timer seconds',
      style: const TextStyle(fontSize: 20.0),
      textAlign: TextAlign.center,
    );
  }
}
