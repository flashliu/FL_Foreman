import 'dart:async';
import 'dart:convert';

import 'package:FL_Foreman/apis/user_api.dart';
import 'package:FL_Foreman/common/storage.dart';
import 'package:FL_Foreman/common/toast_utils.dart';
import 'package:FL_Foreman/models/user.model.dart';
import 'package:FL_Foreman/views/login/login.dart';
import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:fluwx/fluwx.dart';

class UserProvider with ChangeNotifier {
  User user;
  StreamSubscription<WeChatAuthResponse> listener;

  void setUser(User user) {
    user = user;
    notifyListeners();
  }

  void logOut(BuildContext context) async {
    setUser(null);
    await Storage().clear();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => Login()));
  }

  Future<User> smsLogin({BuildContext context, String username, String code, String key}) async {
    String md5 = EncryptUtil.encodeMd5(code + key);
    final res = await UserApi.smsLogin(username: username, code: code, key: key, md5: md5);
    await Storage().set('userinfo', jsonEncode(res));
    setUser(res);
    return res;
  }

  void wechatLogin() async {
    var wxInStall = await isWeChatInstalled;
    if (!wxInStall) {
      ToastUtils.showShort("请安装微信！");
      return;
    }
    listener = weChatResponseEventHandler.listen((response) {
      if (response is WeChatAuthResponse) {}
    });
    try {
      sendWeChatAuth(scope: "snsapi_userinfo", state: "wechat_auth");
    } catch (e) {
      ToastUtils.showLong("微信授权失败！");
    }
  }

  @override
  void dispose() {
    listener.cancel();
    super.dispose();
  }

  void aliLogin() {}
}
