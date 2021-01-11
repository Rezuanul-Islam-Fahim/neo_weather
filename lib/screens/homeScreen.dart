import 'package:flutter/material.dart';

import '../components/homeScreen/headSection.dart';
import '../components/homeScreen/weatherDetails.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
                HeadSection(),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  width: double.infinity,
                  child: WeatherDetails(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}