import 'package:FL_Foreman/res/colors.dart';
import 'package:flutter/material.dart';

final kBoxDecorationStyle = BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(50.0),
  boxShadow: [
    BoxShadow(
      color: Colors.black12,
      blurRadius: 6.0,
      offset: Offset(0, 2),
    ),
  ],
);

final kBoxDecorationStyle2 = BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(8.0),
);

final kBoxDecorationStyle3 = BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(50.0),
);

final decorationToast = BoxDecoration(
  color: ColorCenter.themeColor,
  borderRadius: BorderRadius.all(Radius.circular(8)),
  boxShadow: [
    BoxShadow(
      color: Colors.black54,
      blurRadius: 200.0,
      offset: Offset(0, 5),
    ),
  ],
);

final kBoxDecorationStyle4 = BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(8.0),
);

final kBoxDecorationStyle5 = BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
  boxShadow: [
    BoxShadow(
      color: Colors.black12,
      blurRadius: 10.0,
      offset: Offset(0, 2),
    ),
  ],
);

final kBoxDecorationStyleBottom = BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(8), bottomRight: Radius.circular(8)),
);

final kBtnDecorationStyle = BoxDecoration(
  color: ColorCenter.themeColor,
  borderRadius: BorderRadius.circular(50.0),
);
final kBtnDecorationStyleActive = BoxDecoration(
  gradient: LinearGradient(
      colors: [Color(0xFF38B6EB), ColorCenter.themeColor], begin: Alignment.centerLeft, end: Alignment.centerRight),
  borderRadius: BorderRadius.circular(50.0),
  boxShadow: [
    BoxShadow(
      color: Colors.black12,
      blurRadius: 6.0,
      offset: Offset(0, 2),
    ),
  ],
);

final kBtnDecorationStyleNormal = BoxDecoration(
  gradient: LinearGradient(
      colors: [ColorCenter.themeColor, ColorCenter.themeColor],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight),
  borderRadius: BorderRadius.circular(50.0),
  boxShadow: [
    BoxShadow(
      color: Colors.black12,
      blurRadius: 6.0,
      offset: Offset(0, 2),
    ),
  ],
);
