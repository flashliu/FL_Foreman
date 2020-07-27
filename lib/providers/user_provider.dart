import 'dart:async';

import 'package:FL_Foreman/apis/user_api.dart';
import 'package:FL_Foreman/common/storage.dart';
import 'package:FL_Foreman/common/toast_utils.dart';
import 'package:FL_Foreman/models/user_model.dart';
import 'package:FL_Foreman/views/login/login.dart';
import 'package:FL_Foreman/widget/fade_page_route.dart';
import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:fluwx/fluwx.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class UserProvider with ChangeNotifier {
  User info;
  void setUser(User user) {
    info = user;
    notifyListeners();
  }

  void logOut(BuildContext context) async {
    setUser(null);
    await Storage().clear();
    Navigator.pushReplacement(context, FadePageRoute(builder: (_) => Login()));
  }

  Future<User> smsLogin({BuildContext context, String username, String code, String key}) async {
    String md5 = EncryptUtil.encodeMd5(code + key);
    final res = await UserApi.smsLogin(username: username, code: code, key: key, md5: md5);
    return res;
  }

  Future<User> wechatLogin() async {
    Completer<User> completer = Completer();
    StreamSubscription<BaseWeChatResponse> listener;
    var wxInStall = await isWeChatInstalled;
    if (!wxInStall) {
      ToastUtils.showShort("请安装微信！");
      return null;
    }
    if (listener == null) {
      listener = weChatResponseEventHandler.listen((response) async {
        if (response is WeChatAuthResponse) {
          final res = await UserApi.wechatLogin(
            wxcode: response.code,
          );
          listener.cancel();
          completer.complete(res);
        }
      });
    }

    try {
      sendWeChatAuth(scope: "snsapi_userinfo", state: "wechat_auth");
    } catch (e) {
      ToastUtils.showLong("微信授权失败！");
    }

    return completer.future;
  }

  Future<User> appleLogin() async {
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final res = await UserApi.appleLogin(openId: credential.userIdentifier);
      return res;
    } catch (e) {
      ToastUtils.showLong("苹果授权失败！");
      return null;
    }
  }

  void aliLogin() async {
    return ToastUtils.showShort("暂不支持！");
  }
}
