import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

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
                width: 150,
              ),
              SizedBox(height: 5),
              Text(
                'Add City to See Weather Details',
                style: TextStyle(color: Colors.white, fontSize: 22),
              ),
              SizedBox(height: 35),
              Container(
                width: double.infinity,
                height: 60,
                margin: EdgeInsets.symmetric(horizontal: 25),
                padding: EdgeInsets.only(left: 25),
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        style: TextStyle(color: Colors.white, fontSize: 18),
                        decoration: InputDecoration(
                          hintText: 'Enter City Name',
                          hintStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    InkWell(
                      splashColor: Colors.blueAccent,
                      onTap: () {},
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.blueAccent,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Icon(
                          Icons.arrow_forward_rounded,
                          size: 30,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
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
