import 'package:flutter/material.dart';

class XylophoneKey extends StatelessWidget {
  final int noteNumber;
  final Color keyColor;
  final VoidCallback onPressed;
  final VoidCallback onDoubleTap;
  final VoidCallback onLongPress;

  const XylophoneKey({
    Key? key,
    required this.noteNumber,
    required this.keyColor,
    required this.onPressed,
    required this.onDoubleTap,
    required this.onLongPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,            // Play the sound on single tap
      onDoubleTap: onDoubleTap,    // Change sound on double tap
      onLongPress: onLongPress,    // Change color on long press
      child: Container(
        color: keyColor,
        child: Center(
          child: Text(
            'Key $noteNumber',
            style: const TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      ),
    );
  }
}
