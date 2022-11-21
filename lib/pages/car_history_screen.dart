import 'package:carshare/components/rental_item.dart';
import 'package:carshare/models/auth.dart';
import 'package:carshare/models/car.dart';
import 'package:carshare/models/rental.dart';
import 'package:carshare/providers/rentals.dart';
import 'package:carshare/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';

class CarRentalsHistoryScreen extends StatefulWidget {
  const CarRentalsHistoryScreen({Key? key}) : super(key: key);

  @override
  State<CarRentalsHistoryScreen> createState() =>
      _CarRentalsHistoryScreenState();
}

class _CarRentalsHistoryScreenState extends State<CarRentalsHistoryScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    context.loaderOverlay.show();
    setState(() {
      _isLoading = context.loaderOverlay.visible;
    });

    Provider.of<Rentals>(context, listen: false).loadRentals().then((value) {
      setState(() {
        if (_isLoading) {
          context.loaderOverlay.hide();
        }
        setState(() {
          _isLoading = context.loaderOverlay.visible;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final car = ModalRoute.of(context)?.settings.arguments as Car;

    final provider = Provider.of<Rentals>(context);
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
