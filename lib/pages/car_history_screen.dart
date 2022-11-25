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
  List<Rental> _rentalsCar = [];
  Car? _car;
  String _userLogged = "";

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_car == null) {
      setState(() {
        _isLoading = true;
      });
    }

    if (_car == null) {
      final arg = ModalRoute.of(context)?.settings.arguments;

      if (arg != null) {
        final car = arg as Car;
        _car = car;

        Provider.of<Auth>(context, listen: false).getLoggedUser().then((value) {
          setState(() {
            _userLogged = value['uuid'];
          });
        });
        Provider.of<Rentals>(context, listen: false)
            .loadRentalsByCar(_car!.id)
            .then((value) {
          setState(() {
            _isLoading = false;
          });
        });
        //print("${_car?.userId}");
        //print("${_car?.brand}");
      }
    }
  }

  @override
  void initState() {
    super.initState();
  }

  // Future<void> loadRentals(Car car) async {
  //   Provider.of<Rentals>(context, listen: false)
  //       .loadRentalsByCar(car.id)
  //       .then((value) {
  //     setState(() {
  //       if (_isLoading) {
  //         context.loaderOverlay.hide();
  //       }
  //       setState(() {
  //         _isLoading = context.loaderOverlay.visible;
  //       });
  //     });
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<Rentals>(context);
    final rentalsCar = provider.rentalsFromCar;
    final car = _car!;

    return Scaffold(
      appBar: AppBar(
        title: Text('Histórico de Locações'),
      ),
      body: Center(
        child: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : rentalsCar.isNotEmpty
                ? ListView.builder(
                    itemCount: rentalsCar.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        children: [
                          RentalItem(
                            rentalDetail: rentalsCar[index],
                            car: _car,
                            currentUserId: _userLogged,
                          ),
                          Divider(),
                        ],
                      );
                    },
                  )
                : const Center(child: Text('Sem registros')),
      ),
    );

    //provider.rentals.where((rental) => rental.carId == car.id).toList();
  }
}
