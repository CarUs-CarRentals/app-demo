import 'package:brasil_fields/brasil_fields.dart';
import 'package:carshare/components/rental_tile.dart';
import 'package:carshare/data/store.dart';
import 'package:carshare/models/auth.dart';
import 'package:carshare/models/car.dart';
import 'package:carshare/providers/cars.dart';
import 'package:carshare/models/rental.dart';
import 'package:carshare/models/review.dart';
import 'package:carshare/models/review_list.dart';
import 'package:carshare/providers/rentals.dart';
import 'package:carshare/utils/app_routes.dart';
import 'package:carshare/utils/location_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';

class RentalDetailScreen extends StatefulWidget {
  const RentalDetailScreen({Key? key}) : super(key: key);

  @override
  State<RentalDetailScreen> createState() => _RentalDetailScreenState();
}

class _RentalDetailScreenState extends State<RentalDetailScreen> {
  String _rentalAdress = '';
  bool _isMyCarRental = false;

  String _getImageRentalLocation(Rental rental) {
    final staticMapImageUrl = LocationUtil.generateLocationPreviewImage(
      latitude: rental.location.latitude,
      longitude: rental.location.longitude,
    );

    return staticMapImageUrl;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //final rentalDetail = ModalRoute.of(context)?.settings.arguments as Rental;
    final arg = ModalRoute.of(context)?.settings.arguments as Map;
    final car = arg['car'] as Car;
    final rental = arg['rental'] as Rental;
    final currentUserId = arg['currentUserId'] as String;

    //final _userId = userProvider.email;
    if (car.userId == currentUserId) {
      print("${car.userId} é igual a ${currentUserId}");
      _isMyCarRental = true;
    } else {
      print("${car.userId} é diferente de ${currentUserId}");
    }

    // final Car car = carProvider.cars
    //     .where((car) => car.id == rentalDetail.carId)
    //     .elementAt(0);

    // final CarReview carReview = reviewCarProvider.reviews
    //     .where((review) => review.rentalId == rentalDetail.id)
    //     .elementAt(0);

    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhe da locação'),
      ),
      body: LoaderOverlay(
        child: Card(
          margin: EdgeInsets.zero,
          color: Colors.white,
          elevation: 5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              RentalTile(
                rental: rental,
                rentalLabel: true,
              ),
              SizedBox(
                height: 200,
                width: MediaQuery.of(context).size.width,
                child: Image.network("${_getImageRentalLocation(rental)}",
                    fit: BoxFit.cover, loadingBuilder: (BuildContext context,
                        Widget child, ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  }
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  );
                }),
              ),
              Container(
                padding: EdgeInsets.all(15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                            '${DateFormat('dd/MM/yyyy • H:mm', 'pt_BR').format(rental.rentalDate)} ${DateFormat('- dd/MM/yyyy • H:mm', 'pt_BR').format(rental.returnDate)}'),
                      ],
                    ),
                    Row(children: [
                      Text(UtilBrasilFields.obterReal(rental.price)),
                    ])
                  ],
                ),
              ),
              ListTile(
                leading: Icon(
                  Icons.pin_drop,
                  size: 24,
                ),
                title: Text(
                  "${rental.location.address}",
                  style: const TextStyle(
                    fontFamily: 'RobotCondensed',
                    fontSize: 14,
                  ),
                ),
                dense: true,
                trailing: rental.status != RentalStatus.RENTED
                    ? null
                    : ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                            primary: Theme.of(context).colorScheme.primary,
                            padding: EdgeInsets.all(0)),
                        child: const Text(
                          'Recibo',
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
              ),
              Divider(),
              _isMyCarRental
                  ? ListTile(
                      enabled:
                          rental.status != RentalStatus.RENTED ? false : true,
                      leading: Icon(
                        Icons.person_rounded,
                        size: 24,
                      ),
                      title: Text(
                        "Avalie o motorista",
                        style: const TextStyle(
                            fontFamily: 'RobotCondensed',
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      dense: true,
                      trailing: RatingBarIndicator(
                        rating:
                            rental.isReview == false ? 0 : 0, //carReview.rate,
                        itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        itemCount: 5,
                        itemSize: 16.0,
                      ),
                      onTap: () => Navigator.of(context).pushNamed(
                        AppRoutes.REVIEW_FORM,
                        arguments: rental,
                      ),
                    )
                  : ListTile(
                      enabled:
                          rental.status != RentalStatus.RENTED ? false : true,
                      leading: Icon(
                        Icons.directions_car,
                        size: 24,
                      ),
                      title: Text(
                        rental.isReview == false
                            ? "Avalie o veículo"
                            : "Veículo avaliado",
                        style: const TextStyle(
                            fontFamily: 'RobotCondensed',
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      dense: true,
                      trailing: RatingBarIndicator(
                        rating:
                            rental.isReview == false ? 0 : 0, //carReview.rate,
                        itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        itemCount: 5,
                        itemSize: 16.0,
                      ),
                      onTap: () => Navigator.of(context).pushNamed(
                        AppRoutes.REVIEW_FORM,
                        arguments: rental,
                      ),
                    ),
              Divider(),
              RentalTile(
                rental: rental,
                rentalAction: _isMyCarRental,
                onTap: () {
                  setState(() {
                    Provider.of<Rentals>(context, listen: false)
                        .loadRentalsByCar(rental.carId);
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
