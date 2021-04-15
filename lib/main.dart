import 'package:flutter/material.dart';

import './screens/homeScreen.dart';

void main() => runApp(NeoWeather());

class NeoWeather extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Neo Weather',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(scaffoldBackgroundColor: Colors.black87),
      home: HomeScreen(),
    );
  }
}
