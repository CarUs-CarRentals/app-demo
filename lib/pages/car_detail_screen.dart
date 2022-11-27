import 'package:brasil_fields/brasil_fields.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:carshare/components/carousel_car.dart';
import 'package:carshare/components/place_detail_item.dart';
import 'package:carshare/components/rental_date_form.dart';
import 'package:carshare/data/store.dart';
import 'package:carshare/models/car.dart';
import 'package:carshare/models/rental.dart';
import 'package:carshare/models/review.dart';
import 'package:carshare/models/user.dart';
import 'package:carshare/providers/rentals.dart';
import 'package:carshare/providers/reviews.dart';
import 'package:carshare/providers/users.dart';
import 'package:carshare/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class CarDetailScreen extends StatefulWidget {
  @override
  State<CarDetailScreen> createState() => _CarDetailScreenState();
}

class _CarDetailScreenState extends State<CarDetailScreen> {
  final _formKey = GlobalKey<FormState>();
  final _formData = <String, Object>{};
  bool _isLoading = false;
  bool _isOnlyView = false;
  bool _validDateRange = true;
  List<CarReview>? _carReviews;
  final _timeNow = DateTime.now();
  DateTime? _rentalDate;
  DateTime? _returnDate;

  Future<void> _getCarReviews(int carId) async {
    await Provider.of<Reviews>(context, listen: false)
        .loadCarReviewsByCar(carId);
    final provider = Provider.of<Reviews>(context, listen: false);
    _carReviews = provider.carReviewsFromCar;

    print("_getCarReviews: ${_carReviews?.length}");
    //_carReviews = provider.carReviewsFromCar;
  }

  // void _selectCarReviews(BuildContext context, Car car) async {
  //   final navigator = Navigator.of(context);
  //   await _getCarReviews(car.id);

  //   navigator.pushNamed(
  //     AppRoutes.CAR_REVIEW,
  //     arguments: _carReviews,
  //   );
  // }

  void _selectOwnerProfile(BuildContext context, User carUser) {
    Navigator.of(context).pushNamed(
      AppRoutes.PROFILE_USER,
      arguments: carUser,
    );
  }

  void _onSelectRentalDate(DateTime pickupDate, DateTime returnDate) {
    _formData['rentalDate'] = pickupDate;
    _formData['returnDate'] = returnDate;
    _rentalDate = pickupDate;
    _returnDate = returnDate;
  }

