import 'dart:math';
import 'package:flutter/material.dart';
import 'coin_image_selector.dart';

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
          scaffoldBackgroundColor: const Color.fromARGB(255, 104, 16, 227)),
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
  String? _userGuess;
  String _coinResult = 'Heads';
  int _score = 0;
  late AnimationController _controller;
  late Animation<double> _animationFlip;
  bool _isTossing = false;
  String _headImage = 'assets/set1_head.png'; 
  String _tailImage = 'assets/set1_tail.png'; 

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
    if (_isTossing || _userGuess == null) return;

    setState(() {
      _isTossing = true;
      _controller.forward().then((_) {
        _controller.reset();
        String result = Random().nextBool() ? 'Heads' : 'Tails';
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

  void _showCoinSelector() {
    showDialog(
      context: context,
      builder: (context) {
        return CoinImageSelector(
          onSetSelected: (headImage, tailImage) {
            setState(() {
              _headImage = headImage;
              _tailImage = tailImage;
            });
          },
        );
      },
    );
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
            GestureDetector(
              onDoubleTap: _showCoinSelector,
              child: AnimatedBuilder(
                animation: _animationFlip,
                builder: (context, child) {
                  return Transform(
                    transform: Matrix4.identity()
                      ..rotateX(_animationFlip
                          .value)
                      ..rotateY(
                          0.5), 
                    alignment: Alignment.center,
                    child: Image.asset(
                      _coinResult == 'Heads' ? _headImage : _tailImage,
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
            ),
            const SizedBox(height: 20),
            Text(
              'Your Score: $_score',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
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
