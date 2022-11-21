import 'package:carshare/components/profile_detail.dart';
import 'package:carshare/models/address.dart';
import 'package:carshare/models/auth.dart';
import 'package:carshare/models/car.dart';
import 'package:carshare/models/user.dart';
import 'package:carshare/providers/users.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileUserScreen extends StatefulWidget {
  const ProfileUserScreen({Key? key}) : super(key: key);

  @override
  State<ProfileUserScreen> createState() => _ProfileUserScreenState();
}

class _ProfileUserScreenState extends State<ProfileUserScreen> {
  User? _currentUser;
  User? _profileUser;
  User? _profileCarUser;
  String _userId = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<Users>(context, listen: false).loadProfile();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<Users>(context);
    _currentUser = userProvider.userProfile;
    _userId = "";
    final bool argumentIsNull =
        (ModalRoute.of(context)?.settings.arguments == null);

    if (!argumentIsNull) {
      final userCar = ModalRoute.of(context)?.settings.arguments as User;
      _currentUser = userCar;

    } else {
      _currentUser = userProvider.userProfile;
    }

    return Scaffold(
        appBar: AppBar(
          title: !argumentIsNull
              ? const Text("Perfil do Proprietario")
              : const Text("Meu Perfil"),
        ),
        body: _currentUser == null
            ? const Center(child: CircularProgressIndicator())
            : ProfileDetail(
                isMyProfile: argumentIsNull ? true : false,
                user: _currentUser!,
              )       
        );
  }
}
