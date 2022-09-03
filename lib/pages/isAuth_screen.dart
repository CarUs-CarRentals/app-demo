import 'package:carshare/models/auth.dart';
import 'package:carshare/pages/auth_screen.dart';
import 'package:carshare/pages/tabs_screen.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

class IsAuthScreen extends StatelessWidget {
  const IsAuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of(context);
    print(auth.isAuth);
    return auth.isAuth ? const TabsScreen() : const AuthScreen();
  }
}
