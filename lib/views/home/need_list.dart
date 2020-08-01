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

  @override
  void dispose() {
    refreshController.dispose();
    super.dispose();
  }

  getNeedList(int index) async {
    final list = await OrderApi.getNeedList(serverSites[index]);
    await Future.delayed(Duration(milliseconds: 500));
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
      return Expanded(
        child: Wrap(
          children: [
            NeedItemShimmer(),
            NeedItemShimmer(),
            NeedItemShimmer(),
            NeedItemShimmer(),
          ],
        ),
      );
    }
    return Expanded(
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
                  setState(() {
                    loading = true;
                  });
                  getNeedList(index);
                },
              ),
            ),
          ),
          Row(
            children: [
              InkWell(
                onTap: () {
                  showSearch(context: context, delegate: NeedSearchDelegate());
                },
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
        Navigator.of(context).push(CupertinoPageRoute(builder: (_) => MyOrderList()));
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

class NeedSearchDelegate extends SearchDelegate {
  List<String> suggestions = ['生活护理', '术后护理', '康复护理', '高级护理'];
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(
          Icons.search,
        ),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return ListView.separated(
      itemBuilder: (context, index) {
        return Container(
          height: 60,
          alignment: Alignment.center,
          child: Text(
            '$index',
            style: TextStyle(fontSize: 20),
          ),
        );
      },
      separatorBuilder: (context, index) {
        return Divider();
      },
      itemCount: 10,
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return ListView.separated(
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(suggestions[index]),
          onTap: () {
            query = suggestions[index];
            this.showResults(context);
          },
        );
      },
      separatorBuilder: (context, index) {
        return Divider(
          height: 1,
        );
      },
      itemCount: suggestions.length,
    );
  }
}
