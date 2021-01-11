import 'package:flutter/material.dart';

class ProgressBar extends StatelessWidget {
  const ProgressBar(this.color, this.widthFactor);

  final Color color;
  final double widthFactor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 55,
      height: 7,
      decoration: BoxDecoration(
        color: Colors.white12,
        borderRadius: BorderRadius.circular(30),
      ),
      alignment: Alignment.centerLeft,
      child: FractionallySizedBox(
        widthFactor: widthFactor,
        child: Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    );
  }
}
