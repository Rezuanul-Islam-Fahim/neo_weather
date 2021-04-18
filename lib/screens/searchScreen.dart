import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../components/searchScreen/searchBox.dart';

class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: const AssetImage('assets/images/cloudy.jpeg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[
                  Colors.black45.withOpacity(0.6),
                  Colors.black26,
                  Colors.black12,
                ],
                stops: const [0.2, 0.6, 1],
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SvgPicture.asset(
                'assets/icons/cloudy.svg',
                color: Colors.white,
                width: 130,
              ),
              const Text(
                'Add City to See Weather Details',
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
              const SizedBox(height: 20),
              SearchBox(),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 45, left: 15),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_rounded),
              iconSize: 32,
              color: Colors.white,
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ],
      ),
    );
  }
}
