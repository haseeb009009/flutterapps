import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(SpinBottleApp());
}

class SpinBottleApp extends StatelessWidget {
  const SpinBottleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spin the Bottle',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: PlayerInputScreen(),
    );
  }
}

class PlayerInputScreen extends StatefulWidget {
  const PlayerInputScreen({super.key});

  @override
  _PlayerInputScreenState createState() => _PlayerInputScreenState();
}

class _PlayerInputScreenState extends State<PlayerInputScreen> {
  final TextEditingController _playerController = TextEditingController();
  final List<String> _players = [];

  void _addPlayer() {
    if (_playerController.text.isNotEmpty) {
      setState(() {
        _players.add(_playerController.text);
        _playerController.clear();
      });
    }
  }

  void _startGame() {
    if (_players.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SpinBottleScreen(players: _players),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add at least one player')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Players'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _playerController,
              decoration: const InputDecoration(
                labelText: 'Enter player name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _addPlayer,
              child: const Text('Add Player'),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _players.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_players[index]),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: _startGame,
              child: const Text('Start Game'),
            ),
          ],
        ),
      ),
    );
  }
}

class SpinBottleScreen extends StatefulWidget {
  final List<String> players;

  const SpinBottleScreen({super.key, required this.players});

  @override
  _SpinBottleScreenState createState() => _SpinBottleScreenState();
}

class _SpinBottleScreenState extends State<SpinBottleScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  double _currentAngle = 0;
  final List<String> _challenges = [
    "Sing a song",
    "Do 10 push-ups",
    "Tell a joke",
    "Dance for 1 minute",
    "Imitate someone",
    "Share an embarrassing story",
    "Do a funny face",
    "Call a friend and sing 'Happy Birthday'",
  ];

  // Add bottle image paths
  final List<String> _bottleImages = [
    'assets/bottle.png',
    'assets/bottle2.png',
    'assets/bottle3.png',
    'assets/bottle4.png',

  ];

  int _currentBottleIndex = 0; // To track the current bottle image

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
  }

  void _spinBottle() {
    final randomAngle = Random().nextDouble() * 2 * pi;
    _animation = Tween<double>(
      begin: _currentAngle,
      end: _currentAngle + 4 * pi + randomAngle,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _animation.addListener(() {
      setState(() {
        _currentAngle = _animation.value;
      });
    });

    _animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _showChallengeForSelectedPlayer();
      }
    });

    _controller.reset();
    _controller.forward();
  }

  // Double-tap gesture to change bottle image
  void _changeBottle() {
    setState(() {
      _currentBottleIndex = (_currentBottleIndex + 1) % _bottleImages.length;
    });
  }

  // Function to determine the selected player and show a challenge
  void _showChallengeForSelectedPlayer() {
    int selectedPlayerIndex = _getSelectedPlayerIndex();
    String selectedPlayer = widget.players[selectedPlayerIndex];
    String randomChallenge = _challenges[Random().nextInt(_challenges.length)];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('$selectedPlayer\'s Challenge'),
          content: Text(randomChallenge),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  int _getSelectedPlayerIndex() {
    double normalizedAngle = _currentAngle % (2 * pi);
    double anglePerPlayer = 2 * pi / widget.players.length;
    int selectedIndex = (normalizedAngle / anglePerPlayer).floor();
    return selectedIndex;
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
        title: const Text('Spin the Bottle'),
      ),
      body: Stack(
        children: [
          Center(
            child: GestureDetector(
              onDoubleTap: _changeBottle, // Double tap to change bottle image
              child: Transform.rotate(
                angle: _currentAngle,
                child: Image.asset(
                  _bottleImages[_currentBottleIndex], // Change bottle image
                  height: 200,
                ),
              ),
            ),
          ),
          // Display player names in bubbles around the bottle
          ..._buildPlayerBubbles(),
          Positioned(
            bottom: 50,
            left: MediaQuery.of(context).size.width / 2 - 50,
            child: ElevatedButton(
              onPressed: _spinBottle,
              child: const Text('Spin the Bottle'),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildPlayerBubbles() {
    const radius = 150.0;
    final centerX = MediaQuery.of(context).size.width / 2;
    final centerY = MediaQuery.of(context).size.height / 2 - 50;

    List<Widget> bubbles = [];
    final angleStep = 2 * pi / widget.players.length;

    for (int i = 0; i < widget.players.length; i++) {
      final angle = i * angleStep;
      final x = centerX + radius * cos(angle);
      final y = centerY + radius * sin(angle);

      bubbles.add(
        Positioned(
          left: x - 50,
          top: y - 25,
          child: Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.blueAccent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              widget.players[i],
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      );
    }
    return bubbles;
  }
}
