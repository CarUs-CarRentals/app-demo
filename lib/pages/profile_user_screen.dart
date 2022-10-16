import 'package:carshare/components/profile_detail.dart';
import 'package:carshare/models/address.dart';
import 'package:carshare/models/car.dart';
import 'package:carshare/models/user.dart';
import 'package:carshare/models/user_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileUserScreen extends StatelessWidget {
  const ProfileUserScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final User thisUser;
    final bool argumentIsNull =
        (ModalRoute.of(context)?.settings.arguments == null);

    if (!argumentIsNull) {
      final carInfo = ModalRoute.of(context)?.settings.arguments as Car;
      final provider = Provider.of<UserList>(context);
      final List<User> carUsers =
          provider.users.where((user) => user.id == carInfo.user.id).toList();

      thisUser = carUsers.elementAt(0);
    } else {
      thisUser = User(
          5,
          "login",
          "password",
          "email",
          "firstName",
          "lastName",
          "cpf",
          "rg",
          "phone",
          UserGender.male,
          "about",
          Address("cep", "state", "city", "neighborhood", "street", 999));
    }

    return Scaffold(
      appBar: AppBar(
        title: !argumentIsNull
            ? const Text("Perfil do Proprietario")
            : const Text("Meu Perfil"),
      ),
      body: ProfileDetail(
        isMyProfile: argumentIsNull ? true : false,
        userFullname: thisUser.fullName,
        aboutMe: thisUser.about,
        fullAddress: thisUser.address.fullAddress,
      ),
    );
  }
}
