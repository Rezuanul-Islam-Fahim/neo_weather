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
            width: double.infinity,
            height: double.infinity,
            child: Image.asset(
              'assets/images/cloudy.jpeg',
              fit: BoxFit.cover,
            ),
          ),
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[
                  Colors.black54,
                  Colors.black54,
                  Colors.black45,
                  Colors.black12,
                ],
                stops: [0.1, 0.3, 0.7, 1],
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
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              SizedBox(height: 25),
              SearchBox(),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 45, left: 15),
            child: IconButton(
              icon: Icon(Icons.arrow_back_ios_rounded),
              iconSize: 30,
              color: Colors.white,
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ],
      ),
    );
  }
}
