import 'package:FL_Foreman/apis/order_api.dart';
import 'package:FL_Foreman/res/colors.dart';
import 'package:FL_Foreman/res/svgs.dart';
import 'package:FL_Foreman/widget/order_item.dart';
import 'package:FL_Foreman/widget/state_layout.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class NeedList extends StatefulWidget {
  NeedList({Key key}) : super(key: key);

  @override
  _NeedListState createState() => _NeedListState();
}

class _NeedListState extends State<NeedList> with SingleTickerProviderStateMixin {
  final List<String> serverSites = ['推荐', '医院', '居家', '敬老院'];
  RefreshController refreshController = RefreshController();
  bool loading = true;
  List needList = [];
  int siteIndex = 0;

  @override
  void initState() {
    super.initState();
    getNeedList();
  }

  getNeedList() async {
    final res = await OrderApi.getNeedList(serverSites[siteIndex]);
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      loading = false;
    });
  }

  buildList() {
    if (loading) {
      return Column(
        children: [
          OrderItemShimmer(),
          OrderItemShimmer(),
          OrderItemShimmer(),
        ],
      );
    }
    if (needList.length == 0) {
      return Expanded(
        child: Center(
          child: StateLayout(
            type: StateType.empty,
            hintText: '暂时没有内容~',
          ),
        ),
      );
    }
    return Expanded(
      child: SmartRefresher(
        controller: refreshController,
        child: ListView.builder(itemBuilder: (context, index) {
          return OrderItem();
        }),
      ),
    );
  }

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
                        onTap: (index) {
                          siteIndex = index;
                        },
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
            buildList()
          ],
        ),
      ),
    );
  }
}
