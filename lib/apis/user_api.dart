import 'package:FL_Foreman/common/global.dart';
import 'package:FL_Foreman/models/message_model.dart';
import 'package:FL_Foreman/models/user_model.dart';
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
    User user = User.fromJson(res.data['data']);
    return user;
  }

  static Future<User> wechatLogin({@required String wxcode}) async {
    final res = await Global.http.post('/appUser/wx-app-login', data: {
      "wxcode": wxcode,
      "type": 3,
    });
    User user = User.fromJson(res.data['data']);
    return user;
  }

  static Future<User> appleLogin({
    @required String openId,
  }) async {
    try {
      final res = await Global.http.post('/appUser/wx-applev2-login', data: {
        "openId": openId,
        "type": 3,
      });
      User user = User.fromJson(res.data['data']);
      return user;
    } catch (e) {
      return null;
    }
  }

  static Future<String> getCode({@required String phone}) async {
    try {
      final res = await Global.http.post('/sms/sendLoginMsg', queryParameters: {
        "mobile": phone,
      });

      return res.data['data']['key'];
    } catch (e) {
      return null;
    }
  }

  static Future<String> getTodayAmount() async {
    try {
      final res = await Global.http.get('/v2-foreman/selectOneByNurseIdToday', queryParameters: {
        "foremanId": Global.userId,
      });

      return res.data['data'].toString();
    } catch (e) {
      return '0';
    }
  }

  static Future<String> getWeekAmount() async {
    try {
      final res = await Global.http.get('/v2-foreman/selectThisWeekByNurseId', queryParameters: {
        "foremanId": Global.userId,
      });

      return res.data['data'].toString();
    } catch (e) {
      return '0';
    }
  }

  static Future<String> getMonthAmount() async {
    try {
      final res = await Global.http.get('/v2-foreman/selectThisMonthByNurseId', queryParameters: {
        "foremanId": Global.userId,
      });

      return res.data['data'].toString();
    } catch (e) {
      return '0';
    }
  }

  static Future<List<Message>> getMessageList() async {
    try {
      final res = await Global.http.post('/app-jpush/select', queryParameters: {
        "toUser": Global.userId,
        "pageNumber": 1,
        "pageSize": 1000,
      });

      return List.from(res.data['data'].map((json) => Message.fromJson(json)));
    } catch (e) {
      return [];
    }
  }

  static Future readMessage(String id) async {
    final res = await Global.http.post('/app-jpush/updateById', queryParameters: {
      "id": id,
    });
    return res.data;
  }

  static Future<String> getQrcode() async {
    try {
      final res = await Global.http.get('/appUser/generateQRcode', queryParameters: {
        "width": 250,
        "height": 250,
        "id": Global.userId,
      });

      return res.data['data'];
    } catch (e) {
      return '';
    }
  }

  static Future<String> getMiniQrcode(Map<String, String> data) async {
    try {
      final res = await Global.http.post('/CreateQRCode/createQRCodeV2', data: data);
      return res.data['data'];
    } catch (e) {
      return '';
    }
  }

  static Future<String> selectBalance() async {
    final res = await Global.http.get('/appUser/selectBalance', queryParameters: {
      "id": Global.userId,
    });
    double balance = res.data['data']['balance'];
    return balance.toString().replaceAll(RegExp(r"([.]*0)(?!.*\d)"), "");
  }

  static Future<String> getOpenid(String code) async {
    final res = await Global.http.post('/appUser/wx-applet-openid', data: {code: code});
    return res.data['data'];
  }

  static Future<Map> reflect({
    @required String code,
    @required String amount,
    @required String payPassword,
  }) async {
    final res = await Global.http.post('/app-pay/cash', data: {
      "amount": amount,
      "code": code,
      "userId": Global.userId,
      "payPassword": payPassword,
    });
    return res.data;
  }

  static Future<String> getWorkTimes() async {
    final res = await Global.http.get('/UserStatistics/UserStatistics', queryParameters: {
      "id": Global.userId,
    });

    return res.data['data'].toString();
  }

  static Future<String> getTotalNurse() async {
    final res = await Global.http.get('/UserStatistics/nursecount', queryParameters: {
      "id": Global.userId,
    });

    return res.data['data'].toString();
  }
}
