import 'dart:async';

import 'package:FL_Foreman/models/user_model.dart';
import 'package:FL_Foreman/providers/user_provider.dart';
import 'package:FL_Foreman/widget/qr_page.dart';
import 'package:dio/dio.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class Global {
  static Dio http = Dio(
    BaseOptions(
      // baseUrl: "http://www.yihut.cn/uni-api-beta",
      baseUrl: "http://192.168.0.45:8027",
      connectTimeout: 30000,
      receiveTimeout: 30000,
      responseType: ResponseType.json,
    ),
  );

  static final eventBus = EventBus();

  static final key = GlobalKey();
  static get userId => Provider.of<UserProvider>(key.currentContext, listen: false).info.loginUser.id;

  static Future<LoginUser> scanQrcode(BuildContext context) async {
    final completer = Completer<LoginUser>();
    await [Permission.camera, Permission.photos].request();
    final cameraIsDenied = await Permission.camera.isDenied;
    final photosIsDenied = await Permission.photos.isDenied;
    if (cameraIsDenied || photosIsDenied) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('提示'),
            content: Text('此操作需要您授权访问相机与相册权限,请前往设置打开该权限'),
            actions: <Widget>[
              FlatButton(
                child: Text('取消'),
                onPressed: () => Navigator.of(context).pop(),
              ),
              FlatButton(
                child: Text('前往设置'),
                onPressed: () => openAppSettings(),
              ),
            ],
          );
        },
      );
    } else {
      showCupertinoModalPopup(
        context: context,
        builder: (_) {
          return QrPage(success: (LoginUser res) {
            completer.complete(res);
          });
        },
      );
    }
    return completer.future;
  }
}
