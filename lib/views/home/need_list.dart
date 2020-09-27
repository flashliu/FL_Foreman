import 'package:FL_Foreman/apis/order_api.dart';
import 'package:FL_Foreman/common/global.dart';
import 'package:FL_Foreman/models/tab_page_data.dart';
import 'package:FL_Foreman/res/colors.dart';
import 'package:FL_Foreman/res/svgs.dart';
import 'package:FL_Foreman/res/text_styles.dart';
import 'package:FL_Foreman/views/home/create_order.dart';
import 'package:FL_Foreman/views/home/need_page.dart';
import 'package:FL_Foreman/views/my_order_list/my_order_list.dart';
import 'package:FL_Foreman/widget/need_item.dart';
import 'package:FL_Foreman/widget/state_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NeedList extends StatefulWidget {
  NeedList({Key key}) : super(key: key);

  @override
  _NeedListState createState() => _NeedListState();
}

class _NeedListState extends State<NeedList> with SingleTickerProviderStateMixin {
  final List<TabPageData> serverSites = [];
  Map<String, TabPageData> allPermissions = {
    "self_order": TabPageData(tab: Text('医院'), view: NeedPage(site: '医院')),
    "online_order": TabPageData(tab: Text('线上订单'), view: NeedPage(site: '线上订单')),
  };
  TabController tabController;

  @override
  void initState() {
    super.initState();
    allPermissions.forEach((key, value) {
      if (Global.permissions.contains(key)) {
        serverSites.add(value);
      }
    });
    tabController = TabController(length: serverSites.length, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  Widget buildTabPage() {
    return Expanded(
      child: TabBarView(
        children: serverSites.map((e) => e.view).toList(),
        controller: tabController,
      ),
    );
  }

  Widget buildNeedTab() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          Expanded(
            child: TabBar(
              controller: tabController,
              tabs: serverSites.map((e) => e.tab).toList(),
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
            ),
          ),
          // InkWell(
          //   onTap: () {
          //     showSearch(context: context, delegate: NeedSearchDelegate());
          //   },
          //   child: Padding(
          //     padding: const EdgeInsets.all(16),
          //     child: Icon(
          //       Icons.search,
          //       color: Colors.grey,
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  buildOrderButton() {
    return FloatingActionButton(
      heroTag: null,
      onPressed: () {
        Navigator.of(context).push(CupertinoPageRoute(builder: (_) => MyOrderList()));
      },
      child: Svgs.order,
    );
  }

  buildAddButton() {
    return Visibility(
      visible: Global.permissions.contains('push_order'),
      child: FloatingActionButton(
        heroTag: null,
        onPressed: () {
          Navigator.of(context).push(CupertinoPageRoute(builder: (_) => CreateOrder()));
        },
        child: Icon(Icons.add),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            buildNeedTab(),
            buildTabPage(),
          ],
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: EdgeInsets.only(bottom: 40, right: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                buildAddButton(),
                SizedBox(height: 24),
                buildOrderButton(),
              ],
            ),
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
