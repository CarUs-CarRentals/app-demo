import 'package:carshare/models/car.dart';
import 'package:carshare/models/place.dart';
import 'package:carshare/utils/location_util.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../utils/app_routes.dart';

class CarItemEdit extends StatefulWidget {
  final Car car;

  const CarItemEdit(
    this.car, {
    Key? key,
  }) : super(key: key);

  @override
  State<CarItemEdit> createState() => _CarItemState();
}

class _CarItemState extends State<CarItemEdit> {
  _bottomSection(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                widget.car.shortDescription,
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
                        const Icon(
                          Icons.star,
                          size: 16,
                        ),
                        Text((widget.car.review).toString()),
                        const VerticalDivider(
                          width: 10,
                        ),
                        Text(
                          "99 Locações",
                        ),
                      ],
                    ),
                  ],
                ),
                Divider(),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          style: TextButton.styleFrom(
                            textStyle: const TextStyle(fontSize: 16),
                            padding: EdgeInsets.symmetric(horizontal: 3),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            minimumSize: Size(50, 30),
                          ),
                          onPressed: () => Navigator.of(context).pushNamed(
                            AppRoutes.CAR_DETAIL,
                            arguments: widget.car,
                          ),
                          child: const Text('Visualizar'),
                        ),
                        VerticalDivider(
                          width: 10,
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                            textStyle: const TextStyle(fontSize: 16),
                            padding: EdgeInsets.symmetric(horizontal: 3),
                            minimumSize: Size(50, 30),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          onPressed: () {},
                          child: const Text('Editar'),
                        ),
                      ],
                    )
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
      child: Column(
        children: [
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            elevation: 4,
            margin:
                const EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 10),
            child: Column(children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                    ),
                    child: Image.network(
                      widget.car.imagesUrl.imageUrl[0],
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
              _bottomSection(context),
            ]),
          ),
        ],
      ),
    );
  }
}
