import 'package:flutter/material.dart';

import '../../screens/searchScreen.dart';

class HeadSection extends StatelessWidget {
  const HeadSection(this.weatherData, this.isSetWeather, this.handler);

  final Map<String, dynamic> weatherData;
  final bool isSetWeather;
  final Function handler;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.search),
              iconSize: 35,
              color: Colors.white,
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => SearchPage(),
                ),
              ),
            ),
            if (isSetWeather != null)
              IconButton(
                icon: Icon(
                  Icons.delete_forever,
                  color: Colors.white,
                  size: 30,
                ),
                onPressed: handler,
              ),
          ],
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              isSetWeather == null
                  ? Text(
                      'No City Added',
                      style: TextStyle(color: Colors.white, fontSize: 34),
                    )
                  : weatherData['city'] != null
                      ? Text(
                          weatherData['city'],
                          style: TextStyle(color: Colors.white, fontSize: 38),
                        )
                      : Text(
                          '- -',
                          style: TextStyle(color: Colors.white, fontSize: 38),
                        ),
              SizedBox(height: 5),
              Text(
                '07:50 PM - Monday, 9 Nov 2020',
                style: TextStyle(color: Colors.white, fontSize: 17),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
