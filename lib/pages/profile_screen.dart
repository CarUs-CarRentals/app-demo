//import 'package:carshare/models/auth_old.dart';
import 'package:carshare/models/auth.dart';
import 'package:carshare/providers/cars.dart';
import 'package:carshare/models/user.dart';
import 'package:carshare/providers/users.dart';
import 'package:carshare/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isLoading = true;
  User? _currentUser;

  void _selectProfileEdit(BuildContext context) {
    Navigator.of(context).pushNamed(AppRoutes.PROFILE_USER);
  }

  void _selectMyReviews(BuildContext context) {
    Navigator.of(context).pushNamed(AppRoutes.MY_REVIEWS);
  }

  void _selectMyCars(BuildContext context) {
    Navigator.of(context).pushNamed(AppRoutes.MY_CARS);
  }

  void _selectLogOut(BuildContext context) {
    Provider.of<Auth>(
      context,
      listen: false,
    ).logout();
    Navigator.of(context).pushReplacementNamed(
      AppRoutes.IS_AUTH,
    );
  }

  Widget _createItem(IconData icon, String label, VoidCallback onTap) {
    return ListTile(
      leading: Icon(
        icon,
        size: 24,
      ),
      title: Text(
        label,
        style: const TextStyle(
          fontFamily: 'RobotCondensed',
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
      onTap: onTap,
    );
  }

  @override
  void initState() {
    super.initState();
    Provider.of<Users>(context, listen: false).loadProfile();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final availableHeight = mediaQuery.size.height - mediaQuery.padding.top;
    final userProvider = Provider.of<Users>(context);

    _currentUser = userProvider.userProfile;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: double.infinity,
              height: availableHeight,
              child: ListView(
                children: [
                  _currentUser == null
                      ? ListTile(
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                          leading: Shimmer.fromColors(
                            baseColor: Colors.grey,
                            highlightColor: Color.fromARGB(255, 190, 190, 190),
                            child: CircleAvatar(
                              radius: 30,
                            ),
                          ),
                        )
                      : ListTile(
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                          leading: CircleAvatar(
                            radius: 30,
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            child: Padding(
                              padding: const EdgeInsets.all(6.0),
                            ),
                          ),
                          title: Text(
                            'Olá ${_currentUser!.fullName}',
                            style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ),
                  const Divider(),
                  _createItem(
                    Icons.person,
                    'Meu Perfil',
                    () => _selectProfileEdit(context),
                  ),
                  const Divider(),
                  _createItem(
                    Icons.reviews,
                    'Minhas avaliações',
                    () => _selectMyReviews(context),
                  ),
                  const Divider(),
                  _createItem(
                    Icons.directions_car,
                    'Meus carros',
                    () => _selectMyCars(context),
                  ),
                  const Divider(),
                  _createItem(
                    Icons.exit_to_app,
                    'Sair',
                    () => _selectLogOut(context),
                  ),
                  const Divider(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
