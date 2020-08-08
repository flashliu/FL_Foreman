import 'package:FL_Foreman/apis/nurse_api.dart';
import 'package:FL_Foreman/common/global.dart';
import 'package:FL_Foreman/common/toast_utils.dart';
import 'package:FL_Foreman/models/nurse_model.dart';
import 'package:FL_Foreman/res/colors.dart';
import 'package:FL_Foreman/res/svgs.dart';
import 'package:FL_Foreman/res/text_styles.dart';
import 'package:FL_Foreman/views/home/nurse_page.dart';
import 'package:FL_Foreman/widget/nurse_item.dart';
import 'package:FL_Foreman/widget/state_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NurseList extends StatefulWidget {
  NurseList({Key key}) : super(key: key);

  @override
  _NurseListState createState() => _NurseListState();
}

class _NurseListState extends State<NurseList> with SingleTickerProviderStateMixin {
  final List<Map> levels = [
    {"name": '全部', "value": "", "controller": NursePageController()},
    {"name": '特级', "value": "0", "controller": NursePageController()},
    {"name": '一级', "value": "1", "controller": NursePageController()},
    {"name": '二级', "value": "2", "controller": NursePageController()},
    {"name": '三级', "value": "3", "controller": NursePageController()},
  ];
  List<Widget> tabView;
  TabController tabController;
  bool showLocation = false;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: levels.length, vsync: this);
  }

  addNurse() async {
    final user = await Global.scanQrcode(context);
    final res = await NurseApi.addNurse(user.id);
    if (res['code'] == 200) {
      NursePageController currentPageController = levels[tabController.index]['controller'];
      currentPageController.refresh();
    }
    ToastUtils.showLong(res['message']);
  }

  Widget buildTabPage() {
    return Expanded(
      child: TabBarView(
        children: levels
            .map(
              (e) => NursePage(
                level: e['value'],
                showLocation: showLocation,
                nursePageController: e['controller'],
              ),
            )
            .toList(),
        controller: tabController,
      ),
    );
  }

  Widget buildTab() {
    return Row(
      children: [
        Expanded(
          child: TabBar(
            controller: tabController,
            tabs: levels.map((e) => Text(e['name'])).toList(),
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
        Row(
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  showLocation = !showLocation;
                });
              },
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Svgs.show,
              ),
            ),
          ],
          mainAxisAlignment: MainAxisAlignment.end,
        ),
      ],
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
        Column(
          children: [
            buildTab(),
            buildTabPage(),
          ],
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
