import 'package:FL_Foreman/res/colors.dart';
import 'package:FL_Foreman/res/svgs.dart';
import 'package:FL_Foreman/widget/order_item.dart';
import 'package:flutter/material.dart';

class NeedList extends StatefulWidget {
  NeedList({Key key}) : super(key: key);

  @override
  _NeedListState createState() => _NeedListState();
}

class _NeedListState extends State<NeedList> {
  final List<String> serverSites = ['推荐', '医院', '居家', '敬老院'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Svgs.order,
      ),
      body: Container(
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
                      length: 4,
                      child: TabBar(
                        tabs: serverSites.map((e) => Text(e)).toList(),
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
                    onTap: () {},
                    child: Hero(
                      tag: 'search',
                      child: Icon(
                        Icons.search,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            OrderItem(),
            OrderItem(),
            OrderItem(),
          ],
        ),
      ),
    );
  }
}
