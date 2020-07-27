import 'package:FL_Foreman/models/app_version_model.dart';
import 'package:flutter/material.dart';

class AppProvider extends ChangeNotifier {
  AppVersion version;

  setVersion(AppVersion value) {
    version = value;
    notifyListeners();
  }
}
