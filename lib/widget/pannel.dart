import 'package:flutter/material.dart';

class Pannel extends StatelessWidget {
  final Widget child;
  final Function onTap;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;
  final Color color;
  const Pannel({
    Key key,
    this.child,
    this.onTap,
    this.margin = const EdgeInsets.only(bottom: 16, left: 16, right: 16),
    this.padding = const EdgeInsets.all(16),
    this.color = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: Material(
        elevation: 10,
        shadowColor: Colors.grey[100].withOpacity(0.2),
        color: color,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            child: child,
            padding: padding,
          ),
          onTap: onTap,
        ),
      ),
    );
  }
}
