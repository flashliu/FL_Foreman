import 'package:flutter/material.dart';

class Dot extends StatelessWidget {
  final Color dotColor;
  final double width;
  final double height;
  final double leftMargin;
  final double topMargin;
  final double bottomMargin;
  final double rightMargin;

  Dot({
    this.dotColor: Colors.orangeAccent,
    this.leftMargin: 4,
    this.topMargin: 4,
    this.bottomMargin: 4,
    this.rightMargin: 4,
    this.width: 8,
    this.height: 8,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10)), color: dotColor),
      margin: EdgeInsets.only(left: leftMargin, right: rightMargin, top: topMargin, bottom: bottomMargin),
      height: height,
      width: width,
    );
  }
}
