import 'package:carshare/components/profile_detail.dart';
import 'package:carshare/models/car.dart';
import 'package:carshare/models/user.dart';
import 'package:carshare/models/user_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileUserScreen extends StatelessWidget {
  const ProfileUserScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final carInfo = ModalRoute.of(context)?.settings.arguments as Car;

    final provider = Provider.of<UserList>(context);
    final List<User> carUsers =
        provider.users.where((user) => user.id == carInfo.user.id).toList();

    final User thisUser = carUsers.elementAt(0);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil do Proprietario'),
      ),
      body: ProfileDetail(
        isMyProfile: false,
        userFullname: thisUser.fullName,
        aboutMe: thisUser.about,
        fullAddress: thisUser.address.fullAddress,
      ),
    );
  }
}
