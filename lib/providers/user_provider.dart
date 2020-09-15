import 'dart:async';

import 'package:FL_Foreman/apis/user_api.dart';
import 'package:FL_Foreman/common/storage.dart';
import 'package:FL_Foreman/common/toast_utils.dart';
import 'package:FL_Foreman/common/wechat_action.dart';
import 'package:FL_Foreman/models/message_model.dart';
import 'package:FL_Foreman/models/user_model.dart';
import 'package:FL_Foreman/views/login/login.dart';
import 'package:FL_Foreman/widget/fade_page_route.dart';
import 'package:common_utils/common_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class UserProvider with ChangeNotifier {
  User info;
  List<Message> messageList = [];
  bool allNotification = true;
  bool systemNotification = true;
  bool preferentialNotification = true;
  String balance = '0';
  String todayAmount = '0';
  String weekAmount = '0';
  String monthAmount = '0';

  UserProvider(this.info);

  setAllNotification(bool value) {
    allNotification = value;
    notifyListeners();
  }

  setSystemNotification(bool value) {
    systemNotification = value;
    notifyListeners();
  }

  setPreferentialNotification(bool value) {
    preferentialNotification = value;
    notifyListeners();
  }

  readMessage(String id) async {
    final res = await UserApi.readMessage(id);
    if (res['code'] == 200) {
      final message = messageList.firstWhere((element) => element.id == id);
      message.status = 1;
      notifyListeners();
    }
  }

  getMessageList() async {
    final list = await UserApi.getMessageList();
    messageList = list;
    notifyListeners();
    return list;
  }

  void setUser(User user) {
    info = user;
    notifyListeners();
  }

  setBalance() async {
    final value = await UserApi.selectBalance();
    balance = value;
    notifyListeners();
  }

  setAmount() async {
    final res = await Future.wait([
      UserApi.getTodayAmount(),
      UserApi.getWeekAmount(),
      UserApi.getMonthAmount(),
    ]);
    todayAmount = res[0];
    weekAmount = res[1];
    monthAmount = res[2];
    notifyListeners();
  }

  void logOut(BuildContext context) async {
    setUser(null);
    await Storage().clear();
    Navigator.pushAndRemoveUntil(
      context,
      FadePageRoute(builder: (_) => Login()),
      (route) => false,
    );
  }

  Future<User> smsLogin({BuildContext context, String username, String code, String key}) async {
    String md5 = EncryptUtil.encodeMd5(code + key);
    final res = await UserApi.smsLogin(username: username, code: code, key: key, md5: md5);
    return res;
  }

  Future<User> wechatLogin() async {
    final response = await WechatAction.sendAuth();
    final res = await UserApi.wechatLogin(
      wxcode: response.code,
    );
    return res;
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
