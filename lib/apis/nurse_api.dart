import 'package:FL_Foreman/common/global.dart';

class NurseApi {
  static Future<List> getNurseList() async {
    final res = await Global.http.get('/v2-foreman/list-nurse', queryParameters: {
      "page": 1,
      "pageSize": 10,
      "parentId": Global.userId,
    });

    return res.data['data']['content'];
  }

  static Future<Map> addNurse(String nurseId) async {
    final res = await Global.http.post('/v2-foreman/add-nurse/$nurseId', queryParameters: {
      "parentId": Global.userId,
    });

    return res.data['data'];
  }
}
