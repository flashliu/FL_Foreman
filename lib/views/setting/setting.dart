import 'package:FL_Foreman/providers/user_provider.dart';
import 'package:FL_Foreman/widget/cell.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Setting extends StatelessWidget {
  const Setting({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          child: Icon(Icons.chevron_left),
          onTap: () => Navigator.of(context).pop(),
        ),
        title: Text('设置'),
        titleSpacing: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Cell(label: '版本号', value: 'iphone:V2.0'),
            Cell(label: '关于我们', onTap: () {}),
            Cell(label: '清除缓存', onTap: () {}),
            Cell(label: '消息通知', onTap: () {}),
            Cell(label: '用户协议', onTap: () {}),
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
      ),
    );
  }
}
