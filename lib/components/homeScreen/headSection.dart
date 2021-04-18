import 'package:flutter/material.dart';

import 'package:timer_builder/timer_builder.dart';
import 'package:intl/intl.dart';

import '../../screens/searchScreen.dart';

class HeadSection extends StatelessWidget {
  const HeadSection(this.weatherData, this.isSetWeather, this.handler);

  final Map<String, dynamic> weatherData;
  final bool isSetWeather;
  final Function handler;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 45, left: 15, right: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                icon: const Icon(Icons.search),
                iconSize: 32,
                color: Colors.white,
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => SearchPage(),
                  ),
                ),
              ),
              if (isSetWeather != null)
                IconButton(
                  icon: const Icon(
                    Icons.delete_forever,
                    color: Colors.white,
                    size: 28,
                  ),
                  onPressed: handler,
                ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                isSetWeather == null
                    ? const Text(
                        'No City Added',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 34,
                        ),
                      )
                    : weatherData['city'] != null
                        ? Text(
                            weatherData['city'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 38,
                            ),
                          )
                        : const Text(
                            '- -',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 38,
                            ),
                          ),
                const SizedBox(height: 8),
                TimerBuilder.periodic(
                  const Duration(seconds: 1),
                  builder: (BuildContext context) {
                    return Text(
                      DateFormat('hh:mm:ss a - E, MMMM d, y')
                          .format(DateTime.now()),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
