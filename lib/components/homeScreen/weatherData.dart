import 'package:flutter/material.dart';

import 'progressBar.dart';

class WeatherData extends StatelessWidget {
  const WeatherData({
    @required this.title,
    @required this.value,
    @required this.sign,
    @required this.barColor,
    @required this.barWidthFactor,
  });

  final String title;
  final dynamic value;
  final String sign;
  final Color barColor;
  final double barWidthFactor;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          title,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
        const SizedBox(height: 4),
        value != null
            ? Text(
                value.toStringAsFixed(0),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              )
            : Text(
                '- -',
                style: const TextStyle(color: Colors.white, fontSize: 20),
              ),
        const SizedBox(height: 4),
        Text(
          sign,
          style: const TextStyle(color: Colors.white, fontSize: 15),
        ),
        const SizedBox(height: 6),
        ProgressBar(barColor, barWidthFactor),
      ],
    );
  }
}
