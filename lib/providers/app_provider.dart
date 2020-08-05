import 'package:FL_Foreman/models/app_version_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_upgrade/flutter_app_upgrade.dart';

class AppProvider extends ChangeNotifier {
  AppVersion version;
  AppInfo currentVersion;

  setVersion(AppVersion value) {
    version = value;
    notifyListeners();
  }

  setCurrentVersion(AppInfo value) {
    currentVersion = value;
    notifyListeners();
  }
}
