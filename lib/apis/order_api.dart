import 'package:FL_Foreman/common/global.dart';

class OrderApi {
  static Future getNeedList(String site) async {
    final res = await Global.http.get('/app-v2-needs/selectByServerSite', queryParameters: {
      "page": 1,
      "pageSize": 10,
      "serverSite": site,
    });

    return res.data;
  }
}