  void _validateRentalDateRange() {
    _validDateRange = true;

    if (_rentalDate!.compareTo(_returnDate!) == 0) {
      showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                title: Text('Ocorreu um erro!'),
                content: Text("A data inicial e final não podem ser iguais"),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'OK'),
                    child: const Text('OK'),
                  ),
                ],
              ));
      _validDateRange = false;
      return;
    }

    if (_rentalDate!.compareTo(DateTime.now()) < 0) {
      showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                title: Text('Ocorreu um erro!'),
                content: Text("A data inicial é inválida"),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'OK'),
                    child: const Text('OK'),
                  ),
                ],
              ));
      _validDateRange = false;
      return;
    }

    if (_rentalDate!.compareTo(_returnDate!) > 0) {
      showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                title: Text('Ocorreu um erro!'),
                content:
                    Text("A data final da locação é inferior a data inicial"),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'OK'),
                    child: const Text('OK'),
                  ),
                ],
              ));
      print("rentalDate is after returnDate");
      _validDateRange = false;
      return;
    }
  }

  Future<void> _submitRental(Car car) async {
    _formData['carId'] = car.id;
    //_formData['userId'] = currentUser.id;
    _formData['price'] =
        _calcRentalPrice(car.price, _returnDate!, _rentalDate!);
    _formData['location'] = car.location;
    _formData['status'] = RentalStatus.PENDING;
    _formData['isReview'] = false;

    _validateRentalDateRange();

    if (!_validDateRange) return;

    print(_formData['rentalDate'].toString());
    print(_formData['returnDate'].toString());
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: Text("Finalizar Locação"),
            content: RichText(
              text: TextSpan(
                style: Theme.of(context).textTheme.bodyLarge,
                children: <TextSpan>[
                  TextSpan(
                    text: "Período de locação:",
                  ),
                  TextSpan(
                    text:
                        "\n${DateFormat('MMM dd • H:mm', 'pt_BR').format(_rentalDate!)} ${DateFormat('- MMM dd • H:mm', 'pt_BR').format(_returnDate!)}",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  TextSpan(
                    text: "\n\nValor total estimado da locação:",
                  ),
                  TextSpan(
                    text:
                        "\n${UtilBrasilFields.obterReal(_calcRentalPrice(car.price, _returnDate!, _rentalDate!))}",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  TextSpan(
                    text: "\n\nDeseja confirmar seu pedido de locação?",
                  )
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context, 'Cancelar');
                },
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(context, 'Confirmar');
                  try {
                    context.loaderOverlay.show();
                    setState(() {
                      _isLoading = context.loaderOverlay.visible;
                    });
                    await Provider.of<Rentals>(
                      context,
                      listen: false,
                    ).saveRental(_formData);
                    await Provider.of<Rentals>(context, listen: false)
                        .loadRentalsByUser();
                    Navigator.of(context).pop();
                  } catch (error) {
                    await showDialog<void>(
                        context: context,
                        builder: (ctx) => AlertDialog(
                              title: Text('Ocorreu um erro!'),
                              content: Text(error.toString()),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context, 'OK');
                                  },
                                  child: const Text('OK'),
                                ),
                              ],
                            ));
                  } finally {
                    if (_isLoading) {
                      context.loaderOverlay.hide();
                    }
                    setState(() {
                      _isLoading = context.loaderOverlay.visible;
                    });
                  }
                },
                child: const Text('Confirmar'),
              ),
            ],
          );
        });
  }

  _titleSection(
    BuildContext context,
    String title,
    double review,
    int year,
    String carHost,
  ) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 20, left: 20),
          child: carHost == ""
              ? Shimmer.fromColors(
                  baseColor: Theme.of(context).colorScheme.onBackground,
                  highlightColor: Colors.grey,
                  child: Container(
                    width: double.infinity,
                    height: 16,
                    color: Colors.white.withOpacity(0.8),
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      children: [
                        RatingBarIndicator(
                          rating: review.toDouble(),
                          itemBuilder: (context, _) => Icon(
                            Icons.star,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          itemCount: 5,
                          itemSize: 16.0,
                        )
                      ],
                    ),
                    VerticalDivider(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    Row(
                      children: [
                        SizedBox(width: 6),
                        Text((year).toString()),
                      ],
                    ),
                    VerticalDivider(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    Row(
                      children: [
                        SizedBox(width: 6),
                        Text('De: $carHost'),
                      ],
                    ),
                  ],
                ),
        )
      ],
    );
  }

  _optionalCarSection(BuildContext context, String gearShift, String category,
      String fuel, int doors, int seats) {
    return LayoutBuilder(builder: (ctx, constraints) {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _optionalIcon(
                  constraints.maxWidth * 0.2,
                  Icons.settings,
                  gearShift,
                ),
                _optionalIcon(
                  constraints.maxWidth * 0.2,
                  Icons.category,
                  category,
                ),
                _optionalIcon(
                  constraints.maxWidth * 0.2,
                  Icons.local_gas_station,
                  fuel,
                ),
                _optionalIcon(
                  constraints.maxWidth * 0.2,
                  Icons.sensor_door_sharp,
                  '${doors.toString()} portas',
                ),
                _optionalIcon(
                  constraints.maxWidth * 0.2,
                  Icons.event_seat,
                  '${seats.toString()} assentos',
                ),
              ],
            ),
          ),
        ],
      );
    });
  }

  _optionalIcon(double width, IconData icon, String label) {
    return SizedBox(
      width: width,
      child: InkWell(
        onTap: null,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              icon,
              color: Colors.black26,
            ), // <-- Icon
            Text(
              label,
              style: TextStyle(color: Colors.black26),
            ), // <-- Text
          ],
        ),
      ),
    );
  }

  _descriptionSection(BuildContext context, String description) {
    return Container(
      width: double.infinity,
      child: Column(
        children: [
          Row(
            children: const [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
              ),
              Text(
                'Descrição do Veículo:',
                textAlign: TextAlign.left,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.symmetric(
              vertical: 5,
            ),
            child: Row(children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
              ),
              Flexible(
                child: Text(
                  description,
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 14),
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _InfoItem(IconData icon, String label, VoidCallback onTap) {
    return ListTile(
      leading: Icon(
        icon,
        size: 24,
      ),
      title: Text(
        label,
        style: const TextStyle(
          fontFamily: 'RobotCondensed',
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
      trailing: Icon(
        Icons.keyboard_arrow_right_outlined,
        size: 32,
      ),
      onTap: onTap,
    );
  }

  double _calcRentalPrice(
      double carPrice, DateTime finalDate, DateTime initDate) {
    final Duration differenceRentalDates;
    final double estimateFinalPrice;

    differenceRentalDates = finalDate.difference(initDate);
    estimateFinalPrice =
        carPrice * differenceRentalDates.inMilliseconds / 86400000;

    return estimateFinalPrice;
  }

  _rentalSection(BuildContext context, Car car) {
    //print("${_userConnected!.id} != ${userId}");

    return SizedBox(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(5),
            child: !_isOnlyView
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Text(
                            UtilBrasilFields.obterReal(car.price),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'por dia',
                            style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                        ],
                      ),
                      VerticalDivider(),
                      Row(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              _submitRental(car);
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Theme.of(context).colorScheme.primary,
                            ),
                            child: const Text(
                              'Continuar',
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ],
                      )
                    ],
                  )
                : Column(
                    children: [
                      Text(
                        '${UtilBrasilFields.obterReal(car.price)}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'por dia',
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<Users>(context, listen: false).loadProfile();
    _onSelectRentalDate(_timeNow, _timeNow);
  }

  @override
  Widget build(BuildContext context) {
    final arg = ModalRoute.of(context)?.settings.arguments as Map;
    final car = arg['car'] as Car;
    final carHost = arg['user'] as User;
    final viewMode = arg['viewMode'] as bool;

    _isOnlyView = viewMode;

    return Scaffold(
        appBar: AppBar(
          title: Text(car.shortDescription),
        ),
        body: LoaderOverlay(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                CarouselCar(
                    carsImages: [...car.imagesUrl].map((imageUrl) {
                      return Builder(
                        builder: (BuildContext context) {
                          return SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: Image.network(
                              imageUrl.url,
                              fit: BoxFit.cover,
                            ),
                          );
                        },
                      );
                    }).toList(),
                    imagesList:
                        car.imagesUrl.map((image) => image.url).toList()),

                _titleSection(
                  context,
                  car.shortDescription,
                  99,
                  car.year,
                  carHost.fullName,
                ),
                _optionalCarSection(
                  context,
                  Car.getGearShiftText(car.gearShift),
                  Car.getCategoryText(car.category),
                  Car.getFuelText(car.fuel),
                  car.doors,
                  car.seats,
                ),
                Divider(),
                _isOnlyView ? Center() : RentalDateForm(_onSelectRentalDate),
                //LocationInput(),
                PlaceDetailItem(car.location.latitude, car.location.longitude,
                    car.location.address, car.imagesUrl[0].url),
                Divider(),
                _descriptionSection(context, car.description),
                Divider(),
                ListTile(
                  enabled: !_isLoading,
                  leading: Icon(
                    Icons.reviews,
                    size: 24,
                  ),
                  title: Text(
                    'Avaliações',
                    style: const TextStyle(
                      fontFamily: 'RobotCondensed',
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
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
                    await _getCarReviews(car.id);
                    print("antes de entrar na tela: ${_carReviews?.length}");
                    Navigator.of(context).pushNamed(
                      AppRoutes.CAR_REVIEW,
                      arguments: {
                        'carReviews': _carReviews,
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
                    : Divider(
                        height: 4,
                      ),
                _InfoItem(
                  Icons.person,
                  'Visualizar proprietario do veículo',
                  () => _selectOwnerProfile(context, carHost),
                ),
                Divider(),
                _rentalSection(context, car),
              ],
            ),
          ),
        ));
  }
}
