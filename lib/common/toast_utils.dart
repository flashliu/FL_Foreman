import 'package:FL_Foreman/res/colors.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastUtils {
  static void showShort(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        textColor: Colors.white,
        fontSize: 12,
        backgroundColor: ColorCenter.themeColor,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP);
  }

  static void showLong(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        textColor: Colors.white,
        fontSize: 12,
        backgroundColor: ColorCenter.themeColor,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP);
  }
}
