import 'package:flutter/material.dart';
import 'quiz_brain.dart';
import 'timer_widget.dart';
import 'quiz_buttons.dart';
import 'score_keeper.dart';
import 'result_dialog.dart';

QuizBrain quizBrain = QuizBrain();

void main() => runApp(QuizApp());

class QuizApp extends StatelessWidget {
  const QuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: QuizPage(),
    );
  }
}

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  List<Icon> scoreKeeper = [];
  int score = 0;
  bool isQuizStarted = false;
  bool isMCQ = false;
  int timer = 5; // Initial timer value in seconds
  bool isRunning = false;

  // Starts the quiz timer and decrements it
  void startTimer() {
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        if (timer > 1) {
          timer--;
          startTimer();
        } else {
          checkAnswer(false); // Timeout, move to next question
        }
      });
    });
  }

  void checkAnswer(bool userPickedAnswer) {
    bool correctAnswer = quizBrain.getAnswer();

    setState(() {
      if (correctAnswer == userPickedAnswer) {
        scoreKeeper.add(const Icon(Icons.check, color: Colors.green));
        score++;
      } else {
        scoreKeeper.add(const Icon(Icons.close, color: Colors.red));
        score--;
      }
      if (quizBrain.isFinished()) {
        showResultDialog(context, score, resetQuiz);
      } else {
        quizBrain.nextQuestion();
        timer = 10;
        startTimer(); // Restart the timer for the next question
      }
    });
  }

  void checkMCQAnswer(int userPickedOption) {
    int correctOption = quizBrain.getMCQAnswer();

    setState(() {
      if (correctOption == userPickedOption) {
        scoreKeeper.add(const Icon(Icons.check, color: Colors.green));
        score++;
      } else {
        scoreKeeper.add(const Icon(Icons.close, color: Colors.red));
        score--;
      }
      if (quizBrain.isFinished()) {
        showResultDialog(context, score, resetQuiz);
      } else {
        quizBrain.nextQuestion();
        timer = 10;
        startTimer(); // Restart the timer for the next question
      }
    });
  }

  void startQuiz(bool mcq) {
    setState(() {
      isQuizStarted = true;
      isMCQ = mcq;
      timer = 10; // Reset the timer
      startTimer(); // Start the countdown
    });
  }

  void resetQuiz() {
    setState(() {
      quizBrain.reset();
      scoreKeeper.clear();
      score = 0;
      isQuizStarted = false;
      timer = 10;
      isRunning = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 144, 76, 167),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: isQuizStarted
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  // Display the current question
                  Expanded(
                    child: Center(
                      child: Text(
                        quizBrain.getQuestion(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  TimerWidget(timer: timer),
                  Expanded(
                    child: isMCQ
                        ? MCQButtons(
                            options: quizBrain.getMCQOptions(),
                            onOptionSelected: checkMCQAnswer,
                          )
                        : TrueFalseButtons(
                            onTruePressed: () => checkAnswer(true),
                            onFalsePressed: () => checkAnswer(false),
                          ),
                  ),
                  ScoreKeeper(scoreKeeper: scoreKeeper),
                ],
              )
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Start the Quiz',
                    ),
                    ElevatedButton(
                      onPressed: () => startQuiz(false),
                      child: const Text('True/False'),
                    ),
                    ElevatedButton(
                      onPressed: () => startQuiz(true),
                      child: const Text('MCQs'),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
