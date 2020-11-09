import 'package:FL_Foreman/apis/order_api.dart';
import 'package:FL_Foreman/common/dialog_util.dart';
import 'package:FL_Foreman/common/global.dart';
import 'package:FL_Foreman/common/input_formatter.dart';
import 'package:FL_Foreman/common/toast_utils.dart';
import 'package:FL_Foreman/common/wechat_action.dart';
import 'package:FL_Foreman/models/order_model.dart';
import 'package:FL_Foreman/res/colors.dart';
import 'package:FL_Foreman/res/text_styles.dart';
import 'package:FL_Foreman/widget/pannel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

  static renew({@required BuildContext context, @required Order info}) async {
    showDialog(
      context: context,
      useSafeArea: false,
      builder: (_) {
        return RenewPanel(
          info: info,
        );
      },
    );
  }
}

class RenewPanel extends StatefulWidget {
  final Order info;
  RenewPanel({Key key, @required this.info}) : super(key: key);

  @override
  _RenewPanelState createState() => _RenewPanelState();
}

class _RenewPanelState extends State<RenewPanel> {
  DateTime renewTime;
  TextEditingController priceEditingController;

  @override
  void initState() {
    super.initState();
    priceEditingController = TextEditingController()
      ..addListener(() {
        setState(() {});
      });
  }

  confirm() async {
    DialogUtils.showLoading(context: context, msg: '支付中');
    final res = await OrderApi.renew(
      renewTime: renewTime.toString().substring(0, 10),
      renewAmout: priceEditingController.text,
      orderNo: widget.info.orderNumber,
      originalTime: widget.info.endTime,
    );
    DialogUtils.hideLoading(context);
    if (res['code'] == 200) {
      final wechatRes = await WechatAction.payment(
        appId: res['data']['appid'],
        partnerId: res['data']['partnerid'],
        prepayId: res['data']['prepayid'],
        packageValue: res['data']['packagevalue'],
        nonceStr: res['data']['noncestr'],
        timeStamp: int.parse(res['data']['timestamp']),
        sign: res['data']['sign'],
      );
      if (wechatRes.isSuccessful) {
        Global.eventBus.fire('refreshOrderList');
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Center(
        child: AnimatedContainer(
          duration: Duration(milliseconds: 300),
          transform: Matrix4.translationValues(0, -MediaQuery.of(context).viewInsets.bottom * 0.3, 0),
          child: Pannel(
            margin: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Text('续费', style: TextStyles.title),
                ),
                SizedBox(height: 20),
                Text('续费时间', style: TextStyles.title),
                SizedBox(height: 16),
                InkWell(
                  onTap: () async {
                    final first = DateTime.parse(widget.info.endTime).add(Duration(days: 1));
                    final res = await showDatePicker(
                      builder: (context, child) {
                        return Theme(
                          data: ThemeData.dark(),
                          child: child,
                        );
                      },
                      locale: Locale('zh'),
                      initialDate: first,
                      context: context,
                      firstDate: first,
                      lastDate: DateTime(first.year, first.month + 6, first.day + 1),
                    );
                    if (res is DateTime) {
                      setState(() {
                        renewTime = res;
                      });
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 13, horizontal: 16),
                    decoration: BoxDecoration(
                      color: Color(0xFFF5F7F8),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            '续费时间',
                          ),
                        ),
                        Text(
                          renewTime == null ? '请选择' : renewTime.toString().substring(0, 10),
                          style: TextStyles.grey_12,
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: ColorCenter.textGrey,
                          size: 12,
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text('续费金额', style: TextStyles.title),
                SizedBox(height: 16),
                ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: 40),
                  child: TextField(
                    controller: priceEditingController,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp("^[1-9].*")),
                      FilteringTextInputFormatter.allow(RegExp("[0-9.]")),
                      MoneyTextInputFormatter(),
                    ],
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    style: TextStyle(fontSize: 14),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: const BorderRadius.all(
                          const Radius.circular(6),
                        ),
                      ),
                      filled: true,
                      fillColor: Color(0xFFF5F7F8),
                      hintText: '请填写续费金额',
                      hintStyle: TextStyle(color: Color(0xFF999999)),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                FlatButton(
                  onPressed: renewTime != null && priceEditingController.text.isNotEmpty ? () => confirm() : null,
                  minWidth: double.infinity,
                  disabledColor: Colors.grey[300],
                  child: Text('确定'),
                  color: ColorCenter.themeColor,
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
