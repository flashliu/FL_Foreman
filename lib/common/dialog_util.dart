import 'package:FL_Foreman/res/colors.dart';
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
    final dialog = showGeneralDialog(
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
    return dialog;
  }
}
