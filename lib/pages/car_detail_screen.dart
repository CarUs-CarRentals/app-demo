import 'package:carshare/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class CarDetailScreen extends StatelessWidget {
  const CarDetailScreen({Key? key}) : super(key: key);

  void _selectCarReview(BuildContext context) {
    Navigator.of(context).pushNamed(AppRoutes.CAR_REVIEW);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Detalhe do carro selecionado',
            ),
            TextButton(
              onPressed: () => _selectCarReview(context),
              child: Text(
                'Avaliações do Carro',
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
