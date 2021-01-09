import 'package:flutter/material.dart';

import './components/headSection.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: AppBody(),
      ),
    );
  }
}

class AppBody extends StatefulWidget {
  @override
  _AppBodyState createState() => _AppBodyState();
}

class _AppBodyState extends State<AppBody> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Image.asset(
          'assets/images/night.jpg',
          fit: BoxFit.cover,
          height: double.infinity,
        ),
        Container(
          width: double.infinity,
          height: double.infinity,
          padding: EdgeInsets.fromLTRB(10, 35, 10, 20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[
                Colors.white24.withOpacity(0.22),
                Colors.white12,
                Colors.white12,
                Colors.white10,
              ],
              stops: [0.1, 0.3, 0.7, 1],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              HeadSection(),
            ],
          ),
        ),
      ],
    );
  }
}
