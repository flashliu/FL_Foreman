import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MoneyTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    String newvalueText = newValue.text;
    if (newvalueText.contains(".")) {
      if (newvalueText.lastIndexOf(".") != newvalueText.indexOf(".")) {
        //输入了2个小数点
        newvalueText = oldValue.text;
      } else if (newvalueText.length - 1 - newvalueText.indexOf(".") > 2) {
        //输入了1个小数点 小数点后两位
        newvalueText = newvalueText.substring(0, newvalueText.indexOf(".") + 3);
      }
    }

    return TextEditingValue(
      text: newvalueText,
      selection: new TextSelection.collapsed(offset: newvalueText.length),
    );
  }
}
