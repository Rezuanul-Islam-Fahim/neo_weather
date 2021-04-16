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
          backgroundColor: Colors.grey[900].withOpacity(0.8),
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
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 26),
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
              width: double.infinity,
              height: double.infinity,
              decoration: weatherStatus[weatherData['main']]['overlay'],
            ),
          Padding(
            padding: EdgeInsets.fromLTRB(15, 45, 15, 40),
            child: Column(
              mainAxisAlignment: isSetWeather != null
                  ? MainAxisAlignment.spaceBetween
                  : MainAxisAlignment.start,
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
                          SizedBox(height: 100),
                          ElevatedButton(
                            style: addButtonStyle,
                            child: Text(
                              'Add City',
                              style: TextStyle(fontSize: 15),
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
          ),
        ],
      ),
    );
  }
}
