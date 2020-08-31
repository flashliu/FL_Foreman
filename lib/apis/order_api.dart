import 'package:FL_Foreman/common/global.dart';
import 'package:FL_Foreman/models/need_model.dart';
import 'package:FL_Foreman/models/order_model.dart';
import 'package:flutter/material.dart';

class OrderApi {
  static Future<List<Need>> getNeedList({String site, int page = 1, int pageSize = 5}) async {
    final res = await Global.http.get('/app-v2-needs/selectByServerSite', queryParameters: {
      "page": page,
      "pageSize": pageSize,
      "serverSite": site,
      "userId": "",
    });
    if (res.data['code'] == 200) {
      return List<Need>.from(res.data['data'].map((json) => Need.fromJson(json)));
    }
    return [];
  }

  static Future<List<Need>> getMyNeed({String site, int page = 1, int pageSize = 5}) async {
    final res = await Global.http.get('/ParentOrder/listBySite', queryParameters: {
      "pageNumber": page,
      "pageSize": pageSize,
      "parentId": Global.userId,
    });
    if (res.data['code'] == 200) {
      return List<Need>.from(res.data['data'].map((json) => Need.fromJson(json)));
    }
    return [];
  }

  static Future<List<Need>> getNeedSuggestList() async {
    final res = await Global.http.get('/app-v2-needs/selectByCommend', queryParameters: {
      "page": 1,
      "pageSize": 10,
      "commend": "1",
      "nurseId": Global.userId,
    });
    if (res.data['code'] == 200) {
      return List<Need>.from(res.data['data'].map((json) => Need.fromJson(json)));
    }
    return [];
  }

  static Future<List<Need>> getNeedOtherList({int page = 1, int pageSize = 5, String parentId}) async {
    final res = await Global.http.get('/app-v2-needs/selectBySpecial', queryParameters: {
      "page": page,
      "pageSize": pageSize,
      "parentId": parentId,
    });
    if (res.data['code'] == 200) {
      return List<Need>.from(res.data['data'].map((json) => Need.fromJson(json)));
    }
    return [];
  }

  static Future<List<Need>> searchNeedList(String keyworld) async {
    final res = await Global.http.get('/app-v2-needs/selectByLike', queryParameters: {
      "pageNum": 1,
      "pageSize": 1000,
      "context": keyworld,
      "userId": Global.userId,
    });
    if (res.data['code'] == 200) {
      return List<Need>.from(res.data['data'].map((json) => Need.fromJson(json)));
    }
    return [];
  }

  static Future<List<Order>> getOrderList({int status, String nurseId, int page = 1, int pageSize = 5}) async {
    final params = {
      "status": status,
      "pageSize": pageSize,
      "page": page,
      "parentId": Global.userId,
    };
    if (nurseId != null) {
      params['nurseId'] = nurseId;
      params.remove('parentId');
    }
    final res = await Global.http.get('/app-v2-order/list', queryParameters: params);
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

  static Future assignNurse({
    @required String nurseId,
    @required String orderNum,
  }) async {
    final res = await Global.http.post('/app-v2-order/assignNurse', data: {
      "foremanId": Global.userId,
      "nurseId": nurseId,
      "orderNum": orderNum,
    });
    return res.data;
  }

  static Future createOrder({
    @required String beNurseCard,
    @required String beNurseName,
    @required String beNursePhone,
    @required String startTime,
    @required String endTime,
    @required String remark,
    @required String amount,
    @required String preferPrice,
  }) async {
    final beNurse = await Global.http.post('/app-be-nursed/add', data: {
      "identId": beNurseCard,
      "phone": beNursePhone,
      "realName": beNurseName,
      "area": "",
      "address": "",
      "defaultState": 1,
      "userId": Global.userId,
    });
    final need = await Global.http.post('/app-v2-needs/publish', data: {
      "userId": Global.userId,
      "beNursedId": beNurse.data['data'],
      "demandName": '生活护理',
      "preferPrice": preferPrice,
      "price": amount,
      "serverSite": '医院',
      "serverTime": '白天（8:00 - 20:00）',
      "selfCare": '自理',
      "startTime": startTime,
      "endTime": endTime,
      "notes": remark
    });

    final res = await Global.http.get('/app-pay/createOrder', queryParameters: {
      "needId": need.data['data']['id'],
      "parentId": Global.userId,
    });
    // final res = await Global.http.post('/ParentOrder/createOrder', data: {
    //   "beNurseCard": beNurseCard,
    //   "beNurseName": beNurseName,
    //   "beNursePhone": beNursePhone,
    //   "startTime": startTime,
    //   "endTime": endTime,
    //   "remark": remark,
    //   "amount": amount,
    //   "preferPrice": preferPrice,
    //   "selfCare": "自理",
    //   "serverSite": "医院",
    //   "serverTime": "白天(8:00 - 20:00)",
    //   "userId": Global.userId
    // });
    return res.data;
  }

  static Future<String> getPayQrcode(String orderId) async {
    final res = await Global.http.get('/app-pay/codePay', queryParameters: {
      "orderId": orderId,
    });
    return res.data['data']['qrcode'];
  }
}
