import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(SpinBottleGameApp());
}

class SpinBottleGameApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spin the Bottle Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SpinBottleGame(),
    );
  }
}

class Player {
  String name;
  int score;

  Player(this.name, {this.score = 0});
}

class Challenge {
  String description;

  Challenge(this.description);
}

class SpinBottleGame extends StatefulWidget {
  @override
  _SpinBottleGameState createState() => _SpinBottleGameState();
}

class _SpinBottleGameState extends State<SpinBottleGame>
    with SingleTickerProviderStateMixin {
  List<Player> players = [];
  List<Challenge> challenges = [
    Challenge('Do 10 jumping jacks'),
    Challenge('Sing a funny song'),
    Challenge('Tell a joke'),
  ];
  String newChallenge = '';
  Player? selectedPlayer;
  String selectedBottle = 'assets/bottle1.Jpeg'; // Default bottle
  bool spinning = false;
  Timer? spinTimer;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    spinTimer?.cancel();
    super.dispose();
  }

  void handleAddPlayer() {
    if (players.length >= 10) {
      _showMessage('You can only add up to 10 players.');
      return;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController playerController = TextEditingController();
        return AlertDialog(
          title: Text('Enter player name'),
          content: TextField(
            controller: playerController,
            decoration: InputDecoration(hintText: 'Player name'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                if (playerController.text.isNotEmpty) {
                  setState(() {
                    players.add(Player(playerController.text));
                  });
                }
                Navigator.of(context).pop();
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void handleSpinBottle() {
    if (players.isEmpty) {
      _showMessage('Please add players before spinning the bottle.');
      return;
    }

    setState(() {
      spinning = true;
    });

    _controller.forward(from: 0.0); // Start spinning animation

    spinTimer = Timer(Duration(seconds: 2), () {
      final randomPlayerIndex = Random().nextInt(players.length);
      setState(() {
        selectedPlayer = players[randomPlayerIndex];
        spinning = false;
        _showChallenge(selectedPlayer!);
      });
    });
  }

  void _showChallenge(Player player) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Challenge for ${player.name}'),
          content: Text(_getChallengeDescription()),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                setState(() {
                  player.score +=
                      1; // Increase score for completing a challenge
                });
                Navigator.of(context).pop();
              },
              child: Text('Complete Challenge'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Skip Challenge'),
            ),
          ],
        );
      },
    );
  }

  String _getChallengeDescription() {
    // Return a random challenge from the list
    return challenges[Random().nextInt(challenges.length)].description;
  }

  void _showMessage(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Message'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void handleAddChallenge() {
    if (newChallenge.isNotEmpty) {
      setState(() {
        challenges.add(Challenge(newChallenge));
        newChallenge = '';
      });
    }
  }

  void handleBottleSelection(String bottle) {
    setState(() {
      selectedBottle = bottle;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Spin the Bottle Game'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Text('Selected Bottle:', style: TextStyle(fontSize: 18)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => handleBottleSelection('assets/bottle1.jpeg'),
                  child: Text('COCA-COLA'),
                ),
                ElevatedButton(
                  onPressed: () => handleBottleSelection('assets/bottle2.jpeg'),
                  child: Text('7UP'),
                ),
                ElevatedButton(
                  onPressed: () => handleBottleSelection('assets/bottle3.jpeg'),
                  child: Text('MARINDA'),
                ),
                ElevatedButton(
                  onPressed: () => handleBottleSelection('assets/bottle4.jpeg'),
                  child: Text('MANGO'),
                ),
              ],
            ),
            SizedBox(height: 2),
            Text('Players:', style: TextStyle(fontSize: 18)),
            Expanded(
              child: ListView.builder(
                itemCount: players.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                        '${players[index].name} (Score: ${players[index].score})'),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: handleAddPlayer,
              child: Text('Add Player'),
            ),
            SizedBox(height: 20),
            Container(
              height: 100,
              width: 300,
              child: Stack(
                children: [
                  Center(
                    child: RotationTransition(
                      turns: Tween(begin: 0.0, end: 3.0).animate(_controller),
                      child: Image.asset(
                        selectedBottle,
                        width: 100,
                      ),
                    ),
                  ),
                  for (int i = 0; i < players.length; i++)
                    _buildPlayerPosition(
                      (2 * pi / players.length) * i,
                      players[i],
                    ),
                ],
              ),
            ),
            SizedBox(height: 2),
            ElevatedButton(
              onPressed: handleSpinBottle,
              child: spinning ? Text('Spinning...') : Text('Spin Bottle'),
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(hintText: 'Enter new challenge'),
              onChanged: (value) {
                newChallenge = value;
              },
            ),
            ElevatedButton(
              onPressed: handleAddChallenge,
              child: Text('Add Challenge'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayerPosition(double angle, Player player) {
    double radius = 150; // Distance from the center (bottle) to the player
    return Positioned(
      left: 150 + radius * cos(angle) - 30, // Adjust to center
      top: 150 + radius * sin(angle) - 30, // Adjust to center
      child: Text(player.name,
          style: TextStyle(fontSize: 16),
          selectionColor: Color.fromRGBO(255, 255, 255, 1)),
    );
  }
}
