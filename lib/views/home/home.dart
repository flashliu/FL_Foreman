import 'package:FL_Foreman/res/colors.dart';
import 'package:FL_Foreman/res/svgs.dart';
import 'package:FL_Foreman/views/home/need_list.dart';
import 'package:FL_Foreman/views/home/nurse_list.dart';
import 'package:FL_Foreman/views/home/profit.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  TabController tabController;
  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: UserDrawer(),
      body: Column(
        children: [
          Header(tabController: tabController),
          Expanded(
            child: TabView(tabController: tabController),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Svgs.order,
      ),
    );
  }
}

class UserDrawer extends StatelessWidget {
  const UserDrawer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFFF4F6F7),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Svgs.darkClose,
                ),
              ),
              SizedBox(height: 20),
              Image.asset(
                'assets/images/avatar.png',
                width: 72,
                height: 72,
              ),
              SizedBox(height: 12),
              Text(
                '李婉瑜',
                style: TextStyle(
                  fontSize: 16,
                  color: ColorCenter.textBlack,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              buildActionCell(icon: Svgs.qr, text: '扫一扫'),
              buildActionCell(icon: Svgs.scanner, text: '我的二维码'),
              buildActionCell(icon: Svgs.setting, text: '设置'),
            ],
          ),
        ),
      ),
      width: 190,
    );
  }

  Container buildActionCell({Widget icon, String text}) {
    return Container(
      width: 155,
      height: 48,
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(24),
        ),
      ),
      child: Row(
        children: [
          icon,
          SizedBox(
            width: 5,
          ),
          Text(text),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: Icon(
                Icons.arrow_forward_ios,
                size: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Header extends StatelessWidget {
  final TabController tabController;
  Header({
    Key key,
    @required this.tabController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorCenter.themeColor,
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 20, left: 16, right: 16, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ClipOval(
            child: Material(
              child: InkWell(
                child: SizedBox(
                  width: 28,
                  height: 28,
                  child: Padding(
                    padding: EdgeInsets.all(6),
                    child: Svgs.user,
                  ),
                ),
                onTap: () {
                  Scaffold.of(context).openDrawer();
                },
              ),
            ),
          ),
          TabBar(
            isScrollable: true,
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            labelStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal, color: Colors.white54),
            indicatorSize: TabBarIndicatorSize.label,
            tabs: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('我的收益'),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("接单"),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("护工管理"),
              )
            ],
            controller: tabController,
          ),
          ClipOval(
            child: Material(
              child: InkWell(
                child: SizedBox(
                  width: 28,
                  height: 28,
                  child: Padding(
                    padding: EdgeInsets.all(6),
                    child: Svgs.message,
                  ),
                ),
                onTap: () {},
              ),
            ),
          )
        ],
      ),
    );
  }
}

class TabView extends StatelessWidget {
  final TabController tabController;
  TabView({
    Key key,
    @required this.tabController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      children: [Profit(), NeedList(), NurseList()],
      controller: tabController,
    );
  }
}
