import 'package:flutter/material.dart';
import 'dart:math';

void main() => runApp(DiceApp());

class DiceApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ludo Dice',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: DiceScreen(),
    );
  }
}

class DiceScreen extends StatefulWidget {
  @override
  _DiceScreenState createState() => _DiceScreenState();
}

class _DiceScreenState extends State<DiceScreen> with TickerProviderStateMixin {
  int _diceNumber1 = 0;
  int _diceNumber2 = 0;
  int _diceNumber3 = 0;
  int _diceNumber4 = 0;

  int _score1 = 0;
  int _score2 = 0;
  int _score3 = 0;
  int _score4 = 0;

  bool _isRolling1 = false;
  bool _isRolling2 = false;
  bool _isRolling3 = false;
  bool _isRolling4 = false;

  // Animation duration
  final Duration _animationDuration = Duration(milliseconds: 500);

  void _rollDice1() {
    _rollDice(1);
  }

  void _rollDice2() {
    _rollDice(2);
  }

  void _rollDice3() {
    _rollDice(3);
  }

  void _rollDice4() {
    _rollDice(4);
  }

  void _rollDice(int diceNumber) {
    setState(() {
      _setRollingState(diceNumber, true);
      int diceValue = Random().nextInt(6) + 1;

      if (diceNumber == 1) _diceNumber1 = diceValue;
      if (diceNumber == 2) _diceNumber2 = diceValue;
      if (diceNumber == 3) _diceNumber3 = diceValue;
      if (diceNumber == 4) _diceNumber4 = diceValue;

      _updateScore(diceNumber, diceValue);

      if (diceValue == 6) {
        Future.delayed(_animationDuration, () => _rollDice(diceNumber));
      } else {
        _resetAnimation(diceNumber);
      }
    });
  }

  void _updateScore(int diceNumber, int diceValue) {
    setState(() {
      if (diceNumber == 1) _score1 += diceValue;
      if (diceNumber == 2) _score2 += diceValue;
      if (diceNumber == 3) _score3 += diceValue;
      if (diceNumber == 4) _score4 += diceValue;
    });
  }

  void _setRollingState(int diceNumber, bool isRolling) {
    setState(() {
      if (diceNumber == 1) _isRolling1 = isRolling;
      if (diceNumber == 2) _isRolling2 = isRolling;
      if (diceNumber == 3) _isRolling3 = isRolling;
      if (diceNumber == 4) _isRolling4 = isRolling;
    });
  }

  void _resetAnimation(int diceNumber) {
    Future.delayed(_animationDuration, () {
      _setRollingState(diceNumber, false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ludo Dice'),
        backgroundColor: Colors.redAccent,
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildDiceColumn(
                  'Player 1\nScore: $_score1',
                  'images/dice-$_diceNumber1.png',
                  _isRolling1,
                  _rollDice1,
                ),
                SizedBox(width: 100),
                _buildDiceColumn(
                  'Player 2\nScore: $_score2',
                  'images/dice-$_diceNumber2.png',
                  _isRolling2,
                  _rollDice2,
                ),
              ],
            ),
            SizedBox(height: 100),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildDiceColumn(
                  'Player 3\nScore: $_score3',
                  'images/dice-$_diceNumber3.png',
                  _isRolling3,
                  _rollDice3,
                ),
                SizedBox(width: 100),
                _buildDiceColumn(
                  'Player 4\nScore: $_score4',
                  'images/dice-$_diceNumber4.png',
                  _isRolling4,
                  _rollDice4,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDiceColumn(
      String text, String imagePath, bool isRolling, VoidCallback onPressed) {
    return Column(
      children: [
        Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        AnimatedOpacity(
          opacity: isRolling ? 1.0 : 0.8, // Change opacity during rolling
          duration: _animationDuration,
          child: AnimatedScale(
            scale: isRolling ? 1.5 : 1.0, // Pop-up effect with scale
            duration: _animationDuration,
            child: Image.asset(
              imagePath,
              height: 100,
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        ElevatedButton(
          onPressed:
              isRolling ? null : onPressed, // Disable button when rolling
          child: Text(' Roll the Dice '),
        ),
      ],
    );
  }
}
