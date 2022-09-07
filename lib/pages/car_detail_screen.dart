import 'package:carshare/models/car.dart';
import 'package:carshare/utils/app_routes.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';

class CarDetailScreen extends StatefulWidget {
  const CarDetailScreen({Key? key}) : super(key: key);

  @override
  State<CarDetailScreen> createState() => _CarDetailScreenState();
}

class _CarDetailScreenState extends State<CarDetailScreen> {
  DateTime _selectedPickupDate = DateTime.now();
  DateTime _selectedReturnDate = DateTime.now();

  void _selectCarReview(BuildContext context) {
    Navigator.of(context).pushNamed(AppRoutes.CAR_REVIEW);
  }

  _showPickupDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedPickupDate = pickedDate;
        _selectedReturnDate = _selectedPickupDate;
      });
    });
  }

  _showReturnDatePicker() {
    showDatePicker(
      context: context,
      initialDate: _selectedPickupDate,
      firstDate: _selectedPickupDate,
      lastDate: _selectedPickupDate.add(const Duration(days: 30)),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedReturnDate = pickedDate;
      });
    });
  }

  _submitRental() {
    print('Alugar');
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
                      'De: ${carHost == 1 ? 'Proprietario' : (carHost).toString()}'),
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

  _localDataSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        children: [
          Row(
            children: <Widget>[
              Expanded(
                child: Text(_selectedPickupDate == null
                    ? 'Nenhuma data selecionada'
                    : '${DateFormat('dd/MM/y').format(_selectedPickupDate)}'),
              ),
              TextButton(
                onPressed: _showPickupDatePicker,
                child: Text(
                  'Data para pegar o veículo',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: Text(_selectedReturnDate == null
                    ? 'Nenhuma data selecionada'
                    : '${DateFormat('dd/MM/y').format(_selectedReturnDate)}'),
              ),
              TextButton(
                onPressed: _showReturnDatePicker,
                child: Text(
                  'Data para devolver o veículo',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  _descriptionSection(BuildContext context, String description) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      width: double.infinity,
      child: Column(
        children: [
          Row(
            children: const [
              Text(
                'Descrição do Veículo:',
                textAlign: TextAlign.left,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 30),
              )
            ],
          ),
          Text(
            description,
            textAlign: TextAlign.left,
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
            Divider(),
            _localDataSection(context),
            Divider(),
            _descriptionSection(context, car.description),
            Divider(),
            _InfoItem(
              Icons.reviews,
              'Avaliações',
              () => _selectCarReview(context),
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
