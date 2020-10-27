import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:FL_Foreman/common/toast_utils.dart';
import 'package:FL_Foreman/models/user_model.dart';
import 'package:FL_Foreman/providers/user_provider.dart';
import 'package:FL_Foreman/widget/qr_page.dart';
import 'package:dio/dio.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class Global {
  static Dio http = Dio(
    BaseOptions(
      baseUrl: "http://www.yihut.cn/uni-api",
      // baseUrl: "http://192.168.0.46:8027",
      connectTimeout: 10000,
      receiveTimeout: 10000,
      responseType: ResponseType.json,
    ),
  );

  static final eventBus = EventBus();

  static final key = GlobalKey();

  static UserProvider get userProvider => Provider.of<UserProvider>(key.currentContext, listen: false);
  static LoginUser get user => userProvider.info.loginUser;
  static String get userId => user.id;
  static List<String> get permissions => user.permissions;

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

  static saveQrcode(context, {@required String qrcode}) async {
    final pop = await showCupertinoModalPopup<String>(
      context: context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          actions: <Widget>[
            CupertinoActionSheetAction(
              child: Text('保存到本地'),
              onPressed: () => Navigator.of(context).pop('save'),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            onPressed: () => Navigator.of(context).pop('cancel'),
            child: Text("取消"),
          ),
        );
      },
    );
    if (pop == 'save') {
      try {
        await [Permission.photos, Permission.storage].request();
        Uint8List bytes = base64Decode(qrcode);
        await ImageGallerySaver.saveImage(bytes, quality: 100, name: 'qrcode');
        ToastUtils.showShort('保存成功');
      } catch (e) {
        ToastUtils.showShort('保存失败');
      }
    }
  }
}
