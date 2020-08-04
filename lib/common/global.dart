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
  static get userId => Provider.of<UserProvider>(key.currentContext, listen: false).info.loginUser.id;

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

class CountDown {
  String day;
  String hour;
  String min;
  String sec;
  CountDown({this.day, this.hour, this.min, this.sec});

  static CountDown fromTime(DateTime time) {
    final diff = time.difference(DateTime.now());
    final day = ((diff.inSeconds ~/ 3600) ~/ 24).toString();
    final hour = ((diff.inSeconds ~/ 3600) % 24).toString();
    final min = (diff.inSeconds % 3600 ~/ 60).toString();
    final sec = (diff.inSeconds % 60).toString();
    return CountDown(
      day: int.parse(day) > 9 ? day : '0$day',
      hour: int.parse(hour) > 9 ? hour : '0$hour',
      min: int.parse(min) > 9 ? min : '0$min',
      sec: int.parse(sec) > 9 ? sec : '0$sec',
    );
  }
}
