import 'package:FL_Foreman/common/toast_utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class Global {
  static Dio http = Dio(
    BaseOptions(
      baseUrl: "http://192.168.0.94:8027",
      connectTimeout: 30000,
      receiveTimeout: 30000,
      responseType: ResponseType.json,
    ),
  )..interceptors.add(
      InterceptorsWrapper(
        onResponse: (Response res) {
          if (kDebugMode) {
            print('----------------------------');
            print(res.toString());
          }
          if (res.data['code'] != 200) {
            ToastUtils.showShort(res.data['message']);
            return res;
          }
        },
      ),
    );
}
