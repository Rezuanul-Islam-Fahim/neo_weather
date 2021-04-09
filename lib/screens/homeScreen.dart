import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../components/homeScreen/headSection.dart';
import '../components/homeScreen/weatherDetails.dart';
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
          title: Text('Remove City?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            SizedBox(width: 5),
            ElevatedButton(
              child: Text('Remove'),
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.clear();
                isSetWeather = null;
                weatherData = {};
                Navigator.of(context).pop();
                setState(() {});
              },
            ),
          ],
          backgroundColor: Colors.grey[900].withOpacity(0.9),
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 17),
          actionsPadding: EdgeInsets.only(right: 15, bottom: 10),
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
      padding: EdgeInsets.symmetric(vertical: 14, horizontal: 24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    );

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
                HeadSection(weatherData, isSetWeather, openDeleteDialog),
                isSetWeather != null
                    ? Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        width: double.infinity,
                        child: WeatherDetails(weatherData),
                      )
                    : Column(
                        children: <Widget>[
                          ElevatedButton(
                            style: addButtonStyle,
                            child: Text('Add City'),
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => SearchPage()),
                            ),
                          ),
                          SizedBox(height: 100),
                        ],
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
