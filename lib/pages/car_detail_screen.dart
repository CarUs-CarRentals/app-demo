import 'package:carshare/models/car.dart';
import 'package:carshare/utils/app_routes.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class CarDetailScreen extends StatelessWidget {
  const CarDetailScreen({Key? key}) : super(key: key);

  void _selectCarReview(BuildContext context) {
    Navigator.of(context).pushNamed(AppRoutes.CAR_REVIEW);
  }

  _titleSection(
      BuildContext context, String title, int review, int year, int carHost) {
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
          child: Row(
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
                  Text(
                      'De: ${carHost == 1 ? 'Igor Felipe Ponchielli' : (carHost).toString()}'),
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
          Divider(),
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
            Icon(icon), // <-- Icon
            Text(label), // <-- Text
          ],
        ),
      ),
    );
  }

  _localDataSection(BuildContext context) {}

  _moreDetailSection(BuildContext context) {}

  _rentalSection(BuildContext context) {}

  @override
  Widget build(BuildContext context) {
    final car = ModalRoute.of(context)!.settings.arguments as Car;

    return Scaffold(
      appBar: AppBar(
        title: Text(car.shortDescription),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: 200,
              width: double.infinity,
              child: Image.network(
                car.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            _titleSection(
              context,
              car.shortDescription,
              car.review,
              car.year,
              car.userId,
            ),
            _optionalCarSection(
              context,
              car.gearShiftText,
              car.categoryText,
              car.fuelText,
              car.doors,
              car.seats,
            ),
            TextButton(
              onPressed: () => _selectCarReview(context),
              child: Text(
                'Avaliações do Carro',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
