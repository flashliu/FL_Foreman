import 'dart:convert';

import 'package:FL_Foreman/common/storage.dart';
import 'package:FL_Foreman/models/user_model.dart';
import 'package:FL_Foreman/providers/user_provider.dart';
import 'package:FL_Foreman/views/home/home.dart';
import 'package:FL_Foreman/views/login/login.dart';
import 'package:FL_Foreman/widget/fade_page_route.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class Guide extends StatefulWidget {
  Guide({Key key}) : super(key: key);

  @override
  _GuideState createState() => _GuideState();
}

class _GuideState extends State<Guide> {
  int countdown = 3;
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }

  @override
  void initState() {
    super.initState();
    _checkPermission();
  }

  //检查权限
  void _checkPermission() async {
    bool allPermission = false;
    Map<Permission, PermissionStatus> permissionsResult = await [
      Permission.notification,
      Permission.camera,
      Permission.contacts,
      Permission.phone,
      Permission.storage,
      Permission.photos,
      Permission.speech,
      Permission.locationAlways,
      Permission.sms,
    ].request();

    permissionsResult.values.forEach((element) {
      if (element == PermissionStatus.denied ||
          element == PermissionStatus.permanentlyDenied ||
          element == PermissionStatus.denied) {
        allPermission = false;
      } else {
        allPermission = true;
      }
    });

    if (allPermission) {
      final res = await Storage().get('userinfo');
      // await Future.delayed(Duration(seconds: 3));
      if (res != null) {
        Provider.of<UserProvider>(context, listen: false).setUser(User.fromJson(jsonDecode(res)));
        Navigator.pushReplacement(context, FadePageRoute(builder: (_) => Home()));
        return;
      }
      Navigator.pushReplacement(context, FadePageRoute(builder: (_) => Login()));
    }
  }
}
