import 'package:FL_Foreman/apis/nurse_api.dart';
import 'package:FL_Foreman/common/global.dart';
import 'package:FL_Foreman/models/nurse_model.dart';
import 'package:FL_Foreman/res/colors.dart';
import 'package:FL_Foreman/res/svgs.dart';
import 'package:FL_Foreman/widget/list_content.dart';
import 'package:FL_Foreman/widget/nurse_item.dart';
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
  }

  getNurseList(int index) async {
    final data = await NurseApi.getNurseList();
    await Future.delayed(Duration(seconds: 1));
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

  Widget buildItems() {
    if (loading) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            NurseItemShimmer(),
            NurseItemShimmer(),
            NurseItemShimmer(),
            NurseItemShimmer(),
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
          onRefresh: () => getNurseList(levelIndex),
          controller: refreshController,
          child: ListContent(
            itemBuilder: (context, index) {
              return NurseItem(
                info: list[index],
                showLocation: showLocation,
              );
            },
            itemCount: list.length,
            emptyText: "暂时没有内容～",
          ),
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
                  refreshController.requestRefresh();
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
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Svgs.search,
              SizedBox(height: 2),
              Text(
                '查找',
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ],
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
