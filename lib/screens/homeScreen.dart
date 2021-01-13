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
    setState(() => weatherData['woeid'] = prefs.getInt('woeid'));

    if (weatherData['woeid'] != null) {
      String apiUrl =
          'https://www.metaweather.com/api/location/${weatherData['woeid']}';
      http.Response response = await http.get(apiUrl);
      Map<String, dynamic> data = json.decode(response.body);
      Map<String, dynamic> fetchedData = data['consolidated_weather'][0];

      setState(() {
        weatherData['city'] = data['title'];
        weatherData['temp'] = fetchedData['the_temp'];
        weatherData['wind'] = fetchedData['wind_speed'];
        weatherData['humidity'] = fetchedData['humidity'];
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
