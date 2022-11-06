import 'package:carshare/components/profile_detail.dart';
import 'package:carshare/models/address.dart';
import 'package:carshare/models/auth.dart';
import 'package:carshare/models/auth_firebase.dart';
import 'package:carshare/models/car.dart';
import 'package:carshare/models/user.dart';
import 'package:carshare/models/user_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileUserScreen extends StatelessWidget {
  const ProfileUserScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final User? thisUser;
    final bool argumentIsNull =
        (ModalRoute.of(context)?.settings.arguments == null);
    Auth auth = Provider.of(context, listen: false);
    final User? currentUser = auth.currentUser;

    final provider = Provider.of<UserList>(context);

    if (!argumentIsNull) {
      final carInfo = ModalRoute.of(context)?.settings.arguments as Car;
      final List<User> carUsers =
          provider.users.where((user) => user.id == carInfo.userId).toList();

      thisUser = carUsers.elementAt(0);
    } else {
      thisUser = currentUser;
    }

    return Scaffold(
      appBar: AppBar(
        title: !argumentIsNull
            ? const Text("Perfil do Proprietario")
            : const Text("Meu Perfil"),
      ),
      body: ProfileDetail(
        isMyProfile: argumentIsNull ? true : false,
        user: thisUser!,
        // userFullname: thisUser.fullName,
        // aboutMe: thisUser.about,
        // fullAddress: thisUser.address.fullAddress,
      ),
    );
  }
}
