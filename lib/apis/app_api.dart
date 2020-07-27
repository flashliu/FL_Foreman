import 'package:FL_Foreman/common/global.dart';
import 'package:FL_Foreman/models/app_version_model.dart';

class AppApi {
  static Future<AppVersion> getVersion() async {
    final res = await Global.http.get('/app-version/getAppVersion', queryParameters: {"appType": 3});
    return AppVersion.fromJson(res.data['data']);
  }
}
