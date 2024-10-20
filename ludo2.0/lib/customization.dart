import 'package:flutter/material.dart';

class CustomizationDialog extends StatelessWidget {
  final Function(String) onSelect;

  CustomizationDialog({required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Select Dice Color'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            _buildColorOption(context, 'Red'),
            _buildColorOption(context, 'Green'),
            _buildColorOption(context, 'Blue'),
            _buildColorOption(context, 'Yellow'),
          ],
        ),
      ),
    );
  }

  Widget _buildColorOption(BuildContext context, String color) {
    return GestureDetector(
      onTap: () {
        // Pass the color selected back to the main screen
        onSelect(color.toLowerCase());
        Navigator.of(context).pop();
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          color,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
