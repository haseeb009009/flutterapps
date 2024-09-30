import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const CoinFlipApp());
}

class CoinFlipApp extends StatelessWidget {
  const CoinFlipApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Coin Toss Game',
      theme: ThemeData(
        primarySwatch: Colors.amber,
        scaffoldBackgroundColor: const Color(0xFFADD8E6), // Light blue color
      ),
      home: const CoinFlipPage(),
    );
  }
}

class CoinFlipPage extends StatefulWidget {
  const CoinFlipPage({super.key});

  @override
  State<CoinFlipPage> createState() => _CoinFlipPageState();
}

class _CoinFlipPageState extends State<CoinFlipPage>
    with SingleTickerProviderStateMixin {
  String? _userGuess; // Store user's guess
  String _coinResult = 'Heads'; // Default coin result
  int _score = 0;
  late AnimationController _controller;
  late Animation<double> _animationFlip; // For coin flipping
  bool _isTossing = false; // To prevent multiple taps during animation

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _animationFlip = Tween<double>(begin: 0, end: 2 * pi).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  void _tossCoin() {
    if (_isTossing || _userGuess == null) return; // Prevents multiple tosses

    setState(() {
      _isTossing = true;
      _controller.forward().then((_) {
        _controller.reset();
        String result =
            Random().nextBool() ? 'Heads' : 'Tails'; // Random coin result
        setState(() {
          _coinResult = result;
          if (_userGuess == result) {
            _score++;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Good Guess!')),
            );
          } else {
            _score--;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Try Again!')),
            );
          }
          _isTossing = false;
        });
      });
    });
  }

  void _resetGame() {
    setState(() {
      _userGuess = null;
      _coinResult = 'Heads';
      _score = 0;
      _controller.reset();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Coin Toss Game'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Select Heads or Tails',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            // Heads or Tails selection buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _userGuess = 'Heads';
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    backgroundColor:
                        _userGuess == 'Heads' ? Colors.amber : Colors.grey,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                  ),
                  child: const Text(
                    'Heads',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _userGuess = 'Tails';
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    backgroundColor:
                        _userGuess == 'Tails' ? Colors.amber : Colors.grey,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                  ),
                  child: const Text(
                    'Tails',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Toss Coin button
            ElevatedButton(
              onPressed: _isTossing ? null : _tossCoin,
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              ),
              child: const Text('Toss Coin'),
            ),
            const SizedBox(height: 20),
            // Animated coin flip
            AnimatedBuilder(
              animation: _animationFlip,
              builder: (context, child) {
                return Transform(
                  transform: Matrix4.rotationY(_animationFlip.value),
                  alignment: Alignment.center,
                  child: Image.asset(
                    _coinResult == 'Heads'
                        ? 'assets/head.png'
                        : 'assets/tail.png',
                    height: 100,
                    width: 100,
                    errorBuilder: (context, error, stackTrace) {
                      return const SizedBox(
                        height: 100,
                        width: 100,
                        child: Center(child: Text('Image not found')),
                      );
                    },
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            // Display score
            Text(
              'Your Score: $_score',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            // Reset Game button
            ElevatedButton(
              onPressed: _resetGame,
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              ),
              child: const Text('Reset Game'),
            ),
          ],
        ),
      ),
    );
  }
}
