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
                image: AssetImage('assets/images/cloudy.jpeg'),
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
                stops: [0.2, 0.6, 1],
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
              SizedBox(height: 5),
              Text(
                'Add City to See Weather Details',
                style: TextStyle(color: Colors.white, fontSize: 19),
              ),
              SizedBox(height: 25),
              SearchBox(),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 45, left: 15),
            child: IconButton(
              icon: Icon(Icons.arrow_back_rounded),
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
