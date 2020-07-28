import 'package:FL_Foreman/apis/order_api.dart';
import 'package:FL_Foreman/models/need_model.dart';
import 'package:FL_Foreman/res/colors.dart';
import 'package:FL_Foreman/res/svgs.dart';
import 'package:FL_Foreman/views/my_order_list/my_order_list.dart';
import 'package:FL_Foreman/widget/list_content.dart';
import 'package:FL_Foreman/widget/need_item.dart';
import 'package:flutter/cupertino.dart';
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
  List<Need> needList = [];
  int siteIndex = 0;

  @override
  void initState() {
    super.initState();
    getNeedList(0);
  }

  getNeedList(int index) async {
    final list = await OrderApi.getNeedList(serverSites[index]);
    await Future.delayed(Duration(seconds: 1));
    if (this.mounted) {
      setState(() {
        loading = false;
        needList = list;
      });
    }
    refreshController.refreshCompleted();
  }

  buildList() {
    if (loading) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            NeedItemShimmer(),
            NeedItemShimmer(),
            NeedItemShimmer(),
          ],
        ),
      );
    }
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SmartRefresher(
          header: WaterDropHeader(
            complete: Text('刷新成功！'),
            refresh: CupertinoActivityIndicator(),
          ),
          footer: ClassicFooter(),
          onRefresh: () => getNeedList(siteIndex),
          controller: refreshController,
          child: ListContent(
            itemBuilder: (context, index) {
              return NeedItem(
                info: needList[index],
              );
            },
            itemCount: needList.length,
            emptyText: "暂时没有内容～",
          ),
        ),
      ),
    );
  }

  Widget buildNeedTab() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          Expanded(
            child: DefaultTabController(
              length: serverSites.length,
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
                  refreshController.requestRefresh();
                },
              ),
            ),
          ),
          Row(
            children: [
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
              SizedBox(
                width: 10,
              )
            ],
            mainAxisAlignment: MainAxisAlignment.end,
          ),
        ],
      ),
    );
  }

  buildFloat() {
    return FloatingActionButton(
      onPressed: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => MyOrderList()));
      },
      child: Svgs.order,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          child: Column(
            children: [
              buildNeedTab(),
              buildList(),
            ],
          ),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: EdgeInsets.only(bottom: 40, right: 16),
            child: buildFloat(),
          ),
        )
      ],
    );
  }
}
