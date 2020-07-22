import 'package:flutter/material.dart';

class Pannel extends StatelessWidget {
  final Widget child;
  const Pannel({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.only(bottom: 16),
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(12),
        ),
        boxShadow: [BoxShadow(color: Colors.grey[100], blurRadius: 15)],
      ),
      child: child,
    );
  }
}
