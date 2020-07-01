import 'package:FL_User/providers/user.provider.dart';
import 'package:FL_User/views/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

main() => runApp(App());

class App extends StatelessWidget {
  const App({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => UserProvider()),
        ],
        child: Home(),
      ),
    );
  }
}
