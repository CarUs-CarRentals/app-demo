import 'package:carshare/models/user.dart';
import 'package:carshare/utils/app_routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class ProfileDetail extends StatelessWidget {
  final bool isMyProfile;
  final User user;
  // final String userFullname;
  // final String aboutMe;
  // final String fullAddress;
  const ProfileDetail({
    Key? key,
    required this.isMyProfile,
    // required this.userFullname,
    // required this.aboutMe,
    // required this.fullAddress,
    required this.user,
  }) : super(key: key);

  _descriptionSection(BuildContext context, String description) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      width: double.infinity,
      child: Column(
        children: <Widget>[
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: Text(
                  'Sobre mim:',
                  textAlign: TextAlign.left,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Flexible(
                child: Text(
                  description,
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 14),
                ),
              ),
            ],
          ),
          Padding(padding: EdgeInsets.only(top: 30)),
        ],
      ),
    );
  }

  void _selectReviewsReceived(BuildContext context, User user) {
    Navigator.of(context).pushNamed(
      AppRoutes.USER_REVIEW,
      arguments: user,
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: <Widget>[
          ListTile(
            trailing: Container(
              height: 150,
              width: mediaQuery.size.width / 4.5,
              alignment: Alignment.topRight,
              child: const CircleAvatar(radius: 150),
            ),
            title: Container(
              padding: const EdgeInsets.only(top: 10.0),
              child: Text(user.fullName,
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                  )),
            ),
            subtitle: Container(
              padding: const EdgeInsets.only(top: 20.0),
              child: Text("membro desde *ano*"),
            ),
            dense: false,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 25.0),
            child: isMyProfile
                ? ListTile(
                    leading: Container(
                      width: 24,
                      child: Icon(
                        Icons.reviews,
                        size: 24,
                      ),
                    ),
                    title: Text(
                      "*qtd* Avaliações",
                      style: const TextStyle(
                        fontFamily: 'RobotCondensed',
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onTap: () => _selectReviewsReceived(context, user),
                    dense: false,
                  )
                : null,
          ),
          Divider(),
          _descriptionSection(context, user.about),
          ListTile(
            leading: Container(
              width: 24,
              child: Icon(
                Icons.pin_drop_rounded,
                size: 24,
              ),
            ),
            title: Text(
              user.address.fullAddress,
              style: const TextStyle(
                fontFamily: 'RobotCondensed',
                fontSize: 14,
              ),
            ),
            dense: false,
          ),
          Divider(),
          if (isMyProfile)
            ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).colorScheme.primary,
                ),
                child: const Text(
                  'Editar Perfil',
                  style: TextStyle(fontSize: 20),
                )),
        ],
      ),
    );
  }
}
