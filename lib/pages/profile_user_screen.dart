import 'package:carshare/components/profile_detail.dart';
import 'package:carshare/models/address.dart';
import 'package:carshare/models/auth.dart';
import 'package:carshare/models/car.dart';
import 'package:carshare/models/user.dart';
import 'package:carshare/models/user_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileUserScreen extends StatefulWidget {
  const ProfileUserScreen({Key? key}) : super(key: key);

  @override
  State<ProfileUserScreen> createState() => _ProfileUserScreenState();
}

class _ProfileUserScreenState extends State<ProfileUserScreen> {
  User? _currentUser;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Auth().getLoggedUser().then((value) {
      setState(() {
        _currentUser = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final User? thisUser;
    final bool argumentIsNull =
        (ModalRoute.of(context)?.settings.arguments == null);

    final provider = Provider.of<UserList>(context);

    if (!argumentIsNull) {
      final carInfo = ModalRoute.of(context)?.settings.arguments as Car;
      final List<User> carUsers =
          provider.users.where((user) => user.id == carInfo.userId).toList();

      thisUser = carUsers.elementAt(0);
    } else {
      thisUser = _currentUser;
    }

    return Scaffold(
      appBar: AppBar(
        title: !argumentIsNull
            ? const Text("Perfil do Proprietario")
            : const Text("Meu Perfil"),
      ),
      body: thisUser == null
          ? const Center(child: CircularProgressIndicator())
          : ProfileDetail(
              isMyProfile: argumentIsNull ? true : false,
              user: thisUser,
            ),
    );
  }
}
