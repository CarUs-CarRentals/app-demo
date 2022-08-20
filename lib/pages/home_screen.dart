import 'package:carshare/components/car_item.dart';
import 'package:carshare/data/dummy_cars_data.dart';
import 'package:carshare/models/car.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen();

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return Scaffold(
      body: ListView.builder(
        itemCount: dummyCars.length,
        itemBuilder: (context, index) => CarItem(dummyCars[index]),
      ),
    );
  }
}
