import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'weatherData.dart';

class WeatherDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          '25°C',
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
              value: 10,
              sign: 'km/h',
              barColor: Colors.redAccent,
              barWidthFactor: 0.7,
            ),
            WeatherData(
              title: 'Rain',
              value: 3,
              sign: '%',
              barColor: Colors.blueAccent,
              barWidthFactor: 0.3,
            ),
            WeatherData(
              title: 'Humidity',
              value: 8,
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
