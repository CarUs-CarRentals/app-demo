import 'package:carshare/components/car_form.dart';
import 'package:carshare/models/car.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'package:numberpicker/numberpicker.dart';

class CarFormScreen extends StatefulWidget {
  const CarFormScreen({Key? key}) : super(key: key);

  @override
  State<CarFormScreen> createState() => _CarFormScreenState();
}

class _CarFormScreenState extends State<CarFormScreen> {

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    //_priceFocus.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return Scaffold(
        appBar: AppBar(
          title: Text('Formulario Carro'),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: CarForm(),
        ));
  }
}
