import 'package:carshare/models/car.dart';
import 'package:carshare/providers/cars.dart';
import 'package:carshare/models/rental.dart';
import 'package:carshare/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class RentalItem extends StatelessWidget {
  final Rental rentalDetail;
  const RentalItem({Key? key, required this.rentalDetail}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<Cars>(context);
    final Car car =
        provider.cars.where((car) => car.id == rentalDetail.carId).elementAt(0);

    return ListTile(
        leading: AspectRatio(
          aspectRatio: 1,
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(4.0)),
            child: Image.network(
              car.imagesUrl[0].url,
              fit: BoxFit.cover,
            ),
          ),
        ),
        title: Text(
          '${car.shortDescription}',
          style: const TextStyle(
            fontFamily: 'RobotCondensed',
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
            '${DateFormat('MMM dd • H:m', 'pt_BR').format(rentalDetail.rentalDate)} ${rentalDetail.returnDate != null ? DateFormat('- MMM dd • H:m', 'pt_BR').format(rentalDetail.returnDate!) : ''}\nR\$ ${rentalDetail.price.toStringAsFixed(2)}'),
        isThreeLine: true,
        trailing: Icon(
          Icons.keyboard_arrow_right_outlined,
          size: 32,
        ),
        onTap: () => Navigator.of(context).pushNamed(
              AppRoutes.RENTAL_DETAIL,
              arguments: rentalDetail,
            ));
  }
}
