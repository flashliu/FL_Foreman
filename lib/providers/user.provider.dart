import 'package:FL_User/apis/user.api.dart';
import 'package:FL_User/models/user.model.dart';
import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  User user;

  login() async {
    final value = await UserApi.login(username: '15969559936', password: 'Yht123456');
    user = value;
    notifyListeners();
  }

  logout() async {
    user = null;
    notifyListeners();
  }
}
