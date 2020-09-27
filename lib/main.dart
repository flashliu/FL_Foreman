import 'dart:convert';
import 'dart:io';

import 'package:FL_Foreman/common/global.dart';
import 'package:FL_Foreman/common/storage.dart';
import 'package:FL_Foreman/common/toast_utils.dart';
import 'package:FL_Foreman/models/user_model.dart';
import 'package:FL_Foreman/providers/app_provider.dart';
import 'package:FL_Foreman/providers/style_provider.dart';
import 'package:FL_Foreman/providers/user_provider.dart';
import 'package:FL_Foreman/res/colors.dart';
import 'package:FL_Foreman/views/home/home.dart';
import 'package:FL_Foreman/views/login/login.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bugly/flutter_bugly.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:fluwx/fluwx.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Permission.notification.request();
  registerWxApi(
    appId: "wx18fc3a377ec300f8",
    universalLink: "https://yihut.cn/foreman/ulink/",
  );
  setDeBugLog();
  final user = await getStorageUser();
  FlutterBugly.postCatchedException(
    () => runApp(App(user: user)),
    debugUpload: true,
    handler: (flutterErrorDetails) {},
  );
  FlutterBugly.init(androidAppId: "9d119bd5de", iOSAppId: "9d3564f668");
  setAndroidStatusBar();
}

Future<User> getStorageUser() async {
  final res = await Storage().get('userinfo');
  if (res == null) return res;
  return User.fromJson(jsonDecode(res));
}

setDeBugLog() {
  Global.http.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options) {
        if (kDebugMode) {
          print('uri----------------------------');
          print(options.uri);
          print('queryParameters----------------------------');
          print(options.queryParameters);
          print('data----------------------------');
          print(options.data);
        }
      },
      onResponse: (Response res) {
        if (kDebugMode) {
          print('response----------------------------');
          print(res.toString());
        }
        if (res.data['code'] == 500) {
          ToastUtils.showLong(res.data['message']);
        }
      },
      onError: (DioError error) {
        ToastUtils.showLong(error.message);
      },
    ),
  );
}

setAndroidStatusBar() {
  if (Platform.isAndroid) {
    // 以下两行 设置android状态栏为透明的沉浸。写在组件渲染之后，
    // 是为了在渲染后进行set赋值，覆盖状态栏，写在渲染之前MaterialApp组件会覆盖掉这个值。
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
  }
}

class App extends StatelessWidget {
  final User user;
  const App({Key key, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider(user)),
        ChangeNotifierProvider(create: (context) => AppProvider()),
        Provider(create: (context) => StyleProvider())
      ],
      child: MaterialApp(
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('zh', 'CH'),
          const Locale('en', 'US'),
        ],
        locale: Locale('zh'),
        key: Global.key,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          appBarTheme: AppBarTheme(
            iconTheme: IconThemeData(color: ColorCenter.textBlack, size: 28),
            textTheme: TextTheme(
              headline6: TextStyle(
                color: ColorCenter.textBlack,
                fontSize: 17,
              ),
            ),
            brightness: Brightness.light,
            elevation: 0,
            color: Colors.white,
            centerTitle: false,
          ),
          scaffoldBackgroundColor: Color(0xFFF4F6F7),
        ),
        home: user == null ? Login() : Home(),
      ),
    );
  }
}
