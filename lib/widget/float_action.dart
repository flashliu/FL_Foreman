import 'package:FL_Foreman/res/svgs.dart';
import 'package:flutter/material.dart';

class FloatAction extends StatelessWidget {
  final Function onAdd;
  final Function onSearch;
  const FloatAction({Key key, this.onAdd, this.onSearch}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: 167,
      padding: EdgeInsets.symmetric(horizontal: 35),
      decoration: BoxDecoration(color: Color.fromRGBO(81, 91, 107, 0.75), borderRadius: BorderRadius.circular(30)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: onAdd,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Svgs.add,
                SizedBox(height: 2),
                Text(
                  '添加',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: onSearch,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Svgs.search,
                SizedBox(height: 2),
                Text(
                  '查找',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
