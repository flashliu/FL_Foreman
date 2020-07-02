import 'package:FL_User/views/home.dart';
import 'package:FL_User/views/mine.dart';
import 'package:FL_User/views/shop.dart';
import 'package:flutter/material.dart';

class TabNavBar extends StatefulWidget {
  TabNavBar({Key key}) : super(key: key);

  @override
  _TabNavBarState createState() => _TabNavBarState();
}

class _TabNavBarState extends State<TabNavBar> {
  int current = 0;
  final tabs = [
    {
      'name': '首页',
      'icon': 'assets/images/home.png',
      'selected_icon': 'assets/images/home_selected.png',
    },
    {
      'name': '商城',
      'icon': 'assets/images/shop.png',
      'selected_icon': 'assets/images/shop_selected.png',
    },
    {
      'name': '我的',
      'icon': 'assets/images/mine.png',
      'selected_icon': 'assets/images/mine_selected.png',
    },
  ];

  final tabPages = [Home(), Shop(), Mine()];
  @override
  Widget build(BuildContext context) {
    final items = tabs
        .asMap()
        .entries
        .map((e) => createItem(
              name: e.value['name'],
              imgPath: current == e.key ? e.value['selected_icon'] : e.value['icon'],
            ))
        .toList();
    return Scaffold(
      body: tabPages.asMap()[current],
      bottomNavigationBar: BottomNavigationBar(
        items: items,
        currentIndex: current,
        onTap: (index) {
          setState(() {
            current = index;
          });
        },
        selectedFontSize: 12,
        unselectedFontSize: 12,
      ),
    );
  }

  BottomNavigationBarItem createItem({String name, String imgPath}) {
    return BottomNavigationBarItem(
      icon: Padding(
        padding: EdgeInsets.only(bottom: 3),
        child: Image.asset(
          imgPath,
          width: 24,
          height: 24,
        ),
      ),
      title: Text(name),
    );
  }
}
