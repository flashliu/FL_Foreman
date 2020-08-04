import 'package:FL_Foreman/apis/order_api.dart';
import 'package:FL_Foreman/models/need_model.dart';
import 'package:FL_Foreman/res/colors.dart';
import 'package:FL_Foreman/res/svgs.dart';
import 'package:FL_Foreman/res/text_styles.dart';
import 'package:FL_Foreman/views/my_order_list/my_order_list.dart';
import 'package:FL_Foreman/widget/list_content.dart';
import 'package:FL_Foreman/widget/need_item.dart';
import 'package:FL_Foreman/widget/state_layout.dart';
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
    List<Need> list;
    if (index == 0) {
      list = await OrderApi.getNeedSuggestList();
    } else {
      list = await OrderApi.getNeedList(serverSites[index]);
    }

    await Future.delayed(Duration(milliseconds: 300));
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
  String get searchFieldLabel => '请输入护理类型';

  @override
  TextStyle get searchFieldStyle => TextStyle(fontSize: 16);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(
          Icons.search,
        ),
        onPressed: () {
          showResults(context);
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
    return FutureBuilder(
      future: OrderApi.searchNeedList(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.data.length == 0) {
          return StateLayout(
            type: StateType.empty,
            hintText: '没有查询到数据',
          );
        }
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: ListView.builder(
            itemBuilder: (context, index) {
              return NeedItem(
                info: snapshot.data[index],
              );
            },
            itemCount: snapshot.data.length,
          ),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final filterSuggestions = suggestions.where((f) => f.contains(query)).toList();
    return ListView.separated(
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(
            filterSuggestions[index],
            style: TextStyles.black_14,
          ),
          onTap: () {
            query = filterSuggestions[index];
            this.showResults(context);
          },
        );
      },
      separatorBuilder: (context, index) {
        return Divider(
          height: 1,
        );
      },
      itemCount: filterSuggestions.length,
    );
  }
}
