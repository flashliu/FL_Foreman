import 'package:dio/dio.dart';

class Global {
  static Dio http = Dio(BaseOptions(
    baseUrl: "https://www.yihut.cn/uni-api",
    connectTimeout: 30000,
    receiveTimeout: 30000,
  ));
}
