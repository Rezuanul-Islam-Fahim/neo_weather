import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'weatherInDepth.dart';

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
        WeatherInDepth(),
      ],
    );
  }
}
