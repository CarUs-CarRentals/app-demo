import 'package:carshare/models/auth.dart';
import 'package:carshare/pages/auth_screen.dart';
import 'package:carshare/pages/tabs_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

class IsAuthScreen extends StatelessWidget {
  const IsAuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of(context);
    //return auth.isAuth ? const TabsScreen() : const AuthScreen();
    return FutureBuilder(
      future: auth.tryAutoLogin(),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.error != null) {
          print(auth.tryAutoLogin());
          return const Center(
            child: Text('Ocorreu um erro!'),
          );
        } else {
          return auth.isAuth ? const TabsScreen() : const AuthScreen();
        }
      },
    );
  }
}
