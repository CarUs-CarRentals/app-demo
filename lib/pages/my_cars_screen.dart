import 'package:carshare/components/car_item.dart';
import 'package:carshare/components/car_item_edit.dart';
import 'package:carshare/components/cars_list_view.dart';
import 'package:carshare/models/auth.dart';
import 'package:carshare/models/car.dart';
import 'package:carshare/models/car_list.dart';
import 'package:carshare/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

class MyCarsScreen extends StatelessWidget {
  const MyCarsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final availableHeight =
        mediaQuery.size.height - kToolbarHeight - mediaQuery.padding.top;

    Auth auth = Provider.of(context, listen: false);
    String? myID = auth.userId;

    final provider = Provider.of<CarList>(context);
    final List<Car> carsUser =
        provider.cars.where((car) => car.userId == myID).toList();

    return Scaffold(
        appBar: AppBar(
          title: Text('Meus Carros'),
          actions: [
            IconButton(
                onPressed: () => Navigator.of(context).pushNamed(
                      AppRoutes.CAR_FORM,
                    ),
                icon: Icon(Icons.add))
          ],
        ),
        body: SingleChildScrollView(
          child: SizedBox(
            width: mediaQuery.size.width,
            height: availableHeight,
            child: ListView.builder(
                itemCount: carsUser.length,
                itemBuilder: (context, index) {
                  final car = carsUser[index];
                  return CarItemEdit(car);
                }),
          ),
        ));
  }
}
