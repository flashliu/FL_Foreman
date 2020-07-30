import 'package:FL_Foreman/common/global.dart';
import 'package:FL_Foreman/models/need_model.dart';
import 'package:FL_Foreman/models/order_model.dart';
import 'package:flutter/material.dart';

class OrderApi {
  static Future<List<Need>> getNeedList(String site) async {
    final res = await Global.http.get('/app-v2-needs/selectByServerSite', queryParameters: {
      "page": 1,
      "pageSize": 10,
      "serverSite": site,
    });
    if (res.data['code'] == 200) {
      return List<Need>.from(res.data['data'].map((json) => Need.fromJson(json)));
    }
    return [];
  }

  static Future<List<Order>> getOrderList(int status) async {
    final res = await Global.http.get('/app-v2-order/list', queryParameters: {
      "status": status,
      "pageSize": 1000,
      "page": 1,
      "parentId": Global.userId,
    });
    if (res.data['code'] == 200) {
      return List<Order>.from(res.data['data'].map((json) => Order.fromJson(json)));
    }
    return [];
  }

  static Future bindingNurse({
    @required String bidMoney,
    @required String needId,
    @required String userId,
    @required int status,
    @required String nurseId,
  }) async {
    final res = await Global.http.post('/app-bidding-record/add', data: {
      "bidMoney": bidMoney,
      "needId": needId,
      "nurseId": nurseId,
      "parentId": Global.userId,
      "status": status,
      "userId": userId
    });
    return res.data;
  }
}
