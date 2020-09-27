import 'package:FL_Foreman/apis/user_api.dart';
import 'package:FL_Foreman/common/dialog_util.dart';
import 'package:FL_Foreman/common/global.dart';
import 'package:FL_Foreman/common/toast_utils.dart';
import 'package:FL_Foreman/common/wechat_action.dart';
import 'package:FL_Foreman/providers/user_provider.dart';
import 'package:FL_Foreman/res/colors.dart';
import 'package:FL_Foreman/res/svgs.dart';
import 'package:FL_Foreman/res/text_styles.dart';
import 'package:FL_Foreman/widget/pannel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class Reflect extends StatefulWidget {
  Reflect({Key key}) : super(key: key);

  @override
  _ReflectState createState() => _ReflectState();
}

class _ReflectState extends State<Reflect> {
  TextEditingController textEditingController = TextEditingController();

  confirm() async {
    final user = Global.userProvider;
    final amount = textEditingController.text;
    if (double.parse(amount) > double.parse(user.balance)) return ToastUtils.showShort('最多可提现${user.balance}');
    final payPassword = await DialogUtils.showPaymentPassword(context: context);
    if (payPassword == null) return;
    final response = await WechatAction.sendAuth();
    final res = await UserApi.reflect(
      code: response.code,
      amount: textEditingController.text,
      payPassword: payPassword,
    );

    if (res['code'] == 200) {
      ToastUtils.showShort(res['message']);
      await user.setBalance();
      await user.setAmount();
      Navigator.of(context).pop();
    }
  }

  @override
  void initState() {
    super.initState();
    textEditingController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final amount = textEditingController.text;
    final user = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          child: Icon(Icons.chevron_left),
          onTap: () => Navigator.of(context).pop(),
        ),
        title: Text('提现'),
        titleSpacing: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Text('提现方式', style: TextStyles.black_Bold_16),
                  SizedBox(width: 74),
                  Expanded(
                    child: Row(
                      children: [
                        Svgs.wx,
                        SizedBox(width: 8),
                        Column(
                          children: [
                            Text('微信', style: TextStyles.black_Bold_16),
                            Text('2小时到账', style: TextStyle(color: Color(0xFF00A2E6), fontSize: 12)),
                          ],
                        )
                      ],
                    ),
                  ),
                  Icon(Icons.keyboard_arrow_right),
                ],
              ),
            ),
            Pannel(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('提现金额', style: TextStyles.black_Bold_16),
                  TextField(
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp("^[1-9].*")),
                      FilteringTextInputFormatter.allow(RegExp("[0-9.]")),
                      MoneyTextInputFormatter(),
                    ],
                    controller: textEditingController,
                    autofocus: true,
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      prefix: Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Text('¥', style: TextStyle(fontSize: 36, color: ColorCenter.textBlack)),
                      ),
                    ),
                    style: TextStyle(fontSize: 36, fontWeight: FontWeight.w500),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            style: TextStyles.black_14.copyWith(fontSize: 12),
                            children: [
                              TextSpan(text: '全部余额'),
                              TextSpan(text: '￥${user.balance}', style: TextStyle(color: Color(0xFF00A2E6))),
                              TextSpan(text: '（最低提现1元）'),
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          textEditingController.text = user.balance;
                          textEditingController.selection = TextSelection.fromPosition(
                            TextPosition(offset: textEditingController.text.length),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text('全部提现', style: TextStyle(color: Color(0xFF00A2E6), fontSize: 12)),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                  FlatButton(
                    minWidth: double.infinity,
                    height: 40,
                    onPressed: amount.isEmpty || double.parse(amount) <= 0 ? null : confirm,
                    disabledColor: Colors.grey[300],
                    child: Text('确认提现', style: TextStyle(fontWeight: FontWeight.normal)),
                    color: ColorCenter.themeColor,
                    textColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

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
