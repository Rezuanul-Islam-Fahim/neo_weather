import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'weatherData.dart';

class WeatherDetails extends StatelessWidget {
  const WeatherDetails(this.weatherData);

  final Map<String, dynamic> weatherData;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        weatherData['temp'] != null
            ? Text(
                '${weatherData['temp'].toStringAsFixed(0)}°C',
                style: TextStyle(color: Colors.white, fontSize: 65),
              )
            : Text(
                '- -',
                style: TextStyle(color: Colors.white, fontSize: 65),
              ),
        SizedBox(height: 5),
        Row(
          children: <Widget>[
            SvgPicture.asset(
              'assets/icons/moon.svg',
              width: 32,
              color: Colors.white,
            ),
            SizedBox(width: 10),
            Text(
              'Night',
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
          ],
        ),
        SizedBox(height: 20),
        Divider(color: Colors.white30),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            WeatherData(
              title: 'Wind',
              value: weatherData['wind'],
              sign: 'km/h',
              barColor: Colors.redAccent,
              barWidthFactor: 0.7,
            ),
            WeatherData(
              title: 'Humidity',
              value: weatherData['humidity'],
              sign: '%',
              barColor: Colors.blueAccent,
              barWidthFactor: 0.3,
            ),
            WeatherData(
              title: 'Visibility',
              value: weatherData['visibility'],
              sign: '%',
              barColor: Colors.greenAccent,
              barWidthFactor: 0.5,
            ),
          ],
        ),
      ],
    );
  }
}
