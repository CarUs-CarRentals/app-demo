import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class MyRentalsScreen extends StatelessWidget {
  const MyRentalsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Text(
              'MEU HISTÓRICO DE LOCAÇÕES',
            ),
          ],
        ),
      ),
    );
  }
}
