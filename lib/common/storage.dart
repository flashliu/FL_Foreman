import 'package:shared_preferences/shared_preferences.dart';

abstract class IStorage {
  Future<dynamic> get(String key);

  Future<bool> set(String key, dynamic value);

  Future<bool> clear();
}

class Keys {
  static const String KEY_TOKEN = "KEY_TOKEN";
}

class Storage extends IStorage {
  // 单例公开访问点
  factory Storage() => _sharedInstance();

  // 静态私有成员，没有初始化
  static Storage _instance;

  // 静态、同步、私有访问点
  static Storage _sharedInstance() {
    if (_instance == null) {
      _instance = Storage._();
    }
    return _instance;
  }

  SharedPreferences prefs;

  Storage._() {
    // 具体初始化代码
    SharedPreferences.getInstance().then((SharedPreferences sp) {
      prefs = sp;
    });
  }

  @override
  Future<dynamic> get(String key) async {
    if (prefs == null) {
      prefs = await SharedPreferences.getInstance();
    }
    return Future.value(prefs.get(key));
  }

  @override
  Future<bool> set(String key, dynamic value) async {
    if (prefs == null) {
      prefs = await SharedPreferences.getInstance();
    }
    if (value is String) {
      return prefs.setString(key, value);
    } else if (value is double) {
      return prefs.setDouble(key, value);
    } else if (value is int) {
      return prefs.setInt(key, value);
    } else if (value is bool) {
      return prefs.setBool(key, value);
    } else if (value is List<String>) {
      return prefs.setStringList(key, value);
    }
    return new Future.value(false);
  }

  @override
  Future<bool> clear() async {
    if (prefs == null) {
      prefs = await SharedPreferences.getInstance();
    }
    return prefs.clear();
  }
}
