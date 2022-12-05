import 'package:brasil_fields/brasil_fields.dart';
import 'package:carshare/models/car.dart';
import 'package:carshare/models/review.dart';
import 'package:carshare/models/user.dart';
import 'package:carshare/providers/cars.dart';
import 'package:carshare/models/rental.dart';
import 'package:carshare/providers/reviews.dart';
import 'package:carshare/providers/users.dart';
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
  bool _isLoading = false;
  User? _rentalUser;
  CarReview? _carReview;
  UserReview? _userReview;

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

  Future<void> _getRentalUser(String userId) async {
    _rentalUser =
        await Provider.of<Users>(context, listen: false).loadUserById(userId);
    // ignore: use_build_context_synchronously
    //final provider = Provider.of<Users>(context, listen: false);
    //_rentalUser = provider.userByID;
  }

  Future<void> _getCarReview(int carId) async {
    final provider = Provider.of<Reviews>(context, listen: false);
    await provider.loadCarReviewsByCar(carId);
    try {
      _carReview = provider.carReviewsFromCar
          .where((review) => review.rentalId == widget.rentalDetail.id)
          .elementAt(0);
    } catch (e) {
      _carReview = null;
    }
  }

  Future<void> _getUserReview(String userId) async {
    final provider = Provider.of<Reviews>(context, listen: false);
    await provider.loadUserReviewsByUser(userId);
    try {
      _userReview = provider.userReviewsFromUser
          .where((review) => review.rentalId == widget.rentalDetail.id)
          .elementAt(0);
    } catch (e) {
      _userReview = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    //final provider = Provider.of<Cars>(context);
    //final Car car = provider.car;
    // final Car car =
    //     provider.cars.where((car) => car.id == rentalDetail.carId).elementAt(0);

    return Column(
      children: [
        ListTile(
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
          enabled: !_isLoading,
          //Text(
          //    '${DateFormat('MMM dd • H:mm', 'pt_BR').format(rentalDetail.rentalDate)} ${DateFormat('- MMM dd • H:mm', 'pt_BR').format(rentalDetail.returnDate)}\n${UtilBrasilFields.obterReal(rentalDetail.price)} \t STATUS'),
          isThreeLine: true,
          trailing: Icon(
            Icons.keyboard_arrow_right_outlined,
            size: 32,
          ),
          onTap: () async {
            setState(() {
              _isLoading = true;
            });

            await _getRentalUser(widget.rentalDetail.userId);
            if (widget.rentalDetail.isReviewCar == true) {
              await _getCarReview(widget.car!.id);
            }
            if (widget.rentalDetail.isReviewUser == true) {
              await _getUserReview(widget.rentalDetail.userId);
            }

            final navigator = Navigator.of(context);
            Navigator.of(context)
                .pushNamed(AppRoutes.RENTAL_DETAIL, arguments: {
              'rental': widget.rentalDetail,
              'car': widget.car,
              'currentUserId': widget.currentUserId,
              'rentalUser': _rentalUser,
              'carReview': _carReview,
              'userReview': _userReview,
            });

            setState(() {
              _isLoading = false;
            });
          },
        ),
        _isLoading
            ? LinearProgressIndicator(
                backgroundColor: Colors.transparent,
              )
            : Divider(),
      ],
    );
  }
}
