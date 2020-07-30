import 'dart:async';

import 'package:FL_Foreman/models/user_model.dart';
import 'package:FL_Foreman/providers/user_provider.dart';
import 'package:FL_Foreman/widget/qr_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Global {
  static Dio http = Dio(
    BaseOptions(
      // baseUrl: "http://www.yihut.cn/uni-api",
      baseUrl: "http://192.168.0.94:8027",
      connectTimeout: 30000,
      receiveTimeout: 30000,
      responseType: ResponseType.json,
    ),
  );

  static final key = GlobalKey();
  static final userId = Provider.of<UserProvider>(key.currentContext, listen: false).info.loginUser.id;

  static Future<LoginUser> scanQrcode(BuildContext context) {
    final completer = Completer<LoginUser>();
    showCupertinoModalPopup(
      context: context,
      builder: (_) {
        return QrPage(success: (LoginUser res) {
          completer.complete(res);
        });
      },
    );
    return completer.future;
  }
}
