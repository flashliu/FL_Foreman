import 'package:FL_Foreman/res/colors.dart';
import 'package:FL_Foreman/res/text_styles.dart';
import 'package:FL_Foreman/views/my_order_list/order_page.dart';
import 'package:flutter/material.dart';

List<Map> tabMaps = [
  {"text": '全部', "status": 0},
  {"text": '抢单中', "status": 99},
  {"text": '待付款', "status": 1},
  {"text": '待执行', "status": 20},
  {"text": '执行中', "status": 21},
  {"text": '已结束', "status": 100},
];

class MyOrderList extends StatefulWidget {
  MyOrderList({Key key}) : super(key: key);

  @override
  _MyOrderListState createState() => _MyOrderListState();
}

class _MyOrderListState extends State<MyOrderList> with SingleTickerProviderStateMixin {
  TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: tabMaps.length, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  Widget buildTabBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TabBar(
        tabs: tabMaps
            .map((e) => Padding(padding: const EdgeInsets.only(top: 10, bottom: 4), child: Text(e['text'])))
            .toList(),
        isScrollable: true,
        indicatorSize: TabBarIndicatorSize.label,
        indicatorColor: ColorCenter.themeColor,
        controller: tabController,
        labelColor: ColorCenter.themeColor,
        unselectedLabelColor: Colors.black,
        unselectedLabelStyle: TextStyles.black_Bold_14,
        labelStyle: TextStyles.black_Bold_14,
      ),
    );
  }

  Widget buildTabPage() {
    return Expanded(
      child: TabBarView(
        children: tabMaps.map((e) => OrderPage(status: e['status'])).toList(),
        controller: tabController,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          child: Icon(Icons.chevron_left),
          onTap: () => Navigator.of(context).pop(),
        ),
        title: Text('我的派单'),
        titleSpacing: 0,
      ),
      body: Column(
        children: [buildTabBar(), buildTabPage()],
      ),
    );
  }
}
