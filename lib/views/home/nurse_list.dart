import 'package:FL_Foreman/apis/nurse_api.dart';
import 'package:FL_Foreman/common/global.dart';
import 'package:FL_Foreman/common/toast_utils.dart';
import 'package:FL_Foreman/models/nurse_model.dart';
import 'package:FL_Foreman/res/colors.dart';
import 'package:FL_Foreman/res/svgs.dart';
import 'package:FL_Foreman/res/text_styles.dart';
import 'package:FL_Foreman/widget/list_content.dart';
import 'package:FL_Foreman/widget/nurse_item.dart';
import 'package:FL_Foreman/widget/state_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class NurseList extends StatefulWidget {
  NurseList({Key key}) : super(key: key);

  @override
  _NurseListState createState() => _NurseListState();
}

class _NurseListState extends State<NurseList> {
  final List<String> levels = ['全部', '特级', '一级', '二级', '三级'];
  bool loading = true;
  bool showLocation = false;
  RefreshController refreshController = RefreshController();
  List<Nurse> list = [];
  int levelIndex = 0;

  addNurse() async {
    final user = await Global.scanQrcode(context);
    final res = await NurseApi.addNurse(user.id);
    if (res['code'] == 200) {
      getNurseList(levelIndex);
    }
    ToastUtils.showLong(res['message']);
  }

  delNurse(id) async {
    final res = await NurseApi.delNurse(id);
    if (res['code'] == 200) {
      ToastUtils.showLong(res['message']);
      getNurseList(levelIndex);
    }
  }

  getNurseList(int index) async {
    final nurseLevel = levelIndex == 0 ? '' : (levelIndex - 1).toString();
    final data = await NurseApi.getNurseList(nurseLevel);
    await Future.delayed(Duration(milliseconds: 300));
    if (this.mounted) {
      setState(() {
        list = data;
        loading = false;
      });
    }
    refreshController.refreshCompleted();
  }

  @override
  void initState() {
    super.initState();
    getNurseList(levelIndex);
  }

  @override
  void dispose() {
    refreshController.dispose();
    super.dispose();
  }

  Widget buildItems() {
    if (loading) {
      return Expanded(
        child: Wrap(
          children: [
            NurseItemShimmer(),
            NurseItemShimmer(),
            NurseItemShimmer(),
            NurseItemShimmer(),
            NurseItemShimmer(),
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
        onRefresh: () => getNurseList(levelIndex),
        controller: refreshController,
        child: ListContent(
          itemBuilder: (context, index) {
            return NurseItem(
              info: list[index],
              showLocation: showLocation,
              onDelete: (info) => delNurse(info.id),
            );
          },
          itemCount: list.length,
          emptyText: "暂时没有内容～",
        ),
      ),
    );
  }

  Widget buildTab() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          Expanded(
            child: DefaultTabController(
              length: levels.length,
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
                onTap: (index) {
                  levelIndex = index;
                  setState(() {
                    loading = true;
                  });
                  getNurseList(index);
                },
              ),
            ),
          ),
          Row(
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    showLocation = !showLocation;
                  });
                },
                child: Svgs.show,
              ),
              SizedBox(
                width: 16,
              )
            ],
            mainAxisAlignment: MainAxisAlignment.end,
          ),
        ],
      ),
    );
  }

  buildFloat() {
    return Container(
      height: 60,
      width: 167,
      padding: EdgeInsets.symmetric(horizontal: 35),
      decoration: BoxDecoration(color: Color.fromRGBO(81, 91, 107, 0.75), borderRadius: BorderRadius.circular(30)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => addNurse(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Svgs.add,
                SizedBox(height: 2),
                Text(
                  '添加',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => showSearch(context: context, delegate: NurseSearchDelegate()),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Svgs.search,
                SizedBox(height: 2),
                Text(
                  '查找',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          child: Column(
            children: [
              buildTab(),
              buildItems(),
            ],
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: EdgeInsets.only(bottom: 50),
            child: buildFloat(),
          ),
        )
      ],
    );
  }
}

class NurseSearchDelegate extends SearchDelegate {
  List<String> suggestions = ['特级护理', '一级护理', '二级护理', '三级护理'];

  @override
  String get searchFieldLabel => '请输入护工等级、名字';

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
      future: NurseApi.searchNurseList(query),
      builder: (BuildContext context, AsyncSnapshot<List<Nurse>> snapshot) {
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
              return NurseItem(
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
