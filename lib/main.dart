import 'package:FL_Foreman/common/global.dart';
import 'package:FL_Foreman/providers/app_provider.dart';
import 'package:FL_Foreman/providers/user_provider.dart';
import 'package:FL_Foreman/res/colors.dart';
import 'package:FL_Foreman/views/guide/guide.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluwx/fluwx.dart';
import 'package:provider/provider.dart';

main() {
  runApp(App());
  registerWxApi(
    appId: "wx18fc3a377ec300f8",
    universalLink: "https://yihut.cn/foreman/ulink/",
  );
}

class App extends StatelessWidget {
  const App({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => AppProvider()),
      ],
      child: MaterialApp(
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
            // centerTitle: false,
          ),
          scaffoldBackgroundColor: Color(0xFFF4F6F7),
        ),
        home: Guide(),
      ),
    );
  }
}
