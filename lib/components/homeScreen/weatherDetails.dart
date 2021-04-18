import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'weatherData.dart';
import 'helpers.dart';

class WeatherDetails extends StatelessWidget {
  const WeatherDetails(this.weatherData);

  final Map<String, dynamic> weatherData;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 35),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          weatherData['temp'] != null
              ? Text(
                  '${weatherData['temp'].toStringAsFixed(0)}°C',
                  style: const TextStyle(color: Colors.white, fontSize: 60),
                )
              : Text(
                  '- -',
                  style: const TextStyle(color: Colors.white, fontSize: 60),
                ),
          const SizedBox(height: 5),
          Row(
            children: <Widget>[
              SvgPicture.asset(
                weatherData['main'] != null
                    ? weatherStatus[weatherData['main']]['icon']
                    : 'assets/icons/sand-clock.svg',
                width: 32,
                color: Colors.white,
              ),
              const SizedBox(width: 10),
              Text(
                weatherData['main'] != null ? weatherData['main'] : '- -',
                style: const TextStyle(color: Colors.white, fontSize: 23),
              ),
            ],
          ),
          const SizedBox(height: 18),
          const Divider(color: Colors.white30),
          const SizedBox(height: 18),
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
      ),
    );
  }
}
