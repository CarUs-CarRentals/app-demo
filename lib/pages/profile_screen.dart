import 'package:carshare/utils/app_routes.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  void _selectProfileEdit(BuildContext context) {
    Navigator.of(context).pushNamed(AppRoutes.PROFILE_EDIT);
  }

  void _selectMyReviews(BuildContext context) {
    Navigator.of(context).pushNamed(AppRoutes.MY_REVIEWS);
  }

  void _selectMyCars(BuildContext context) {
    Navigator.of(context).pushNamed(AppRoutes.MY_CARS);
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
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    final availableHeight = mediaQuery.size.height - mediaQuery.padding.top;

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
                  ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                      ),
                    ),
                    title: Text(
                      'Olá, Nome do Usuario',
                      style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  ),
                  const Divider(),
                  _createItem(
                    Icons.person,
                    'Editar dados pessoais',
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
                  // Row(
                  //   children: [
                  //     Icon(
                  //       // <-- Icon
                  //       Icons.person,
                  //       size: 24.0,
                  //     ),
                  //     TextButton(
                  //       onPressed: () => _selectProfileEdit(context),
                  //       child: Align(
                  //         alignment: Alignment.centerLeft,
                  //         child: Text(
                  //           'Editar dados pessoais',
                  //           style: TextStyle(
                  //             color: Theme.of(context).colorScheme.secondary,
                  //             fontWeight: FontWeight.bold,
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  // Divider(
                  //   color: Colors.black,
                  // ),
                  // TextButton(
                  //   onPressed: () => _selectMyReviews(context),
                  //   child: Text(
                  //     'Minhas avaliações',
                  //     style: TextStyle(
                  //       color: Theme.of(context).colorScheme.primary,
                  //       fontWeight: FontWeight.bold,
                  //     ),
                  //   ),
                  // ),
                  // Divider(
                  //   color: Colors.black,
                  // ),
                  // TextButton(
                  //   onPressed: () => _selectMyCars(context),
                  //   child: Text(
                  //     'Meus carros',
                  //     style: TextStyle(
                  //       color: Theme.of(context).colorScheme.primary,
                  //       fontWeight: FontWeight.bold,
                  //     ),
                  //   ),
                  // ),
                  // Divider(
                  //   color: Colors.black,
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
