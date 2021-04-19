import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../screens/homeScreen.dart';

class SearchBox extends StatefulWidget {
  @override
  _SearchBoxState createState() => _SearchBoxState();
}

class _SearchBoxState extends State<SearchBox> {
  final TextEditingController inputController = TextEditingController();
  bool isLoading = false;
  bool isWrong = false;

  Future<void> fetchWeather(String city, BuildContext context) async {
    if (city != '') {
      setState(() {
        isLoading = true;
        isWrong = false;
      });

      http.Response response = await http.get(
        Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=6a060d4795b813d5a6ba640210d4cbe3&units=metric',
        ),
      );
      Map<String, dynamic> fetchedData = json.decode(response.body);

      if (fetchedData['cod'] != '404') {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('city', city);
        prefs.setBool('isSetWeather', true);

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
      } else {
        setState(() {
          isWrong = true;
          isLoading = false;
        });
      }
    } else {
      setState(() => isWrong = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          height: 52,
          margin: const EdgeInsets.symmetric(horizontal: 25),
          padding: const EdgeInsets.only(left: 25),
          decoration: BoxDecoration(
            color: Colors.white12,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            children: <Widget>[
              Expanded(
                child: TextField(
                  controller: inputController,
                  style: const TextStyle(color: Colors.white, fontSize: 15),
                  decoration: const InputDecoration(
                    hintText: 'Enter City Name',
                    hintStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
              InkWell(
                splashColor: Colors.blueAccent,
                onTap: () => fetchWeather(
                  inputController.text.trim(),
                  context,
                ),
                child: Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Icon(
                    Icons.arrow_forward_rounded,
                    size: 26,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 15),
        if (isLoading)
          SizedBox(
            width: 15,
            height: 15,
            child: Theme(
              data: ThemeData(accentColor: Colors.white70),
              child: const CircularProgressIndicator(strokeWidth: 1.6),
            ),
          ),
        if (isWrong)
          const Text(
            'Enter a valid city name',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.redAccent,
            ),
          ),
      ],
    );
  }
}
