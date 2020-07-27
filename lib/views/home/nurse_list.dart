import 'package:FL_Foreman/apis/nurse_api.dart';
import 'package:FL_Foreman/common/global.dart';
import 'package:FL_Foreman/models/nurse_model.dart';
import 'package:FL_Foreman/res/colors.dart';
import 'package:FL_Foreman/res/svgs.dart';
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

  addNurse() async {
    final user = await Global.scanQrcode(context);
    final res = await NurseApi.addNurse(user.id);
    if (res['code'] == 200) {
      getNurseList();
    }
  }

  getNurseList() async {
    final data = await NurseApi.getNurseList();
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      list = data;
      loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getNurseList();
  }

  Widget buildItems() {
    if (loading) {
      return Column(
        children: [
          NurseItemShimmer(),
          NurseItemShimmer(),
          NurseItemShimmer(),
          NurseItemShimmer(),
        ],
      );
    }
    if (list.length == 0) {
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
        header: WaterDropHeader(
          complete: Text('刷新成功！'),
          refresh: CupertinoActivityIndicator(),
        ),
        footer: ClassicFooter(),
        child: ListView.builder(
          itemBuilder: (context, index) {
            return NurseItem(
              showLocation: showLocation,
              info: list[index],
            );
          },
          itemCount: list.length,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Container(
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
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
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
                      length: 5,
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
                        onTap: (index) {},
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        showLocation = !showLocation;
                      });
                    },
                    child: Svgs.show,
                  ),
                ],
              ),
            ),
            buildItems(),
          ],
        ),
      ),
    );
  }
}
