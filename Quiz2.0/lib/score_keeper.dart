import 'package:flutter/material.dart';

class ScoreKeeper extends StatelessWidget {
  final List<Icon> scoreKeeper;

  const ScoreKeeper({required this.scoreKeeper, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: scoreKeeper,
    );
  }
}
