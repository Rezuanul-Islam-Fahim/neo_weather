import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../components/homeScreen/headSection.dart';
import '../components/homeScreen/weatherDetails.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<String, dynamic> weatherData = {};

  Future<void> fetchWeatherData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String city = prefs.getString('city');

    if (city != null) {
      http.Response response = await http.get(
        Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=6a060d4795b813d5a6ba640210d4cbe3&units=metric',
        ),
      );
      Map<String, dynamic> fetchedData = json.decode(response.body);

      setState(() {
        weatherData['city'] = fetchedData['name'];
        weatherData['temp'] = fetchedData['main']['temp'];
        weatherData['wind'] = fetchedData['wind']['speed'];
        weatherData['humidity'] = fetchedData['main']['humidity'];
        weatherData['visibility'] = fetchedData['visibility'];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchWeatherData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Image.asset(
            'assets/images/night.jpg',
            fit: BoxFit.cover,
            height: double.infinity,
          ),
          Container(
            width: double.infinity,
            height: double.infinity,
            padding: EdgeInsets.fromLTRB(15, 45, 15, 40),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[
                  Colors.white24.withOpacity(0.25),
                  Colors.white12,
                  Colors.white12,
                  Colors.white10,
                ],
                stops: [0.1, 0.3, 0.7, 1],
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                HeadSection(weatherData),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  width: double.infinity,
                  child: WeatherDetails(weatherData),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
