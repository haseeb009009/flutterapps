import 'quiz.dart';
import 'mcq_quiz.dart';

class QuizBrain {
  int _questionIndex = 0;
  final List<Quiz> _questionBank = [
    Quiz(questionText: 'Flutter uses Dart as its programming language?', answer: true),
    Quiz(questionText: 'Flutter is used only for developing Android applications?', answer: false),
    Quiz(questionText: 'Flutter is an open-source UI software development toolkit?', answer: true),
    Quiz(questionText: 'Widgets in Flutter are immutable?', answer: true),
    Quiz(questionText: 'Flutter supports both Android and iOS development from a single codebase?', answer: true),
    Quiz(questionText: 'Hot reload allows developers to see the changes immediately without restarting the app?', answer: true),
    Quiz(questionText: 'Flutter’s primary programming language is Java?', answer: false),
    Quiz(questionText: 'Flutter apps can be compiled to native ARM code?', answer: true),
    Quiz(questionText: 'Flutter does not support building web applications?', answer: false),
    Quiz(questionText: 'Stateful widgets in Flutter can update dynamically based on user interaction?', answer: true),

  ];

final List<MCQQuiz> _mcqBank = [
  MCQQuiz(
      questionText: 'Which language is used by Flutter?',
      options: ['Java', 'Kotlin', 'Dart', 'Swift'],
      correctOptionIndex: 2),
  MCQQuiz(
      questionText: 'Which platforms does Flutter support?',
      options: ['Only Android', 'Only iOS', 'Android & iOS', 'Web & Mobile'],
      correctOptionIndex: 3),
  MCQQuiz(
      questionText: 'What is the purpose of the "Hot Reload" feature in Flutter?',
      options: [
        'To restart the app automatically',
        'To see code changes immediately',
        'To build the app faster',
        'To deploy the app on multiple platforms'
      ],
      correctOptionIndex: 1),
  MCQQuiz(
      questionText: 'Which of the following is TRUE about widgets in Flutter?',
      options: [
        'Widgets are immutable',
        'Widgets cannot be reused',
        'Widgets are mutable',
        'Widgets do not follow a hierarchical structure'
      ],
      correctOptionIndex: 0),
  MCQQuiz(
      questionText: 'What does Flutter use to build its user interface?',
      options: ['Java', 'Kotlin', 'Native UI libraries', 'Widgets'],
      correctOptionIndex: 3),
  MCQQuiz(
      questionText: 'Which of the following statements about Flutter is TRUE?',
      options: [
        'Flutter is an open-source toolkit',
        'Flutter is only used for Android development',
        'Flutter does not support web applications',
        'Flutter apps are written in Swift'
      ],
      correctOptionIndex: 0),
  MCQQuiz(
      questionText: 'What kind of code does Flutter compile to?',
      options: ['Java bytecode', 'ARM native code', 'HTML', 'JavaScript'],
      correctOptionIndex: 1),
  MCQQuiz(
      questionText: 'Which programming language is used primarily in Flutter?',
      options: ['Java', 'Kotlin', 'Dart', 'C++'],
      correctOptionIndex: 2),
  MCQQuiz(
      questionText: 'Which widget type allows dynamic updates based on user interaction?',
      options: ['StatelessWidget', 'StatefulWidget', 'Container', 'Row'],
      correctOptionIndex: 1),
  MCQQuiz(
      questionText: 'What is Flutter’s widget tree based on?',
      options: ['Flat structure', 'Hierarchical structure', 'Circular structure', 'Random structure'],
      correctOptionIndex: 1),
];


  bool _isMCQ = false;

  String getQuestion() {
    return _isMCQ ? _mcqBank[_questionIndex].questionText : _questionBank[_questionIndex].questionText;
  }

  bool getAnswer() {
    return _questionBank[_questionIndex].answer;
  }

  List<String> getMCQOptions() {
    return _mcqBank[_questionIndex].options;
  }

  int getMCQAnswer() {
    return _mcqBank[_questionIndex].correctOptionIndex;
  }

  void nextQuestion() {
    if (_isMCQ) {
      if (_questionIndex < _mcqBank.length - 1) {
        _questionIndex++;
      }
    } else {
      if (_questionIndex < _questionBank.length - 1) {
        _questionIndex++;
      }
    }
  }

  bool isFinished() {
    return _isMCQ ? _questionIndex >= _mcqBank.length - 1 : _questionIndex >= _questionBank.length - 1;
  }

  void reset() {
    _questionIndex = 0;
  }

  void setQuizType(bool isMCQ) {
    _isMCQ = isMCQ;
  }
}
