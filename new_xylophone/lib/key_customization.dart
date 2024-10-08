import 'package:flutter/material.dart';

class KeyCustomization extends ChangeNotifier {
  final List<Color> _colors =
      List.generate(7, (index) => Colors.primaries[index]);
  final List<int> _sounds = List.generate(7, (index) => index + 1);

  Color getColor(int index) => _colors[index];
  int getSound(int index) => _sounds[index];

  void setColor(int index, Color newColor) {
    _colors[index] = newColor;
    notifyListeners();
  }

  void setSound(int index, int newSound) {
    _sounds[index] = newSound;
    notifyListeners();
  }
}
