import 'dart:convert';
import 'dart:io';

import 'package:FL_Foreman/apis/app_api.dart';
import 'package:FL_Foreman/apis/user_api.dart';
import 'package:FL_Foreman/common/dialog_util.dart';
import 'package:FL_Foreman/common/global.dart';
import 'package:FL_Foreman/providers/app_provider.dart';
import 'package:FL_Foreman/providers/user_provider.dart';
import 'package:FL_Foreman/res/colors.dart';
import 'package:FL_Foreman/res/svgs.dart';
import 'package:FL_Foreman/views/home/need_list.dart';
import 'package:FL_Foreman/views/home/nurse_list.dart';
import 'package:FL_Foreman/views/home/profit.dart';
import 'package:FL_Foreman/views/message_list/message_list.dart';
import 'package:FL_Foreman/views/setting/setting.dart';
import 'package:FL_Foreman/widget/modal_with_close_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_upgrade/flutter_app_upgrade.dart';
import 'package:provider/provider.dart';
import 'package:rammus/rammus.dart';

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
    AppUpgrade.appUpgrade(
      context,
      _checkAppInfo(),
      iosAppId: '1524264487',
    );
    tabController = TabController(length: 3, vsync: this);
    initAliPush();
    Provider.of<UserProvider>(context, listen: false).getMessageList();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  Future<AppUpgradeInfo> _checkAppInfo() async {
    final versionInfo = await AppApi.getVersion();
    Provider.of<AppProvider>(context, listen: false).setVersion(versionInfo);
    final current = await FlutterUpgrade.appInfo;
    if (versionInfo.vesionStable != current.versionName) return null;
    return AppUpgradeInfo(
      title: '新版本V' + versionInfo.vesionStable,
      contents: [
        '1、支持立体声蓝牙耳机，同时改善配对性能',
        '2、提供屏幕虚拟键盘',
        '3、更简洁更流畅，使用起来更快',
        '4、修复一些软件在使用时自动退出bug',
        '5、新增加了分类查看功能',
      ],
      apkDownloadUrl: versionInfo.versionStableUrl,
    );
  }

  void initAliPush() {
    if (Platform.isIOS) {
      configureNotificationPresentationOption();
    }
    addAlias(Global.userId).then((result) {
      print("设置推送别名成功：");
    }, onError: (error) {
      print('设置推送别名失败:' + error.toString());
    });

    onNotification.listen((event) {
      setupNotificationManager(
        [
          NotificationChannel(
            "123",
            event.title,
            event.summary,
            importance: AndroidNotificationImportance.MAX,
          )
        ],
      );
    });
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
    );
  }
}

class UserDrawer extends StatelessWidget {
  const UserDrawer({
    Key key,
  }) : super(key: key);

  showQrcode(BuildContext context) async {
    Navigator.of(context).pop();
    final data = await UserApi.getQrcode();
    DialogUtils.showElasticDialog(
      barrierDismissible: true,
      context: context,
      builder: (_) => ModalWithCloseDialog(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.memory(
              Base64Decoder().convert(data),
              fit: BoxFit.cover,
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context);
    if (user.info == null) return Container();
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
                user.info.loginUser.username,
                style: TextStyle(
                  fontSize: 16,
                  color: ColorCenter.textBlack,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              buildActionCell(
                icon: Svgs.qr,
                text: '扫一扫',
                onTap: () => Global.scanQrcode(context),
              ),
              buildActionCell(
                icon: Svgs.scanner,
                text: '我的二维码',
                onTap: () => showQrcode(context),
              ),
              buildActionCell(
                icon: Svgs.setting,
                text: '设置',
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => Setting(),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      width: 190,
    );
  }

  Container buildActionCell({Widget icon, String text, Function onTap}) {
    return Container(
      width: 155,
      height: 48,
      margin: EdgeInsets.only(bottom: 16),
      child: Material(
        borderRadius: BorderRadius.circular(24),
        color: Colors.white,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
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
          ),
        ),
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
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => MessageList()));
                },
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
