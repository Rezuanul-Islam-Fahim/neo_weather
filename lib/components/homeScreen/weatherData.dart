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
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        value != null
            ? Text(
                value.toStringAsFixed(0),
                style: TextStyle(color: Colors.white, fontSize: 25),
              )
            : Text(
                '- -',
                style: TextStyle(color: Colors.white, fontSize: 25),
              ),
        Text(
          sign,
          style: TextStyle(color: Colors.white, fontSize: 15),
        ),
        SizedBox(height: 8),
        ProgressBar(barColor, barWidthFactor),
      ],
    );
  }
}
