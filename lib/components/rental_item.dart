import 'package:brasil_fields/brasil_fields.dart';
import 'package:carshare/models/car.dart';
import 'package:carshare/providers/cars.dart';
import 'package:carshare/models/rental.dart';
import 'package:carshare/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';

class RentalItem extends StatefulWidget {
  final Rental rentalDetail;
  final Car? car;
  final String currentUserId;
  const RentalItem(
      {Key? key,
      required this.rentalDetail,
      required this.car,
      required this.currentUserId})
      : super(key: key);

  @override
  State<RentalItem> createState() => _RentalItemState();
}

class _RentalItemState extends State<RentalItem> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Provider.of<Cars>(context, listen: false)
    //     .loadCarsById(widget.carId)
    //     .then((value) {
    //   setState(() {
    //     if (_isLoading) {
    //       context.loaderOverlay.hide();
    //       _isLoading = context.loaderOverlay.visible;
    //     }
    //   });
    // });
  }

  @override
  Widget build(BuildContext context) {
    //final provider = Provider.of<Cars>(context);
    //final Car car = provider.car;
    // final Car car =
    //     provider.cars.where((car) => car.id == rentalDetail.carId).elementAt(0);

    return ListTile(
        leading: AspectRatio(
          aspectRatio: 1,
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(4.0)),
            child: Image.network(
              widget.car!.imagesUrl[0].url,
              fit: BoxFit.cover,
            ),
          ),
        ),
        title: Text(
          '${widget.car!.shortDescription}',
          style: const TextStyle(
            fontFamily: 'RobotCondensed',
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: RichText(
            text: TextSpan(
          style: Theme.of(context).textTheme.subtitle2,
          children: <TextSpan>[
            TextSpan(
                text:
                    '${DateFormat('MMM dd • H:mm', 'pt_BR').format(widget.rentalDetail.rentalDate)} ${DateFormat('- MMM dd • H:mm', 'pt_BR').format(widget.rentalDetail.returnDate)}'),
            TextSpan(
                text:
                    '\n${UtilBrasilFields.obterReal(widget.rentalDetail.price)} - ${Rental.getRentalStatusText(widget.rentalDetail.status)}'),
          ],
        )),

        //Text(
        //    '${DateFormat('MMM dd • H:mm', 'pt_BR').format(rentalDetail.rentalDate)} ${DateFormat('- MMM dd • H:mm', 'pt_BR').format(rentalDetail.returnDate)}\n${UtilBrasilFields.obterReal(rentalDetail.price)} \t STATUS'),
        isThreeLine: true,
        trailing: Icon(
          Icons.keyboard_arrow_right_outlined,
          size: 32,
        ),
        onTap: () => Navigator.of(context).pushNamed(
              AppRoutes.RENTAL_DETAIL,
              arguments: {
                'rental': widget.rentalDetail,
                'car': widget.car,
                'currentUserId': widget.currentUserId,
              },
            ));
  }
}
