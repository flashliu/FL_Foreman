import 'package:FL_User/common/global.dart';
import 'package:FL_User/models/user.model.dart';
import 'package:flutter/material.dart';

class UserApi {
  static Future<User> login({@required String username, @required String password}) async {
    final res = await Global.http.post('/appUser/login', data: {
      "username": username,
      "password": password,
      "type": 1,
    });
    User user = User.fromJson(res.data['data']['loginUser']);
    return user;
  }
}
