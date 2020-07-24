import 'package:FL_Foreman/res/colors.dart';
import 'package:FL_Foreman/res/svgs.dart';
import 'package:FL_Foreman/widget/nurse_item.dart';
import 'package:flutter/material.dart';

class NurseList extends StatefulWidget {
  NurseList({Key key}) : super(key: key);

  @override
  _NurseListState createState() => _NurseListState();
}

class _NurseListState extends State<NurseList> {
  final List<String> levels = ['全部', '特级', '一级', '二级', '三级'];
  bool showLocation = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorCenter.background,
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: Row(
              children: [
                Expanded(
                  child: DefaultTabController(
                    length: 5,
                    child: TabBar(
                      tabs: levels.map((e) => Text(e)).toList(),
                      isScrollable: true,
                      indicatorSize: TabBarIndicatorSize.label,
                      indicatorColor: ColorCenter.themeColor,
                      labelColor: ColorCenter.themeColor,
                      unselectedLabelColor: Colors.black,
                      unselectedLabelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      onTap: (index) {},
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      showLocation = !showLocation;
                    });
                  },
                  child: Svgs.show,
                ),
              ],
            ),
          ),
          NurseItem(
            showLocation: showLocation,
          ),
          NurseItem(
            showLocation: showLocation,
          ),
          NurseItem(
            showLocation: showLocation,
          ),
        ],
      ),
    );
  }
}
