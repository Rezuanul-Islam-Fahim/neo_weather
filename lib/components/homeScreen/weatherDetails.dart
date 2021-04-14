import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'weatherData.dart';

class WeatherDetails extends StatelessWidget {
  const WeatherDetails(this.weatherData);

  final Map<String, dynamic> weatherData;

  dynamic abs(dynamic value) {
    return value < 0 ? -(value) : value;
  }

  static const Map<String, String> iconSrc = {
    'Clear': 'assets/icons/sun.svg',
    'Haze': 'assets/icons/haze.svg',
    'Clouds': 'assets/icons/cloudy.svg',
    'Rain': 'assets/icons/rain.svg',
    'Snow': 'assets/icons/snow.svg',
  };

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
              weatherData['main'] != null
                  ? iconSrc[weatherData['main']]
                  : 'assets/icons/sand-clock.svg',
              width: 32,
              color: Colors.white,
            ),
            SizedBox(width: 10),
            Text(
              weatherData['main'] != null ? weatherData['main'] : '- -',
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
              barWidthFactor: weatherData['wind'] != null
                  ? weatherData['wind'] / 25 <= 1
                      ? weatherData['wind'] / 25
                      : 1
                  : 0,
            ),
            WeatherData(
              title: 'Temp Min',
              value: weatherData['temp_min'],
              sign: '°C',
              barColor: Colors.blueAccent,
              barWidthFactor: weatherData['temp_min'] == null
                  ? 0
                  : abs(weatherData['temp_min']) / 60,
            ),
            WeatherData(
              title: 'Temp Max',
              value: weatherData['temp_max'],
              sign: '°C',
              barColor: Colors.greenAccent,
              barWidthFactor: weatherData['temp_max'] == null
                  ? 0
                  : abs(weatherData['temp_max']) / 60,
            ),
          ],
        ),
      ],
    );
  }
}
