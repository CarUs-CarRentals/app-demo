import 'package:carshare/components/rental_item.dart';
import 'package:carshare/models/auth.dart';
import 'package:carshare/models/auth_firebase.dart';
import 'package:carshare/models/rental.dart';
import 'package:carshare/models/rental_list.dart';
import 'package:carshare/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

class MyRentalsScreen extends StatelessWidget {
  const MyRentalsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of(context, listen: false);
    String? myID = auth.userId;

    final provider = Provider.of<RentalList>(context);
    final List<Rental> rentalsUser =
        provider.rentals.where((rental) => rental.userId == myID).toList();

    return Scaffold(
      body: Center(
        child: ListView.builder(
          itemCount: rentalsUser.length,
          itemBuilder: (BuildContext context, int index) {
            return Column(
              children: [
                RentalItem(rentalDetail: rentalsUser[index]),
                Divider(),
              ],
            );
          },
        ),
      ),
    );
  }
}
