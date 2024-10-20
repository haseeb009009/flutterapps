import 'package:flutter/material.dart';
import 'dart:math';
import 'customization.dart'; // Import the customization dialog

void main() => runApp(const DiceApp());

class DiceApp extends StatelessWidget {
  const DiceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ludo Dice',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const DiceScreen(),
    );
  }
}

class DiceScreen extends StatefulWidget {
  const DiceScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _DiceScreenState createState() => _DiceScreenState();
}

class _DiceScreenState extends State<DiceScreen> {
  int _diceNumber1 = 0;
  int _diceNumber2 = 0;
  int _diceNumber3 = 0;
  int _diceNumber4 = 0;

  int _score1 = 0;
  int _score2 = 0;
  int _score3 = 0;
  int _score4 = 0;

  int _currentPlayer = 1;
  int _currentRound = 1;
  final int _maxRounds = 5;

  final bool _isRolling1 = false;
  final bool _isRolling2 = false;
  final bool _isRolling3 = false;
  final bool _isRolling4 = false;

  // Dice color customization
  String _diceColor1 = 'red';
  String _diceColor2 = 'green';
  String _diceColor3 = 'blue';
  String _diceColor4 = 'yellow';

  final Duration _animationDuration = const Duration(milliseconds: 500);

  void _rollDice() {
    setState(() {
      if (_currentRound <= _maxRounds) {
        int diceValue = Random().nextInt(6) + 1;

        switch (_currentPlayer) {
          case 1:
            _diceNumber1 = diceValue;
            _score1 += diceValue;
            break;
          case 2:
            _diceNumber2 = diceValue;
            _score2 += diceValue;
            break;
          case 3:
            _diceNumber3 = diceValue;
            _score3 += diceValue;
            break;
          case 4:
            _diceNumber4 = diceValue;
            _score4 += diceValue;
            break;
        }

        if (_currentPlayer < 4) {
          _currentPlayer++;
        } else {
          _currentPlayer = 1;
          _currentRound++;
        }

        if (_currentRound > _maxRounds) {
          _showWinnerDialog();
        }
      }
    });
  }

  void _showWinnerDialog() {
    String winner;
    int maxScore = _score1;
    winner = 'Player 1';

    if (_score2 > maxScore) {
      maxScore = _score2;
      winner = 'Player 2';
    }
    if (_score3 > maxScore) {
      maxScore = _score3;
      winner = 'Player 3';
    }
    if (_score4 > maxScore) {
      maxScore = _score4;
      winner = 'Player 4';
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Game Over'),
        content: Text('The winner is $winner with $maxScore points!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _resetGame();
            },
            child: const Text('Restart'),
          ),
        ],
      ),
    );
  }

  void _resetGame() {
    setState(() {
      _diceNumber1 = 0;
      _diceNumber2 = 0;
      _diceNumber3 = 0;
      _diceNumber4 = 0;

      _score1 = 0;
      _score2 = 0;
      _score3 = 0;
      _score4 = 0;

      _currentPlayer = 1;
      _currentRound = 1;
    });
  }

  // Show dice customization dialog for a player
  void _showCustomizationDialog(int player) {
    showDialog(
      context: context,
      builder: (context) {
        return CustomizationDialog(
          onSelect: (color) {
            setState(() {
              switch (player) {
                case 1:
                  _diceColor1 = color;
                  break;
                case 2:
                  _diceColor2 = color;
                  break;
                case 3:
                  _diceColor3 = color;
                  break;
                case 4:
                  _diceColor4 = color;
                  break;
              }
            });
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ludo Dice'),
        backgroundColor: Colors.redAccent,
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Round: $_currentRound / $_maxRounds',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildDiceColumn(
                  'Player 1\nScore: $_score1',
                  'assets/$_diceColor1-dice-$_diceNumber1.png',
                  _isRolling1,
                  _currentPlayer == 1,
                  onDoubleTap: () => _showCustomizationDialog(1),
                ),
                const SizedBox(width: 100),
                _buildDiceColumn(
                  'Player 2\nScore: $_score2',
                  'assets/$_diceColor2-dice-$_diceNumber2.png',
                  _isRolling2,
                  _currentPlayer == 2,
                  onDoubleTap: () => _showCustomizationDialog(2),
                ),
              ],
            ),
            const SizedBox(height: 100),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildDiceColumn(
                  'Player 3\nScore: $_score3',
                  'assets/$_diceColor3-dice-$_diceNumber3.png',
                  _isRolling3,
                  _currentPlayer == 3,
                  onDoubleTap: () => _showCustomizationDialog(3),
                ),
                const SizedBox(width: 100),
                _buildDiceColumn(
                  'Player 4\nScore: $_score4',
                  'assets/$_diceColor4-dice-$_diceNumber4.png',
                  _isRolling4,
                  _currentPlayer == 4,
                  onDoubleTap: () => _showCustomizationDialog(4),
                ),
              ],
            ),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: _rollDice,
              child: const Text(' Roll the Dice '),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDiceColumn(
      String text, String imagePath, bool isRolling, bool isCurrentPlayer,
      {required VoidCallback onDoubleTap}) {
    return GestureDetector(
      onDoubleTap: onDoubleTap,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          border: Border.all(
            color: isCurrentPlayer ? Colors.blue : Colors.transparent,
            width: 3,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            AnimatedOpacity(
              opacity: isRolling ? 0.0 : 1.0, // Hide dice when rolling
              duration: _animationDuration,
              child: Image.asset(
                imagePath,
                width: 100,
                height: 100,
              ),
            ),
            if (isRolling)
              const CircularProgressIndicator(), // Show a loading spinner while rolling
          ],
        ),
      ),
    );
  }
}
