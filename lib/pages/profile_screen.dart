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

  _createSectionOption(
    BuildContext context,
    IconData icon,
    String label,
    Function screenDestiny,
  ) {
    return Row(
      children: [
        Icon(
          // <-- Icon
          icon,
          size: 24.0,
        ),
        TextButton(
          onPressed: () => screenDestiny(context),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              label,
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
    // const Divider(
    //   color: Colors.black,
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
                //width: double.infinity,
                ),
            Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.all(10),
              width: double.infinity,
              height: 600,
              child: ListView(
                children: [
                  const Divider(),
                  _createSectionOption(
                    context,
                    Icons.person,
                    'Editar dados pessoais',
                    _selectProfileEdit,
                  ),
                  const Divider(),
                  _createSectionOption(
                    context,
                    Icons.reviews,
                    'Minhas avaliações',
                    _selectMyReviews,
                  ),
                  const Divider(),
                  _createSectionOption(
                    context,
                    Icons.directions_car,
                    'Meus carros',
                    _selectMyCars,
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
