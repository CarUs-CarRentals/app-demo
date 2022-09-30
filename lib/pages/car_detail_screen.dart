import 'package:carshare/components/place_detail_item.dart';
import 'package:carshare/components/rental_date_form.dart';
import 'package:carshare/models/car.dart';
import 'package:carshare/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class CarDetailScreen extends StatelessWidget {
  void _selectCarReview(BuildContext context, Car car) {
    Navigator.of(context).pushNamed(
      AppRoutes.CAR_REVIEW,
      arguments: car,
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
    int carHost,
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
                  Text('De: ${(carHost).toString()}'),
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
            Icon(icon), // <-- Icon
            Text(label), // <-- Text
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
      onTap: onTap,
    );
  }

  _rentalSection(BuildContext context, double carPrice) {
    return SizedBox(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Text(
                      'R\$ ${carPrice.toString()}',
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
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final car = ModalRoute.of(context)?.settings.arguments as Car;

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
            Divider(),
            RentalDateForm(),
            //LocationInput(),
            PlaceDetailItem(car.location.latitude, car.location.longitude,
                car.location.address, car.imageUrl),
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
              'Visualizar prorietario do veículo',
              () => null,
            ),
            Divider(),
            _rentalSection(context, car.price),
            // TextButton(
            //   onPressed: () => _selectCarReview(context),
            //   child: Text(
            //     'Avaliações do Carro',
            //     style: TextStyle(
            //       color: Theme.of(context).colorScheme.primary,
            //       fontWeight: FontWeight.bold,
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
