import 'dart:async';

import 'package:flutter/material.dart';
import 'package:neo_weather/screens/homeScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchBox extends StatefulWidget {
  @override
  _SearchBoxState createState() => _SearchBoxState();
}

class _SearchBoxState extends State<SearchBox> {
  final TextEditingController inputController = TextEditingController();

  Future<void> fetchWeather(String city, BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('city', city);

    Navigator.of(context)
        .pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (BuildContext context) => HomeScreen(),
          ),
          (Route<dynamic> route) => false,
        )
        .then(
          (_) => setState(() {}),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      margin: EdgeInsets.symmetric(horizontal: 25),
      padding: EdgeInsets.only(left: 25),
      decoration: BoxDecoration(
        color: Colors.white12,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: inputController,
              style: TextStyle(color: Colors.white, fontSize: 17),
              decoration: InputDecoration(
                hintText: 'Enter City Name',
                hintStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                ),
                border: InputBorder.none,
              ),
            ),
          ),
          InkWell(
            splashColor: Colors.blueAccent,
            onTap: () => fetchWeather(inputController.text, context),
            child: Container(
              width: 55,
              height: 55,
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Icon(
                Icons.arrow_forward_rounded,
                size: 26,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
