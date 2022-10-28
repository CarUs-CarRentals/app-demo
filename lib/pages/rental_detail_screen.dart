import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class RentalDetailScreen extends StatelessWidget {
  const RentalDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
              child: Image.network(
                "https://images.indianexpress.com/2017/05/google-maps-759.jpg",
                fit: BoxFit.cover,
              ),
            ),
            Container(
              padding: EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text("03/04/2022, 07:30 - 04/04/2022 13:00"),
                    ],
                  ),
                  Row(children: [
                    Text('R\$ 999,99'),
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
                "Rua Hermann Weege, 151 - Centro, Pomerode - SC, 89107-000, Brasil",
                style: const TextStyle(
                  fontFamily: 'RobotCondensed',
                  fontSize: 14,
                ),
              ),
              dense: true,
              trailing: ElevatedButton(
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
            ListTile(
              leading: Icon(
                Icons.directions_car,
                size: 24,
              ),
              title: Text(
                "Avalie o veículo",
                style: const TextStyle(
                    fontFamily: 'RobotCondensed',
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              dense: true,
              trailing: RatingBarIndicator(
                rating: 0,
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
