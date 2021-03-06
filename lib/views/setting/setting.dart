import 'package:FL_Foreman/common/global.dart';
import 'package:FL_Foreman/common/toast_utils.dart';
import 'package:FL_Foreman/providers/app_provider.dart';
import 'package:FL_Foreman/views/protocol_privacy/protocol_privacy.dart';
import 'package:FL_Foreman/views/setting/about_us.dart';
import 'package:FL_Foreman/views/setting/notification_setting.dart';
import 'package:FL_Foreman/widget/cell.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Setting extends StatelessWidget {
  const Setting({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userProvider = Global.userProvider;
    final appProvider = Provider.of<AppProvider>(context);
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          child: Icon(Icons.chevron_left),
          onTap: () => Navigator.of(context).pop(),
        ),
        title: Text('设置'),
        titleSpacing: 0,
      ),
      body: Column(
        children: [
          SizedBox(height: 16),
          Cell(label: '版本号', value: appProvider.currentVersion.versionName),
          Cell(
            label: '关于我们',
            onTap: () {
              Navigator.of(context).push(CupertinoPageRoute(builder: (_) => AboutUs()));
            },
          ),
          Cell(
            label: '清除缓存',
            onTap: () {
              ToastUtils.showLong('清除成功');
            },
          ),
          Cell(
            label: '消息通知',
            onTap: () {
              Navigator.of(context).push(CupertinoPageRoute(builder: (_) => NotificationSetting()));
            },
          ),
          Cell(
            label: '用户协议',
            onTap: () {
              Navigator.of(context).push(CupertinoPageRoute(builder: (_) => ProtocolPrivacy(title: "用户协议")));
            },
          ),
          SizedBox(height: 24),
          FlatButton(
            child: Container(
              width: 252,
              height: 40,
              alignment: Alignment.center,
              child: Text('退出登录'),
            ),
            color: Colors.blue,
            textColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            onPressed: () => userProvider.logOut(context),
          )
        ],
      ),
    );
  }
}
