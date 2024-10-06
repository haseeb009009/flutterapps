// lib/xylophone_key.dart

import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class XylophoneKey extends StatelessWidget {
  final Color color;
  final int soundNumber;

  XylophoneKey({required this.color, required this.soundNumber});

  void playSound() {
    final player = AudioPlayer();
    player.play(AssetSource('note$soundNumber.mp3'));
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: color,
        ),
        onPressed: playSound,
        child: Container(),
      ),
    );
  }
}
