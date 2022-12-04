import 'package:brasil_fields/brasil_fields.dart';
import 'package:carshare/components/rental_tile.dart';
import 'package:carshare/data/store.dart';
import 'package:carshare/models/auth.dart';
import 'package:carshare/models/car.dart';
import 'package:carshare/models/user.dart';
import 'package:carshare/providers/cars.dart';
import 'package:carshare/models/rental.dart';
import 'package:carshare/models/review.dart';
import 'package:carshare/providers/rentals.dart';
import 'package:carshare/providers/users.dart';
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
import 'package:shimmer/shimmer.dart';

class RentalDetailScreen extends StatefulWidget {
  const RentalDetailScreen({Key? key}) : super(key: key);

  @override
  State<RentalDetailScreen> createState() => _RentalDetailScreenState();
}

class _RentalDetailScreenState extends State<RentalDetailScreen> {
  String _rentalAdress = '';
  bool _isLoading = false;
  bool _isMyCarRental = false;
  CarReview? _carReview;
  UserReview? _userReview;
  User? _carUser;

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
    if (_isLoading) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _getCarHost(String userId) async {
    _carUser =
        await Provider.of<Users>(context, listen: false).loadUserById(userId);
    // ignore: use_build_context_synchronously
    //final provider = Provider.of<Users>(context, listen: false);
    //_carUser = provider.userByID;
  }

  _openReviewForm(Rental rental, bool isReviewCar) {
    return Navigator.of(context).pushNamed(AppRoutes.REVIEW_FORM, arguments: {
      'rental': rental,
      'reviewCar': isReviewCar,
    });
  }

  @override
  Widget build(BuildContext context) {
    //final rentalDetail = ModalRoute.of(context)?.settings.arguments as Rental;
    final arg = ModalRoute.of(context)?.settings.arguments as Map;
    final car = arg['car'] as Car;
    final rental = arg['rental'] as Rental;
    final currentUserId = arg['currentUserId'] as String;
    final rentalUser = arg['rentalUser'] as User;

    if (rental.isReviewCar == true) {
      try {
        final carReview = arg['carReview'] as CarReview;
        _carReview = carReview;
      } catch (e) {}
      print("NOTA carro: ${_carReview?.rate}");
    }

    if (rental.isReviewUser == true) {
      try {
        final userReview = arg['userReview'] as UserReview;
        _userReview = userReview;
      } catch (e) {}
      print("NOTA motorista: ${_userReview?.rate}");
    }

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
              _isMyCarRental
                  ? ListTile(
                      visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                      contentPadding: EdgeInsets.symmetric(horizontal: 6),
                      leading: CircleAvatar(
                        radius: 30.0,
                        backgroundImage:
                            NetworkImage(rentalUser.profileImageUrl),
                        backgroundColor: Colors.transparent,
                      ),
                      title: Text(
                        "Motorista",
                        style: const TextStyle(
                          fontFamily: 'RobotCondensed',
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        "${rentalUser.fullName}",
                        style: const TextStyle(
                          fontFamily: 'RobotCondensed',
                          fontSize: 14,
                        ),
                      ),
                      trailing: Icon(
                        Icons.keyboard_arrow_right_outlined,
                        size: 32,
                      ),
                      onTap: () {
                        Navigator.of(context).pushNamed(
                          AppRoutes.PROFILE_USER,
                          arguments: rentalUser,
                        );
                      },
                    )
                  : ListTile(
                      visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                      contentPadding: EdgeInsets.symmetric(horizontal: 6),
                      leading: CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage(car.imagesUrl[0].url),
                      ),
                      title: Text(
                        "Veículo",
                        style: const TextStyle(
                          fontFamily: 'RobotCondensed',
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        "${car.shortDescription}",
                        style: const TextStyle(
                          fontFamily: 'RobotCondensed',
                          fontSize: 14,
                        ),
                      ),
                      trailing: Icon(
                        Icons.keyboard_arrow_right_outlined,
                        size: 32,
                      ),
                      onTap: () async {
                        setState(() {
                          _isLoading = true;
                        });
                        await _getCarHost(car.userId);
                        Navigator.of(context).pushNamed(
                          AppRoutes.CAR_DETAIL,
                          arguments: {
                            'car': car,
                            'user': _carUser,
                            'viewMode': true,
                          },
                        );
                        setState(() {
                          _isLoading = false;
                        });
                      },
                    ),
              _isLoading
                  ? LinearProgressIndicator(
                      backgroundColor: Colors.transparent,
                    )
                  : Center(),
              ListTile(
                //contentPadding: EdgeInsets.symmetric(horizontal: 0),
                visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                leading: Text(
                    '${DateFormat('dd/MM/yyyy • H:mm', 'pt_BR').format(rental.rentalDate)} ${DateFormat('- dd/MM/yyyy • H:mm', 'pt_BR').format(rental.returnDate)}'),
                trailing: Text(UtilBrasilFields.obterReal(rental.price)),
              ),
              Divider(
                height: 0,
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
              ),
              Divider(),
              _isMyCarRental
                  ? ListTile(
                      enabled: rental.status != RentalStatus.RENTED
                          ? false
                          : rental.isReviewUser == true
                              ? false
                              : true,
                      leading: Icon(
                        Icons.person_rounded,
                        size: 24,
                      ),
                      title: Text(
                        rental.isReviewUser == true
                            ? " Motorista avaliado"
                            : "Avalie o motorista",
                        style: const TextStyle(
                            fontFamily: 'RobotCondensed',
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      dense: true,
                      trailing: RatingBarIndicator(
                        rating: rental.isReviewUser == false
                            ? 0
                            : _userReview?.rate == null
                                ? 0
                                : _userReview!.rate, //carReview.rate,
                        itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        itemCount: 5,
                        itemSize: 16.0,
                      ),
                      onTap: () => _openReviewForm(rental, false),
                    )
                  : ListTile(
                      enabled: rental.status != RentalStatus.RENTED
                          ? false
                          : rental.isReviewCar == true
                              ? false
                              : true,
                      leading: Icon(
                        Icons.directions_car,
                        size: 24,
                      ),
                      title: Text(
                        rental.isReviewCar == false
                            ? "Avalie o veículo"
                            : "Veículo avaliado",
                        style: const TextStyle(
                            fontFamily: 'RobotCondensed',
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      dense: true,
                      trailing: RatingBarIndicator(
                        rating: rental.isReviewCar == false
                            ? 0
                            : _carReview?.rate == null
                                ? 0
                                : _carReview!.rate, //carReview.rate,
                        itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        itemCount: 5,
                        itemSize: 16.0,
                      ),
                      onTap: () => _openReviewForm(rental, true),
                    ),
              SizedBox(
                height: 8,
              ),
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
