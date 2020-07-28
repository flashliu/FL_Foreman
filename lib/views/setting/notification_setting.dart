import 'package:FL_Foreman/widget/cell.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Cell(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              label: '全部消息',
              action: Transform.scale(scale: 0.8, child: CupertinoSwitch(value: true, onChanged: (value) {})),
            ),
            Cell(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              label: '系统消息',
              action: Transform.scale(scale: 0.8, child: CupertinoSwitch(value: true, onChanged: (value) {})),
            ),
            Cell(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              label: '优惠促',
              action: Transform.scale(scale: 0.8, child: CupertinoSwitch(value: true, onChanged: (value) {})),
            )
          ],
        ),
      ),
    );
  }
}
