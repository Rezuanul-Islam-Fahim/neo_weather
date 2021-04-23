import 'package:flutter/material.dart';

dynamic abs(dynamic value) {
  return value < 0 ? -(value) : value;
}

Map<String, dynamic> weatherStatus = {
  'Clear': {
    'img': 'assets/images/sunny.jpg',
    'icon': 'assets/icons/sun.svg',
    'overlay': BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: const <Color>[
          Colors.black26,
          Colors.black12,
          Colors.black38,
        ],
        stops: const [0.1, 0.6, 0.9],
      ),
    ),
  },
  'Haze': {
    'img': 'assets/images/haze.jpg',
    'icon': 'assets/icons/haze.svg',
    'overlay': BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: <Color>[
          Colors.black12,
          Colors.black12.withOpacity(0.05),
        ],
        stops: const [0.3, 1],
      ),
    ),
  },
  'Smoke': {
    'img': 'assets/images/haze.jpg',
    'icon': 'assets/icons/haze.svg',
    'overlay': BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: <Color>[
          Colors.black12,
          Colors.black12.withOpacity(0.05),
        ],
        stops: const [0.3, 1],
      ),
    ),
  },
  'Mist': {
    'img': 'assets/images/mist.jpg',
    'icon': 'assets/icons/haze.svg',
    'overlay': BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: <Color>[
          Colors.black12,
          Colors.black12.withOpacity(0.05),
        ],
        stops: const [0.1, 1],
      ),
    ),
  },
  'Clouds': {
    'img': 'assets/images/cloudy.jpeg',
    'icon': 'assets/icons/cloudy.svg',
    'overlay': BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: <Color>[
          Colors.black.withOpacity(0.25),
          Colors.black26,
          Colors.black12,
          Colors.black12,
        ],
        stops: const [0.1, 0.3, 0.7, 1],
      ),
    ),
  },
  'Rain': {
    'img': 'assets/images/rainy.jpg',
    'icon': 'assets/icons/rain.svg',
    'overlay': BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: <Color>[
          Colors.black26,
          Colors.black.withOpacity(0.05),
        ],
        stops: const [0.3, 1],
      ),
    ),
  },
  'Snow': {
    'img': 'assets/images/snow.jpg',
    'icon': 'assets/icons/snow.svg',
    'overlay': BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: <Color>[
          Colors.black12.withOpacity(0.08),
          Colors.black38,
        ],
        stops: const [0.3, 0.7],
      ),
    ),
  },
};
