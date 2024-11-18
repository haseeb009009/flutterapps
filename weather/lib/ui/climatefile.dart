import 'package:flutter/material.dart';
import '../utils/apifile.dart' as utils;
import 'package:http/http.dart' as http;
import 'dart:convert';

class Climate extends StatefulWidget {
  const Climate({super.key});

  @override
  State<Climate> createState() => _ClimateState();
}

class _ClimateState extends State<Climate> {
  String cityName = utils.defaultCity;

  // Function to fetch weather data
  Future<Map<String, dynamic>> getWeather(String appId, String city) async {
    String apiUrl =
        'http://api.openweathermap.org/data/2.5/weather?q=$city&appid=$appId&units=imperial';
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  // Function to navigate to the "Change City" screen
  Future<void> _goToNextScreen(BuildContext context) async {
    var results = await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const ChangeCity()),
    );

    if (results != null && results.containsKey('city')) {
      setState(() {
        cityName = results['city'];
      });
    }
  }

  // Update widget to display temperature and weather details
  Widget updateTempWidget(String city) {
    return FutureBuilder(
      future: getWeather(utils.apiId, city),
      builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData) {
          Map content = snapshot.data!;
          return Container(
            margin: const EdgeInsets.fromLTRB(30.0, 250.0, 0.0, 0.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${content['main']['temp']}°F",
                  style: tempStyle(),
                ),
                Text(
                  "Humidity: ${content['main']['humidity']}%\n"
                  "Min: ${content['main']['temp_min']}°F\n"
                  "Max: ${content['main']['temp_max']}°F",
                  style: extraData(),
                ),
              ],
            ),
          );
        } else {
          return const Center(
            child: Text(
              "Could not fetch weather data",
              style: TextStyle(color: Colors.white, fontSize: 20.0),
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ClimateApp'),
        backgroundColor: Colors.red,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => _goToNextScreen(context),
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
              cityName,
              style: cityStyle(),
            ),
          ),
          const Center(
            child: Image(
              image: AssetImage('images/light_rain.png'),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            child: updateTempWidget(cityName),
          ),
        ],
      ),
    );
  }
}

class ChangeCity extends StatelessWidget {
  const ChangeCity({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController cityFieldController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Text('Change City'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Center(
            child: Image.asset(
              'images/white_snow.png',
              width: 600.0,
              height: 1200.0,
              fit: BoxFit.fill,
            ),
          ),
          ListView(
            children: [
              ListTile(
                title: TextField(
                  controller: cityFieldController,
                  decoration: const InputDecoration(
                    hintText: 'Enter City',
                  ),
                  keyboardType: TextInputType.text,
                ),
              ),
              ListTile(
                title: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, {'city': cityFieldController.text});
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                  child: const Text(
                    "Get Weather",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Text styles
TextStyle cityStyle() {
  return const TextStyle(
    color: Colors.white,
    fontSize: 22.9,
    fontStyle: FontStyle.italic,
  );
}

TextStyle tempStyle() {
  return const TextStyle(
    color: Colors.white,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w500,
    fontSize: 49.9,
  );
}

TextStyle extraData() {
  return const TextStyle(
    color: Colors.white,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w200,
    fontSize: 17,
  );
}
