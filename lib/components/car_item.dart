import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../utils/app_routes.dart';

class CarItem extends StatelessWidget {
  const CarItem({Key? key}) : super(key: key);

  void _selectCar(BuildContext context) {
    Navigator.of(context).pushNamed(
      AppRoutes.CAR_DETAIL,
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _selectCar(context),
      splashColor: Theme.of(context).primaryColor,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: LinearGradient(
              colors: [
                Colors.orange.withOpacity(0.5),
                Colors.orange,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            )),
        child: Text(
          'CARRO DA LISTA',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
    );
  }
}
