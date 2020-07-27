import 'package:FL_Foreman/common/global.dart';
import 'package:FL_Foreman/models/nurse_model.dart';

class NurseApi {
  static Future<List<Nurse>> getNurseList() async {
    final res = await Global.http.get('/appSecondNurse/queryAllSecondNurse', queryParameters: {
      "pageNumber": 1,
      "pageSize": 10,
      "parentId": Global.userId,
    });
    if (res.data['code'] != 200) return [];

    return List<Nurse>.from(res.data['data'].map((json) => Nurse.fromJson(json)));
  }

  static Future<Map> addNurse(String nurseId) async {
    final res = await Global.http.post('/appSecondNurse/relationNurse', queryParameters: {
      "nurseId": nurseId,
      "parentId": Global.userId,
    });

    return res.data;
  }
}
