import 'dart:async';

import 'package:FL_Foreman/common/toast_utils.dart';
import 'package:flutter/material.dart';
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

  static Future<WeChatPaymentResponse> payment({
    @required String appId,
    @required String partnerId,
    @required String prepayId,
    @required String packageValue,
    @required String nonceStr,
    @required int timeStamp,
    @required String sign,
  }) async {
    Completer<WeChatPaymentResponse> completer = Completer();
    StreamSubscription<BaseWeChatResponse> listener;
    if (listener == null) {
      listener = weChatResponseEventHandler.listen((response) async {
        if (response is WeChatPaymentResponse) {
          listener.cancel();
          completer.complete(response);
        }
      });
    }

    try {
      payWithWeChat(
        appId: appId,
        partnerId: partnerId,
        prepayId: prepayId,
        packageValue: packageValue,
        nonceStr: nonceStr,
        timeStamp: timeStamp,
        sign: sign,
      );
    } catch (e) {
      ToastUtils.showLong("支付失败！");
    }

    return completer.future;
  }
}
