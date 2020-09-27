import 'package:FL_Foreman/common/global.dart';
import 'package:FL_Foreman/models/foreman_model.dart';

class ForemanApi {
  static Future<List<Foreman>> getForemanList({
    int pageNum = 1,
    int pageSize = 10,
    keyWord = '',
  }) async {
    final res = await Global.http.post('/foreman/secondForeman', data: {
      "parentId": Global.userId,
      "pageNum": pageNum,
      "pageSize": pageSize,
      "keyWord": keyWord,
    });
    return List<Foreman>.from(res.data['data'].map((e) => Foreman.fromJson(e)));
  }

  static Future<Map> addForeman(String foremanId) async {
    final res = await Global.http.get('/foreman/addForeman', queryParameters: {
      "parentId": Global.userId,
      "foremanId": foremanId,
    });
    return res.data;
  }
}
