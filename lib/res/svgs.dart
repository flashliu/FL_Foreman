import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'colors.dart';

///
///desc:在包外部使用需要加入
class Svgs {
  static final Widget appLogo = SvgPicture.asset('assets/svgs/logo.svg', width: 50, height: 50, semanticsLabel: 'logo');

  static final Widget icEmpty =
      SvgPicture.asset('assets/svgs/ic_empty.svg', width: 50, height: 50, color: ColorCenter.green, semanticsLabel: '');

  static final Widget ali = SvgPicture.asset('assets/svgs/icon_ali.svg', width: 50, height: 50, semanticsLabel: '');

  static final Widget wx = SvgPicture.asset('assets/svgs/icon_wx.svg', width: 50, height: 50, semanticsLabel: '');

  static final Widget home1 = SvgPicture.asset(
    'assets/svgs/icon_home.svg',
    width: 24,
    height: 24,
    semanticsLabel: '',
    color: Colors.black,
  );
  static final Widget home2 = SvgPicture.asset(
    'assets/svgs/icon_home.svg',
    width: 24,
    height: 24,
    semanticsLabel: '',
    color: ColorCenter.themeColor,
  );
  static final Widget mine1 = SvgPicture.asset(
    'assets/svgs/icon_mine.svg',
    width: 24,
    height: 24,
    semanticsLabel: '',
    color: Colors.black,
  );

  static final Widget mine2 = SvgPicture.asset(
    'assets/svgs/icon_mine.svg',
    width: 24,
    height: 24,
    semanticsLabel: '',
    color: ColorCenter.themeColor,
  );
  static final Widget qr = SvgPicture.asset(
    'assets/svgs/icon_qr.svg',
    width: 20,
    height: 20,
    semanticsLabel: '',
  );
  static final Widget scanner = SvgPicture.asset(
    'assets/svgs/icon_scaner.svg',
    width: 20,
    height: 20,
    semanticsLabel: '',
  );
  static final Widget certification = SvgPicture.asset(
    'assets/svgs/icon_certification.svg',
    semanticsLabel: '',
  );
  static final Widget coupon = SvgPicture.asset(
    'assets/svgs/icon_coupons.svg',
    semanticsLabel: '',
    width: 20,
    height: 20,
    color: Colors.grey,
  );
  static final Widget setting = SvgPicture.asset(
    'assets/svgs/icon_setting.svg',
    semanticsLabel: '',
    width: 20,
    height: 20,
    color: Colors.grey,
  );
  static final Widget nurse = SvgPicture.asset(
    'assets/svgs/icon_nurse.svg',
    semanticsLabel: '',
    width: 20,
    height: 20,
    color: Colors.grey,
  );

  static final Widget wallet = SvgPicture.asset(
    'assets/svgs/icon_wallet_1.svg',
    semanticsLabel: '',
    width: 20,
    height: 20,
    color: Colors.grey,
  );

  static final Widget withdrawal = SvgPicture.asset(
    'assets/svgs/icon_withdrawal.svg',
    semanticsLabel: '',
    width: 20,
    height: 20,
    color: Colors.grey,
  );

  static final Widget nursePerson = SvgPicture.asset(
    'assets/svgs/icon_nurse_person.svg',
    semanticsLabel: '',
    width: 20,
    height: 20,
    color: Colors.grey,
  );

  static final Widget iphone = SvgPicture.asset(
    'assets/svgs/icon_iphone.svg',
    semanticsLabel: '',
    width: 50,
    height: 50,
    color: Colors.black,
  );

  static final Widget user = SvgPicture.asset(
    'assets/svgs/icon_user.svg',
    semanticsLabel: '',
    width: 50,
    height: 50,
    color: Colors.black,
  );

  static final Widget message = SvgPicture.asset(
    'assets/svgs/icon_message.svg',
    semanticsLabel: '',
    width: 50,
    height: 50,
    color: Colors.black,
  );

