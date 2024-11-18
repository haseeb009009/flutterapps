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
  void showstuff() async {
    Map data = await getWeather(utils.apiId, utils.defaultCity);
    print(data.toString());
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
            // ignore: avoid_print
            onPressed: () => showstuff(),
          ),
        ],
      ),
      body: Stack(children: [
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
        ),
        const Center(
          child: Image(
            image: AssetImage('images/light_rain.png'),
          ),
        ),
        Container(
          alignment: Alignment.centerLeft,
          child: updateTempWidget('String city'),
        ),
      ]),
    );
  }

  Future<Map> getWeather(String appId, String city) async {
    String apiUrl =
        'http://api.openweathermap.org/data/2.5/weather?q=$city&appid=${utils.apiId}&units=imperial';
    http.Response response = await http.get(apiUrl as Uri);
    return json.decode(response.body);
  }

  Widget updateTempWidget(String city) {
    return FutureBuilder(
        future:
            getWeather(utils.apiId, city == null ? utils.defaultCity : city),
        builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
          if (snapshot.hasData) {
            Map? context = snapshot.data;
            return Container(
              margin: const EdgeInsets.fromLTRB(30.0, 250.0, 0.0, 0.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ListTile(
                    title: Text(
                      content['main']['temp'].toString() + " F",
                      style: TextStyle(
                          fontStyle: FontStyle.normal,
                          fontSize: 49.9,
                          color: Colors.white,
                          fontWeight: FontWeight.w500),
                    ),
                    subtitle: ListTile(
                      title: Text(
                        "Humidity: ${content['main']['humidity'].toString()}\n"
                        "Min: ${content['main']['temp_min'].toString()}\n"
                        "Max: ${content['main']['temp_max'].toString()}\n",
                        style: extraData(),
                      ),
                    ),
                  )
                ],
              ),
            );
          } else {
            return Container();
          }
        });
  }
}

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
