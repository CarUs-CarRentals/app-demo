import 'package:carousel_slider/carousel_slider.dart';
import 'package:carshare/components/carousel_car.dart';
import 'package:carshare/components/place_detail_item.dart';
import 'package:carshare/components/rental_date_form.dart';
import 'package:carshare/data/store.dart';
import 'package:carshare/models/car.dart';
import 'package:carshare/models/user.dart';
import 'package:carshare/models/user_list.dart';
import 'package:carshare/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class CarDetailScreen extends StatefulWidget {
  @override
  State<CarDetailScreen> createState() => _CarDetailScreenState();
}

class _CarDetailScreenState extends State<CarDetailScreen> {
  void _selectCarReview(BuildContext context, Car car) {
    Navigator.of(context).pushNamed(
      AppRoutes.CAR_REVIEW,
      arguments: car,
    );
  }

  void _selectOwnerProfile(BuildContext context, User carUser) {
    Navigator.of(context).pushNamed(
      AppRoutes.PROFILE_USER,
      arguments: carUser,
    );
  }

  _submitRental() {
    print('Alugar');
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

  _rentalSection(BuildContext context, double carPrice, String userId) {
    //print("${_userConnected!.id} != ${userId}");

    return SizedBox(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(5),
            child: "_userConnected!.id" != userId
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Text(
                            'R\$ ${carPrice.toStringAsFixed(2)}',
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
                            onPressed: _submitRental,
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
                        'R\$ ${carPrice.toStringAsFixed(2)}',
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
    Provider.of<UserList>(context, listen: false).loadProfile();
  }

  @override
  Widget build(BuildContext context) {
    final arg = ModalRoute.of(context)?.settings.arguments as Map;
    final car = arg['car'] as Car;
    final carHost = arg['user'] as User;

    return Scaffold(
        appBar: AppBar(
          title: Text(car.shortDescription),
        ),
        body: SingleChildScrollView(
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
                  imagesList: car.imagesUrl.map((image) => image.url).toList()),

              _titleSection(
                context,
                car.shortDescription,
                99,
                car.year,
                carHost.fullName,
              ),
              _optionalCarSection(
                context,
                car.gearShiftText,
                car.categoryText,
                car.fuelText,
                car.doors,
                car.seats,
              ),
              Divider(),
              RentalDateForm(),
              //LocationInput(),
              PlaceDetailItem(car.location.latitude, car.location.longitude,
                  car.location.address, car.imagesUrl[0].url),
              Divider(),
              _descriptionSection(context, car.description),
              Divider(),
              _InfoItem(
                Icons.reviews,
                'Avaliações',
                () => _selectCarReview(context, car),
              ),
              Divider(),
              _InfoItem(
                Icons.person,
                'Visualizar proprietario do veículo',
                () => _selectOwnerProfile(context, carHost),
              ),
              Divider(),
              _rentalSection(context, car.price, car.userId),
            ],
          ),
        ));
  }
}
