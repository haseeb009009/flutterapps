import 'package:flutter/material.dart';

class TrueFalseButtons extends StatelessWidget {
  final VoidCallback onTruePressed;
  final VoidCallback onFalsePressed;

  const TrueFalseButtons({
    required this.onTruePressed,
    required this.onFalsePressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: ElevatedButton(
            onPressed: onTruePressed,
            child: const Text('True'),
          ),
        ),
        Expanded(
          child: ElevatedButton(
            onPressed: onFalsePressed,
            child: const Text('False'),
          ),
        ),
      ],
    );
  }
}

class MCQButtons extends StatelessWidget {
  final List<String> options;
  final Function(int) onOptionSelected;

  const MCQButtons({
    required this.options,
    required this.onOptionSelected,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: options
          .asMap()
          .entries
          .map((entry) => ElevatedButton(
                onPressed: () => onOptionSelected(entry.key),
                child: Text(entry.value),
              ))
          .toList(),
    );
  }
}
