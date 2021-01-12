import 'package:flutter/material.dart';

class SearchBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      margin: EdgeInsets.symmetric(horizontal: 25),
      padding: EdgeInsets.only(left: 25),
      decoration: BoxDecoration(
        color: Colors.white12,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              style: TextStyle(color: Colors.white, fontSize: 17),
              decoration: InputDecoration(
                hintText: 'Enter City Name',
                hintStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                ),
                border: InputBorder.none,
              ),
            ),
          ),
          InkWell(
            splashColor: Colors.blueAccent,
            onTap: () {},
            child: Container(
              width: 55,
              height: 55,
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Icon(
                Icons.arrow_forward_rounded,
                size: 26,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
