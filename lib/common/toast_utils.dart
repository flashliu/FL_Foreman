import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastUtils {
  static void showShort(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      textColor: Colors.white,
      fontSize: 12,
      backgroundColor: Color.fromRGBO(0, 0, 0, 0.5),
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
    );
  }

  static void showLong(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        textColor: Colors.white,
        fontSize: 12,
        backgroundColor: Color.fromRGBO(0, 0, 0, 0.5),
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER);
  }
}
