import 'package:FL_Foreman/common/global.dart';
import 'package:FL_Foreman/models/nurse_model.dart';

class NurseApi {
  static Future<List<Nurse>> getNurseList({String nurseLevel, int page = 1, int pageSize = 10}) async {
    final res = await Global.http.get('/appSecondNurse/queryAllSecondNurse', queryParameters: {
      "nurseLevel": nurseLevel,
      "pageNumber": page,
      "pageSize": pageSize,
      "parentId": Global.userId,
    });
    if (res.data['code'] != 200) return [];

    return List<Nurse>.from(res.data['data'].map((json) => Nurse.fromJson(json)));
  }

  static Future<List<Nurse>> searchNurseList(String keyworld) async {
    final res = await Global.http.get('/appSecondNurse/selectNurseByLike', queryParameters: {
      "context": keyworld,
      "pageNumber": 1,
      "pageSize": 1000,
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

  static Future delNurse(String nurseId) async {
    final res = await Global.http.post('/v2-foreman/delete-nurse/' + nurseId, queryParameters: {
      "parentId": Global.userId,
    });

    return res.data;
  }
}
