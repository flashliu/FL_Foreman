import 'package:FL_Foreman/common/global.dart';
import 'package:FL_Foreman/models/app_version_model.dart';
import 'package:dio/dio.dart';

class AppApi {
  static Future<AppVersion> getVersion() async {
    final res = await Global.http.get('http://api.bq04.com/apps/latest/5f2b7c26b2eb465d06e14a77', queryParameters: {
      "api_token": "6f1012265023072d0d75f1681c80582f",
    });
    return AppVersion.fromJson(res.data);
  }

  static Future<String> upload(String path) async {
    final formData = FormData();
    formData.files.add(MapEntry("file", await MultipartFile.fromFile(path)));
    final res = await Global.http.post('/file-upload/upload', data: formData);
    return res.data['data'];
  }
}
