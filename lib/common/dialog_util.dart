import 'dart:convert';

import 'package:FL_Foreman/res/colors.dart';
import 'package:FL_Foreman/res/text_styles.dart';
import 'package:FL_Foreman/widget/modal_with_close_dialog.dart';
import 'package:FL_Foreman/widget/pannel.dart';
import 'package:FL_Foreman/widget/password_input.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DialogUtils {
  //弹性dialog
  static Future<T> showElasticDialog<T>({
    @required BuildContext context,
    bool barrierDismissible = true,
    @required WidgetBuilder builder,
  }) {
    final ThemeData theme = Theme.of(context, shadowThemeOnly: true);
    return showGeneralDialog(
      context: context,
      pageBuilder: (BuildContext buildContext, Animation<double> animation, Animation<double> secondaryAnimation) {
        final Widget pageChild = Builder(builder: builder);
        return SafeArea(
          child: Builder(builder: (BuildContext context) {
            return theme != null ? Theme(data: theme, child: pageChild) : pageChild;
          }),
        );
      },
      barrierDismissible: barrierDismissible,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 550),
      transitionBuilder: _buildDialogTransitions,
    );
  }

  static Widget _buildDialogTransitions(
      BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    return FadeTransition(
      opacity: CurvedAnimation(
        parent: animation,
        curve: Curves.easeOut,
      ),
      child: SlideTransition(
        position: Tween<Offset>(begin: const Offset(0.0, 0.3), end: Offset.zero).animate(CurvedAnimation(
          parent: animation,
          curve: animation.status != AnimationStatus.forward ? Curves.easeOutBack : ElasticOutCurve(0.85),
        )),
        child: child,
      ),
    );
  }

  static Future showLoading({@required BuildContext context, @required String msg}) {
    return showGeneralDialog(
      context: context,
      pageBuilder: (BuildContext buildContext, Animation<double> animation, Animation<double> secondaryAnimation) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(child: CircularProgressIndicator()),
            SizedBox(height: 10),
            Text(
              msg,
              style: TextStyle(
                fontSize: 14.0,
                color: ColorCenter.themeColor,
                decoration: TextDecoration.none,
              ),
            ),
          ],
        );
      },
    );
  }

  static hideLoading(BuildContext context) {
    Navigator.of(context).pop();
  }

  static Future<String> showPaymentPassword({
    @required BuildContext context,
  }) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) {
        return Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.only(top: 140),
            child: SizedBox(
              height: 220,
              child: Pannel(
                margin: EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: InkWell(
                        onTap: () => Navigator.of(context).pop(),
                        child: Icon(Icons.close),
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      '请输入支付密码',
                      style: TextStyles.black_Bold_16,
                    ),
                    SizedBox(height: 32),
                    PasswordInput(
                      onFinsh: (value) {
                        Navigator.of(context).pop(value);
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  static Future showQrPay({
    @required BuildContext context,
    @required String qr,
  }) async {
    return DialogUtils.showElasticDialog(
      barrierDismissible: true,
      context: context,
      builder: (_) => ModalWithCloseDialog(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.memory(
              Base64Decoder().convert(qr),
              fit: BoxFit.cover,
            ),
            Text('微信扫码付款', style: TextStyles.grey_12),
            SizedBox(height: 10)
          ],
        ),
      ),
    );
  }
}
