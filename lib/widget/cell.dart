import 'package:FL_Foreman/widget/pannel.dart';
import 'package:flutter/material.dart';

class Cell extends StatelessWidget {
  final String label;
  final Widget action;
  final String value;
  final Function onTap;
  Cell({
    Key key,
    this.label,
    this.value = '',
    this.action,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Pannel(
      onTap: onTap,
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(fontSize: 14),
            ),
          ),
          buildRight(),
          Visibility(
            visible: onTap != null,
            child: Icon(
              Icons.keyboard_arrow_right,
              color: Colors.grey[700],
              size: 20,
            ),
          )
        ],
      ),
    );
  }

  Widget buildRight() {
    if (action != null) return action;
    return Text(value, style: TextStyle(fontSize: 14));
  }
}
