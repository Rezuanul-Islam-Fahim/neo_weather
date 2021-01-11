import 'package:flutter/material.dart';

class WeatherInDepth extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Column(
          children: <Widget>[
            Text(
              'Wind',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            Text(
              '10',
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
            Text(
              'km/h',
              style: TextStyle(color: Colors.white, fontSize: 15),
            ),
            SizedBox(height: 8),
            ProgressBar(Colors.red, 0.6),
          ],
        ),
        Column(
          children: <Widget>[
            Text(
              'Rain',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            Text(
              '2',
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
            Text(
              '%',
              style: TextStyle(color: Colors.white, fontSize: 15),
            ),
            SizedBox(height: 8),
            ProgressBar(Colors.blueAccent, 0.4),
          ],
        ),
        Column(
          children: <Widget>[
            Text(
              'Humidity',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            Text(
              '8',
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
            Text(
              '%',
              style: TextStyle(color: Colors.white, fontSize: 15),
            ),
            SizedBox(height: 8),
            ProgressBar(Colors.green, 0.2),
          ],
        ),
      ],
    );
  }
}

class ProgressBar extends StatelessWidget {
  ProgressBar(this.color, this.widthFactor);

  final Color color;
  final double widthFactor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 55,
      height: 7,
      decoration: BoxDecoration(
        color: Colors.white12,
        borderRadius: BorderRadius.circular(30),
      ),
      alignment: Alignment.centerLeft,
      child: FractionallySizedBox(
        widthFactor: widthFactor,
        child: Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    );
  }
}