  static final Widget time = SvgPicture.asset(
    'assets/svgs/icon_tiem.svg',
    semanticsLabel: '',
    width: 16,
    height: 16,
    color: Colors.black,
  );

  static final Widget time2 = SvgPicture.asset(
    'assets/svgs/icon_tiem.svg',
    semanticsLabel: '',
    width: 20,
    height: 20,
    color: Colors.grey,
  );

  static final Widget location = SvgPicture.asset(
    'assets/svgs/icon_location.svg',
    semanticsLabel: '',
    width: 16,
    height: 16,
    color: Colors.white,
  );

  static final Widget emptyHolder = SvgPicture.asset(
    'assets/svgs/icon_empty.svg',
    semanticsLabel: '',
    width: 100,
    height: 100,
    color: ColorCenter.themeColor,
  );

  static final Widget wx2 = SvgPicture.asset(
    'assets/svgs/icon_wx1.svg',
    semanticsLabel: '',
    width: 20,
    height: 20,
    color: Colors.grey,
  );
  static final Widget ali2 = SvgPicture.asset(
    'assets/svgs/icon_ali1.svg',
    semanticsLabel: '',
    width: 20,
    height: 20,
    color: Colors.grey,
  );

  static final Widget bill = SvgPicture.asset(
    'assets/svgs/icon_bill.svg',
    semanticsLabel: '',
    width: 20,
    height: 20,
    color: ColorCenter.orange,
  );

  static final Widget back = SvgPicture.asset(
    'assets/svgs/icon_back.svg',
    semanticsLabel: '',
    width: 24,
    height: 24,
  );

  static final Widget close = SvgPicture.asset(
    'assets/svgs/icon_close.svg',
    semanticsLabel: '',
    width: 40,
    height: 40,
  );

  static final Widget light = SvgPicture.asset(
    'assets/svgs/icon_light.svg',
    semanticsLabel: '',
    width: 44,
    height: 44,
  );

  static final Widget closeLight = SvgPicture.asset(
    'assets/svgs/icon_close_light.svg',
    semanticsLabel: '',
    width: 44,
    height: 44,
  );

  static final Widget photo = SvgPicture.asset(
    'assets/svgs/icon_photo.svg',
    semanticsLabel: '',
    width: 44,
    height: 44,
  );

  static final Widget success = SvgPicture.asset(
    'assets/svgs/icon_success.svg',
    semanticsLabel: '',
    width: 16,
    height: 16,
  );

  static final Widget failed = SvgPicture.asset(
    'assets/svgs/icon_failed.svg',
    semanticsLabel: '',
    width: 16,
    height: 16,
  );

  static final Widget underView = SvgPicture.asset(
    'assets/svgs/icon_under_view.svg',
    semanticsLabel: '',
    width: 16,
    height: 16,
  );

  static final Widget darkClose = SvgPicture.asset(
    'assets/svgs/icon_dark_close.svg',
    semanticsLabel: '',
    width: 16,
    height: 16,
  );

  static final Widget eye = SvgPicture.asset(
    'assets/svgs/icon_eye.svg',
    semanticsLabel: '',
    width: 16,
    height: 16,
  );

  static final Widget sort = SvgPicture.asset(
    'assets/svgs/icon_sort.svg',
    semanticsLabel: '',
    width: 16,
    height: 16,
  );

  static final Widget order = SvgPicture.asset(
    'assets/svgs/icon_order.svg',
    semanticsLabel: '',
    width: 24,
    height: 24,
  );

  static final Widget show = SvgPicture.asset(
    'assets/svgs/icon_show.svg',
    semanticsLabel: '',
    width: 18,
    height: 18,
  );

  static final Widget menu = SvgPicture.asset(
    'assets/svgs/icon_menu.svg',
    semanticsLabel: '',
    width: 16,
    height: 16,
  );

  static final Widget start = SvgPicture.asset(
    'assets/svgs/icon_start.svg',
    semanticsLabel: '',
    width: 12,
    height: 12,
  );
}
