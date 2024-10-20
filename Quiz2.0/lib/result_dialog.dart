import 'package:flutter/material.dart';

void showResultDialog(BuildContext context, int score, VoidCallback resetQuiz) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Quiz Completed!"),
        content: Text("Your score is $score/10"),
        actions: [
          TextButton(
            child: const Text("Restart"),
            onPressed: () {
              resetQuiz();
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
