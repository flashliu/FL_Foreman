import 'package:FL_Foreman/providers/user_provider.dart';
import 'package:FL_Foreman/widget/cell.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotificationSetting extends StatelessWidget {
  const NotificationSetting({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          child: Icon(Icons.chevron_left),
          onTap: () => Navigator.of(context).pop(),
        ),
        title: Text('消息通知'),
        titleSpacing: 0,
      ),
      body: Consumer<UserProvider>(
        builder: (context, user, child) {
          return Column(
            children: [
              SizedBox(height: 16),
              Cell(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                label: '全部消息',
                action: Transform.scale(
                  scale: 0.8,
                  child: CupertinoSwitch(
                    value: user.allNotification,
                    onChanged: (value) {
                      user.setAllNotification(value);
                    },
                  ),
                ),
              ),
              Cell(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                label: '系统消息',
                action: Transform.scale(
                  scale: 0.8,
                  child: CupertinoSwitch(
                    value: user.systemNotification,
                    onChanged: (value) {
                      user.setSystemNotification(value);
                    },
                  ),
                ),
              ),
              Cell(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                label: '优惠促销',
                action: Transform.scale(
                  scale: 0.8,
                  child: CupertinoSwitch(
                    value: user.preferentialNotification,
                    onChanged: (value) {
                      user.setPreferentialNotification(value);
                    },
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
