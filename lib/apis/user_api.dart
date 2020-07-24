import 'package:FL_Foreman/common/global.dart';
import 'package:FL_Foreman/models/user.model.dart';
import 'package:flutter/material.dart';

class UserApi {
  static Future<User> smsLogin({
    @required String username,
    @required String code,
    @required String key,
    @required String md5,
  }) async {
    final res = await Global.http.post('/appUser/sms-login', data: {
      "username": username,
      "code": code,
      "key": key,
      "md5": md5,
      "type": 3,
    });
    if (res.data['code'] == 200) {
      User user = User.fromJson(res.data['data']);
      return user;
    }
  }

  static Future<String> getCode({@required String phone}) async {
    final res = await Global.http.post('/sms/sendLoginMsg', queryParameters: {
      "mobile": phone,
    });

    return res.data['data']['key'];
  }
}
