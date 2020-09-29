import 'package:FL_Foreman/apis/order_api.dart';
import 'package:FL_Foreman/common/global.dart';
import 'package:FL_Foreman/common/toast_utils.dart';
import 'package:flutter/material.dart';

class OrderAction {
  static settlement({@required BuildContext context, @required String orderId}) async {
    final isConfirm = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text('提示'),
          content: Text('结算后不可撤回，是否确认结算？'),
          actions: <Widget>[
            FlatButton(
              child: Text("确认"),
              onPressed: () => Navigator.of(context).pop(true), //关闭对话框
            ),
            FlatButton(
              child: Text("取消"),
              onPressed: () {
                Navigator.of(context).pop(false); //关闭对话框
              },
            ),
          ],
        );
      },
    );
    if (!isConfirm) return;
    final res = await OrderApi.settlement(orderId);
    if (res['code'] != 200) return;
    final userProvider = Global.userProvider;
    userProvider.setBalance();
    userProvider.setAmount();
    Global.eventBus.fire('refreshOrderList');
    ToastUtils.showShort(res['message']);
  }
}
