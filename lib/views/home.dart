import 'package:FL_User/providers/user.provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  Home({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
        child: Consumer<UserProvider>(builder: (_, userProvider, __) {
          final tips = userProvider.user == null ? 'pleae Login' : 'user name: ${userProvider.user?.realName}';
          final btnText = userProvider.user == null ? 'login' : 'logout';
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(tips),
              MaterialButton(
                onPressed: () {
                  if (userProvider.user == null) {
                    userProvider.getUser();
                  } else {
                    userProvider.setUser(null);
                  }
                },
                child: Text(btnText),
                color: Colors.blue,
                textColor: Colors.white,
              )
            ],
          );
        }),
      ),
    );
  }

  loginAndOut() {}
}
