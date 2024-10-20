import 'package:flutter/material.dart';

class CoinImageSelector extends StatelessWidget {
  final Function(String headImage, String tailImage) onSetSelected;

  final List<Map<String, String>> imageSets = [
    {'head': 'assets/set1_head.png', 'tail': 'assets/set1_tail.png'},
    {'head': 'assets/set2_head.png', 'tail': 'assets/set2_tail.png'},
    {'head': 'assets/set3_head.png', 'tail': 'assets/set3_tail.png'},
    {'head': 'assets/set4_head.png', 'tail': 'assets/set4_tail.png'},
  ];

  CoinImageSelector({Key? key, required this.onSetSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select Coin Image Set'),
      content: SizedBox(
        width: double.maxFinite,
        child: GridView.builder(
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1.0,
          ),
          itemCount: imageSets.length,
          itemBuilder: (context, index) {
            final set = imageSets[index];
            return GestureDetector(
              onTap: () {
                onSetSelected(set['head']!, set['tail']!);
                Navigator.of(context).pop();
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(set['head']!, height: 80, width: 80),
                  const SizedBox(height: 10),
                  Image.asset(set['tail']!, height: 80, width: 80),
                ],
              ),
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}
