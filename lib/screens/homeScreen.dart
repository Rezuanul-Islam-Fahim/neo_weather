import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../components/homeScreen/headSection.dart';
import '../components/homeScreen/weatherDetails.dart';
import '../components/homeScreen/helpers.dart';
import 'searchScreen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<String, dynamic> weatherData = {};
  bool isSetWeather;

  Future<void> checkWeather() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() => isSetWeather = prefs.getBool('isSetWeather'));
  }

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
        weatherData['main'] = fetchedData['weather'][0]['main'];
        weatherData['temp'] = fetchedData['main']['temp'];
        weatherData['temp_max'] = fetchedData['main']['temp_max'];
        weatherData['temp_min'] = fetchedData['main']['temp_min'];
        weatherData['wind'] = fetchedData['wind']['speed'];
      });
    }
  }

  void openDeleteDialog() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Remove City?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            const SizedBox(width: 2),
            ElevatedButton(
              child: const Text('Remove'),
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.clear();
                isSetWeather = null;
                weatherData = {};
                setState(() {});
                Navigator.of(context).pop();
              },
            ),
          ],
          backgroundColor: Colors.grey[900].withOpacity(0.8),
          titleTextStyle: const TextStyle(color: Colors.white, fontSize: 17),
          actionsPadding: const EdgeInsets.only(right: 15, bottom: 10),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    checkWeather();
    fetchWeatherData();
  }

  @override
  Widget build(BuildContext context) {
    final ButtonStyle addButtonStyle = ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 26),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
      ),
    );

    return Scaffold(
      body: Stack(
        children: <Widget>[
          if (isSetWeather == null)
            Image.asset(
              'assets/images/weather.jpg',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          if (weatherData['main'] != null)
            Image.asset(
              weatherStatus[weatherData['main']]['img'],
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          if (weatherData['main'] != null)
            Container(
              decoration: weatherStatus[weatherData['main']]['overlay'],
            ),
          Column(
            mainAxisAlignment: isSetWeather != null
                ? MainAxisAlignment.spaceBetween
                : MainAxisAlignment.start,
            children: <Widget>[
              HeadSection(weatherData, isSetWeather, openDeleteDialog),
              isSetWeather != null
                  ? WeatherDetails(weatherData)
                  : Column(
                      children: <Widget>[
                        const SizedBox(height: 100),
                        ElevatedButton(
                          style: addButtonStyle,
                          child: const Text(
                            'Add City',
                            style: const TextStyle(fontSize: 15),
                          ),
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => SearchPage()),
                          ),
                        ),
                      ],
                    ),
            ],
          ),
        ],
      ),
    );
  }
}
