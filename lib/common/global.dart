import 'dart:async';

import 'package:FL_Foreman/models/user_model.dart';
import 'package:FL_Foreman/providers/user_provider.dart';
import 'package:FL_Foreman/widget/qr_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Global {
  static Dio http = Dio(
    BaseOptions(
      baseUrl: "http://192.168.0.80:8027",
      connectTimeout: 30000,
      receiveTimeout: 30000,
      responseType: ResponseType.json,
    ),
  )..interceptors.add(
      InterceptorsWrapper(
        onRequest: (options) {
          if (kDebugMode) {
            print('uri----------------------------');
            print(options.uri);
            print('queryParameters----------------------------');
            print(options.queryParameters);
            print('data----------------------------');
            print(options.data);
          }
        },
        onResponse: (Response res) {
          if (kDebugMode) {
            print('response----------------------------');
            print(res.toString());
          }
        },
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
