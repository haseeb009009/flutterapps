import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'key_customization.dart';
import 'xylophone_key.dart';
import 'sound_player.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart'; // Import the color picker package

void main() {
  runApp(const XylophoneApp());
}

class XylophoneApp extends StatelessWidget {
  const XylophoneApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => KeyCustomization(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            title: const Text('Custom Xylophone App'),
            backgroundColor: Colors.blueAccent,
          ),
          body: const XylophoneScreen(),
        ),
      ),
    );
  }
}

class XylophoneScreen extends StatelessWidget {
  const XylophoneScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: List.generate(7, (index) {
        return Expanded(
          child: XylophoneKey(
            noteNumber: index + 1,
            keyColor: context.watch<KeyCustomization>().getColor(index),
            onPressed: () {
              SoundPlayer.playSound(
                  context.read<KeyCustomization>().getSound(index));
            },
            onDoubleTap: () {
              _showSoundSelectionDialog(context, index);
            },
            onLongPress: () {
              _showColorPickerDialog(context, index);
            },
          ),
        );
      }),
    );
  }

  // Show dialog to change sound on double tap
  void _showSoundSelectionDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Select a Sound"),
          content: DropdownButton<int>(
            value: context.read<KeyCustomization>().getSound(index),
            items: List.generate(7, (i) {
              return DropdownMenuItem<int>(
                value: i + 1,
                child: Text('Sound ${i + 1}'),
              );
            }),
            onChanged: (newSound) {
              if (newSound != null) {
                context.read<KeyCustomization>().setSound(index, newSound);
                Navigator.of(context).pop(); // Close the dialog after selecting
              }
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Done'),
            ),
          ],
        );
      },
    );
  }

  // Show color picker dialog on long press
  void _showColorPickerDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Select a Color"),
          content: SingleChildScrollView(
            child: BlockPicker(
              pickerColor: context.read<KeyCustomization>().getColor(index),
              onColorChanged: (color) {
                context.read<KeyCustomization>().setColor(index, color);
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Done'),
            ),
          ],
        );
      },
    );
  }
}
