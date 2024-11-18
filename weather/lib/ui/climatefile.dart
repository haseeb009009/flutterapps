import 'package:flutter/material.dart';

class Climate extends StatefulWidget {
  const Climate({super.key});

  @override
  State<Climate> createState() => _ClimateState();
}

class _ClimateState extends State<Climate> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ClimateApp'),
        backgroundColor: Colors.red,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => print('clicked'),
          ),
        ],
      ),
      body: Stack(
        children: [
          const Center(
            child: Image(
              image: AssetImage('images/umbrella.png'),
              height: 1200.0,
              width: 600.0,
              fit: BoxFit.fill,
            ),
          ),
          Container(
            alignment: Alignment.topRight,
            margin: const EdgeInsets.fromLTRB(0.0, 10.9, 20.9, 0.0),
            child: Text(
              'vehari',
              style: cityStyle(),
            ),
          )
        ],
      ),
    );
  }
}
TextStyle cityStyle() {
  return const TextStyle(
    color: Colors.white,
    fontSize: 22.9,
    fontStyle: FontStyle.italic,
  );
}
