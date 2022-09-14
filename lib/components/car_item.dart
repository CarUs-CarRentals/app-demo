import 'package:carshare/models/car.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../utils/app_routes.dart';

class CarItem extends StatelessWidget {
  final Car car;
  const CarItem(
    this.car, {
    Key? key,
  }) : super(key: key);

  _bottomSection(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                car.shortDescription,
                textAlign: TextAlign.left,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SizedBox(width: 6),
                        Icon(
                          Icons.star,
                          size: 16,
                        ),
                        Text((car.review).toString()),
                        VerticalDivider(
                          width: 10,
                        ),
                        Text(
                          "99 Avaliações",
                        ),
                      ],
                    ),
                    VerticalDivider(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    Row(children: [
                      Text('R\$ ${car.price}/dia'),
                    ])
                  ],
                ),
                Row(
                  children: [
                    SizedBox(width: 6),
                    Icon(
                      Icons.pin_drop_outlined,
                      size: 15,
                      color: Colors.grey[500],
                    ),
                    Text(
                      '99 km de distancia',
                      textScaleFactor: 0.9,
                      style: TextStyle(color: Colors.grey[500]),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.of(context).pushNamed(
        AppRoutes.CAR_DETAIL,
        arguments: car,
      ),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 4,
        margin: const EdgeInsets.all(10),
        child: Column(children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
                child: Image.network(
                  car.imageUrl,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              // Positioned(
              //   right: 10,
              //   bottom: 20,
              //   child: Container(
              //     width: 300,
              //     color: Colors.black54,
              //     padding: EdgeInsets.symmetric(
              //       vertical: 5,
              //       horizontal: 20,
              //     ),
              //     child: Text(
              //       car.shortDescription,
              //       style: TextStyle(
              //         fontSize: 26,
              //         color: Colors.white,
              //       ),
              //       softWrap: true,
              //       overflow: TextOverflow.fade,
              //     ),
              //   ),
              // )
            ],
          ),
          _bottomSection(context),
          // Padding(
          //   padding: EdgeInsets.all(20),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceAround,
          //     children: [
          //       Row(
          //         children: [
          //           Icon(Icons.star),
          //           SizedBox(width: 6),
          //           Text((car.review).toString()),
          //         ],
          //       ),
          //       Row(
          //         children: [
          //           SizedBox(width: 6),
          //           Text('R\$ ${car.price}/dia'),
          //         ],
          //       ),
          //     ],
          //   ),
          // )
        ]),
      ),
    );
  }
}
