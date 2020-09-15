import 'dart:async';

import 'package:FL_Foreman/common/toast_utils.dart';
import 'package:fluwx/fluwx.dart';

class WechatAction {
  static Future<WeChatAuthResponse> sendAuth() async {
    Completer<WeChatAuthResponse> completer = Completer();
    StreamSubscription<BaseWeChatResponse> listener;

    if (listener == null) {
      listener = weChatResponseEventHandler.listen((response) async {
        if (response is WeChatAuthResponse) {
          listener.cancel();
          completer.complete(response);
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
}
