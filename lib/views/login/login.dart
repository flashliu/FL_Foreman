import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:FL_Foreman/apis/user_api.dart';
import 'package:FL_Foreman/common/dialog_util.dart';
import 'package:FL_Foreman/common/storage.dart';
import 'package:FL_Foreman/common/toast_utils.dart';
import 'package:FL_Foreman/providers/user_provider.dart';
import 'package:FL_Foreman/res/colors.dart';
import 'package:FL_Foreman/res/styles.dart';
import 'package:FL_Foreman/res/svgs.dart';
import 'package:FL_Foreman/views/home/home.dart';
import 'package:FL_Foreman/views/protocol_privacy/protocol_privacy.dart';
import 'package:FL_Foreman/widget/pannel.dart';
import 'package:common_utils/common_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluwx/fluwx.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  Login({Key key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TapGestureRecognizer protocolTapGestureRecognizer;
  TapGestureRecognizer privacyTapGestureRecognizer;
  TextEditingController accountEditController;
  TextEditingController codeEditController;
  Timer timer;
  String key = '';
  bool canSendCode = true;
  int tick = 60;
  bool wxInStall = false;

  void login() async {
    final username = accountEditController.value.text;
    final code = codeEditController.value.text;
    if (!RegexUtil.isMobileExact(username)) {
      return ToastUtils.showShort("请输入正确的手机号！");
    }
    if (code.length != 6) {
      return ToastUtils.showShort("验证码错误！");
    }
    DialogUtils.showLoading(context: context, msg: '登录中');
    final user = await Provider.of<UserProvider>(context, listen: false).smsLogin(
      username: username,
      code: code,
      key: key,
    );
    Navigator.of(context).pop();
    if (user != null) {
      loginSuccess(user);
    }
  }

  void wechatLogin() async {
    final user = await Provider.of<UserProvider>(context, listen: false).wechatLogin();
    if (user != null) {
      loginSuccess(user);
    }
  }

  void appleLogin() async {
    final user = await Provider.of<UserProvider>(context, listen: false).appleLogin();
    if (user != null) {
      loginSuccess(user);
    }
  }

  void aliLogin() async {
    Provider.of<UserProvider>(context, listen: false).aliLogin();
  }

  void loginSuccess(user) async {
    await Storage().set('userinfo', jsonEncode(user));
    Provider.of<UserProvider>(context, listen: false).setUser(user);
    ToastUtils.showLong("登录成功");
    Navigator.of(context).pushReplacement(CupertinoPageRoute(builder: (_) => Home()));
  }

  void getCode() async {
    if (!canSendCode) return;
    if (!RegexUtil.isMobileExact(accountEditController.value.text)) {
      return ToastUtils.showShort("请输入正确的手机号！");
    }
    String res = await UserApi.getCode(phone: accountEditController.value.text);
    setState(() {
      key = res;
      canSendCode = false;
    });
    _startCount();
  }

  void _startCount() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (tick == 1) {
          canSendCode = true;
          tick = 60;
          timer.cancel();
          return;
        }
        tick -= 1;
      });
    });
  }

  checkWxInstall() async {
    var value = await isWeChatInstalled;
    setState(() {
      wxInStall = value;
    });
  }

  @override
  void initState() {
    super.initState();
    checkWxInstall();
    accountEditController = TextEditingController();
    codeEditController = TextEditingController();
    protocolTapGestureRecognizer = TapGestureRecognizer()
      ..onTap = () {
        Navigator.of(context).push(
          CupertinoPageRoute(
            builder: (_) => ProtocolPrivacy(
              title: "用户协议",
            ),
          ),
        );
      };
    privacyTapGestureRecognizer = TapGestureRecognizer()
      ..onTap = () {
        Navigator.of(context).push(
          CupertinoPageRoute(
            builder: (_) => ProtocolPrivacy(
              title: "隐私政策",
            ),
          ),
        );
      };
  }

  @override
  void dispose() {
    accountEditController.dispose();
    codeEditController.dispose();
    if (timer != null) timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: ColorCenter.background,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: Container(
            height: double.infinity,
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 50),
                Image.asset(
                  "assets/images/logo.png",
                  width: 80,
                  height: 80,
                ),
                SizedBox(height: 40),
                buildInput(
                  hintText: '输入手机号',
                  icon: Icon(
                    Icons.phone_iphone,
                    color: ColorCenter.themeColor,
                    size: 16,
                  ),
                  controller: accountEditController,
                ),
                SizedBox(height: 20),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: buildInput(
                        hintText: '输入验证码',
                        icon: Icon(
                          Icons.lock,
                          color: ColorCenter.themeColor,
                          size: 16,
                        ),
                        controller: codeEditController,
                      ),
                    ),
                    SizedBox(width: 20),
                    GestureDetector(
                      onTap: getCode,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        decoration: kBtnDecorationStyle.copyWith(
                          color: canSendCode ? ColorCenter.themeColor : Colors.grey,
                        ),
                        alignment: Alignment.centerLeft,
                        height: 45.0,
                        child: Center(
                          child: Text(
                            canSendCode ? "获取验证码" : (tick.toString() + "s"),
                            style: TextStyle(fontSize: 14, color: Colors.white),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10, top: 40, left: 10),
                  child: GestureDetector(
                    onTap: login,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        alignment: Alignment.centerLeft,
                        decoration: kBtnDecorationStyleNormal,
                        height: 45.0,
                        child: Center(
                          child: Text(
                            "登录",
                            style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                _buildThirdLogin(),
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: _buildPolicy(),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildInput({String hintText, Widget icon, TextEditingController controller}) {
    return Container(
      alignment: Alignment.centerLeft,
      decoration: kBoxDecorationStyle3,
      height: 45.0,
      child: TextField(
        cursorColor: ColorCenter.themeColor,
        controller: controller,
        keyboardType: TextInputType.phone,
        style: TextStyle(
          color: Colors.black,
          fontFamily: 'OpenSans',
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(8),
          prefixIcon: icon,
          hintText: hintText,
          // hintStyle: TextStyles.kHintTextStyle,
        ),
      ),
    );
  }

  Widget _buildThirdLogin() {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 10, bottom: 10, top: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 1,
                  color: Colors.grey[200],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "第三方登录",
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ),
              Expanded(
                child: Container(
                  height: 1,
                  color: Colors.grey[200],
                ),
              ),
            ],
            crossAxisAlignment: CrossAxisAlignment.center,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 30),
            child: Row(
              children: [
                Visibility(
                  visible: wxInStall,
                  child: Pannel(
                    padding: EdgeInsets.zero,
                    borderRadius: BorderRadius.circular(50),
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    child: GestureDetector(
                      child: Svgs.wx,
                      onTap: () => wechatLogin(),
                    ),
                  ),
                ),
                Visibility(
                  visible: Platform.isIOS,
                  child: Pannel(
                    padding: EdgeInsets.zero,
                    borderRadius: BorderRadius.circular(50),
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    child: GestureDetector(
                      child: Svgs.apple,
                      onTap: () => appleLogin(),
                    ),
                  ),
                ),
                // Visibility(
                //   child: Pannel(
                //     padding: EdgeInsets.zero,
                //     borderRadius: BorderRadius.circular(50),
                //     margin: EdgeInsets.symmetric(horizontal: 20),
                //     child: GestureDetector(
                //       child: Svgs.ali,
                //       onTap: () => aliLogin(),
                //     ),
                //   ),
                //   visible: true,
                // )
              ],
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildPolicy() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: RichText(
          text: TextSpan(
            style: TextStyle(color: Colors.black, fontSize: 12.0),
            children: <TextSpan>[
              TextSpan(
                text: '登录即代表同意云护工',
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                ),
              ),
              TextSpan(
                recognizer: protocolTapGestureRecognizer,
                text: '《用户协议》 ',
                style: TextStyle(
                  color: ColorCenter.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(
                text: '和',
              ),
              TextSpan(
                recognizer: privacyTapGestureRecognizer,
                text: '《隐私政策》 ',
                style: TextStyle(
                  color: ColorCenter.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
