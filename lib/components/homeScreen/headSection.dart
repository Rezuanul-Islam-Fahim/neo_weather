import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HeadSection extends StatelessWidget {
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
              onPressed: () {},
            ),
            IconButton(
              icon: SvgPicture.asset(
                'assets/icons/menu.svg',
                color: Colors.white,
                width: 32,
              ),
              onPressed: () {},
            ),
          ],
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Dhaka',
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
