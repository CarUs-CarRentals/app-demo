import 'package:carshare/components/rental_item.dart';
import 'package:carshare/models/auth.dart';
import 'package:carshare/models/car.dart';
import 'package:carshare/models/rental.dart';
import 'package:carshare/models/rental_list.dart';
import 'package:carshare/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

class CarRentalsHistoryScreen extends StatelessWidget {
  const CarRentalsHistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final car = ModalRoute.of(context)?.settings.arguments as Car;

    final provider = Provider.of<RentalList>(context);
    final List<Rental> rentalsCar =
        provider.rentals.where((rental) => rental.carId == car.id).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Histórico de Locações'),
      ),
      body: Center(
        child: ListView.builder(
          itemCount: rentalsCar.length,
          itemBuilder: (BuildContext context, int index) {
            return Column(
              children: [
                RentalItem(rentalDetail: rentalsCar[index]),
                Divider(),
              ],
            );
          },
        ),
      ),
    );
  }
}
