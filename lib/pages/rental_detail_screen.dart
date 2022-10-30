import 'package:carshare/models/car.dart';
import 'package:carshare/models/car_list.dart';
import 'package:carshare/models/rental.dart';
import 'package:carshare/models/rental_list.dart';
import 'package:carshare/models/review.dart';
import 'package:carshare/models/review_list.dart';
import 'package:carshare/utils/location_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class RentalDetailScreen extends StatefulWidget {
  const RentalDetailScreen({Key? key}) : super(key: key);

  @override
  State<RentalDetailScreen> createState() => _RentalDetailScreenState();
}

class _RentalDetailScreenState extends State<RentalDetailScreen> {
  String _rentalAdress = '';

  String _getImageRentalLocation(Rental rental) {
    final staticMapImageUrl = LocationUtil.generateLocationPreviewImage(
      latitude: rental.location.latitude,
      longitude: rental.location.longitude,
    );

    return staticMapImageUrl;
  }

  // Future<void> _getRentalAddress(Rental rental) async {
  //   await LocationUtil.getAddressFrom(
  //           LatLng(rental.location.latitude, rental.location.longitude))
  //       .then((String addressString) {
  //     setState(() {
  //       _rentalAdress = addressString;
  //     });
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final rentalDetail = ModalRoute.of(context)?.settings.arguments as Rental;

    final carProvider = Provider.of<CarList>(context);
    final reviewCarProvider = Provider.of<CarReviewList>(context);

    final Car car = carProvider.cars
        .where((car) => car.id == rentalDetail.carId)
        .elementAt(0);

    final CarReview carReview = reviewCarProvider.reviews
        .where((review) => review.rentalId == rentalDetail.id)
        .elementAt(0);

    print("data de retorno: ${rentalDetail.returnDate}");

    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhe da locação'),
      ),
      body: Card(
        margin: EdgeInsets.zero,
        color: Colors.white,
        elevation: 5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 200,
              width: MediaQuery.of(context).size.width,
              child: Image.network("${_getImageRentalLocation(rentalDetail)}",
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
                          '${DateFormat('dd/MM/yyyy • H:m', 'pt_BR').format(rentalDetail.rentalDate)} ${rentalDetail.returnDate != null ? DateFormat('- dd/MM/yyyy • H:m', 'pt_BR').format(rentalDetail.returnDate!) : ''}'),
                    ],
                  ),
                  Row(children: [
                    Text('R\$ ${rentalDetail.price.toStringAsFixed(2)}'),
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
                "${rentalDetail.location.address}",
                style: const TextStyle(
                  fontFamily: 'RobotCondensed',
                  fontSize: 14,
                ),
              ),
              dense: true,
              trailing: rentalDetail.returnDate == null
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
            rentalDetail.returnDate == null
                ? ListTile(
                    leading: Icon(
                      Icons.directions_car,
                      size: 24,
                    ),
                    title: Text(
                      "Locação em andamento",
                      style: const TextStyle(
                          fontFamily: 'RobotCondensed',
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    dense: true,
                  )
                : ListTile(
                    leading: Icon(
                      Icons.directions_car,
                      size: 24,
                    ),
                    title: Text(
                      rentalDetail.isReview == false
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
                          rentalDetail.isReview == false ? 0 : carReview!.rate,
                      itemBuilder: (context, _) => Icon(
                        Icons.star,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      itemCount: 5,
                      itemSize: 16.0,
                    ),
                    onTap: () {},
                  ),
            Divider(),
          ],
        ),
      ),
    );
  }
}
