import 'package:carshare/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'MINHA CONTA',
            ),
            TextButton(
              onPressed: () => _selectProfileEdit(context),
              child: Text(
                'Editar dados pessoais',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            TextButton(
              onPressed: () => _selectMyReviews(context),
              child: Text(
                'Minhas avaliações',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            TextButton(
              onPressed: () => _selectMyCars(context),
              child: Text(
                'Meus carros',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
