import 'package:flutter/material.dart';

class WeeklyWeather extends StatelessWidget {
  const WeeklyWeather({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: 7,
        itemBuilder: (context, index) {
          return ListTile(
            leading: const Icon(Icons.wb_sunny, color: Colors.yellow),
            title: Text(
              "Day \${index + 1}",
              style: const TextStyle(color: Colors.white),
            ),
            trailing: const Text(
              "23° / 17°",
              style: TextStyle(color: Colors.white),
            ),
          );
        },
      ),
    );
  }
}
