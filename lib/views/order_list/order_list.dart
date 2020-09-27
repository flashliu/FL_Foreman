import 'package:FL_Foreman/providers/style_provider.dart';
import 'package:FL_Foreman/res/colors.dart';
import 'package:FL_Foreman/res/text_styles.dart';
import 'package:FL_Foreman/views/order_list/order_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

List<Map> tabMaps = [
  {"text": '全部', "status": 0},
  // {"text": '抢单中', "status": 99},
  // {"text": '待付款', "status": 1},
  {"text": '待执行', "status": 20},
  {"text": '执行中', "status": 21},
  {"text": '已结束', "status": 100},
];

class OrderList extends StatefulWidget {
  final String parentId;
  final String nurseId;
  final bool showAppbar;
  OrderList({
    Key key,
    this.parentId,
    this.showAppbar = true,
    this.nurseId,
  }) : super(key: key);

  @override
  _OrderListState createState() => _OrderListState();
}

class _OrderListState extends State<OrderList> with SingleTickerProviderStateMixin {
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
      child: Provider(
        create: (context) => StyleProvider(
          listShowPaddingTop: false,
          showNurse: Provider.of<StyleProvider>(context, listen: false).showNurse,
        ),
        child: TabBarView(
          children: tabMaps
              .map(
                (e) => OrderPage(
                  status: e['status'],
                  parentId: widget.parentId,
                  nurseId: widget.nurseId,
                ),
              )
              .toList(),
          controller: tabController,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.showAppbar
          ? AppBar(
              leading: InkWell(
                child: Icon(Icons.chevron_left),
                onTap: () => Navigator.of(context).pop(),
              ),
              title: Text('我的派单'),
              titleSpacing: 0,
            )
          : null,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [buildTabBar(), buildTabPage()],
      ),
    );
  }
}
