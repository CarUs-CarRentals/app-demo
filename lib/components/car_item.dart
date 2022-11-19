import 'package:carshare/models/car.dart';
import 'package:carshare/models/place.dart';
import 'package:carshare/models/user.dart';
import 'package:carshare/models/user_list.dart';
import 'package:carshare/utils/location_util.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../utils/app_routes.dart';

class CarItem extends StatefulWidget {
  final Car car;
  final LatLng currentLocation;

  const CarItem(
    this.car,
    this.currentLocation, {
    Key? key,
  }) : super(key: key);

  @override
  State<CarItem> createState() => _CarItemState();
}

class _CarItemState extends State<CarItem> {
  String? carDistance = '';
  User? carUser;

  _getCarDistance() async {
    final myLocation = widget.currentLocation;

    final carLocation = PlaceLocation(
            latitude: widget.car.location.latitude,
            longitude: widget.car.location.longitude)
        .toLatLng();

    await LocationUtil.getDistance(myLocation, carLocation)
        .then((Map<String, dynamic> jsonString) {
      setState(() {
        carDistance = jsonString['text'];
      });
    });
  }

  @override
  void initState() {
    super.initState();
  }

  Future<void> _getCarHost(String userId) async {
    await Provider.of<UserList>(context, listen: false).loadUserById(userId);
    final provider = Provider.of<UserList>(context, listen: false);
    carUser = provider.userByID;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _getCarHost(widget.car.userId);
    _getCarDistance();
  }

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
                        Text(('widget.car.review').toString()),
                        const VerticalDivider(
                          width: 10,
                        ),
                        Text(
                          "99 Locações",
                        ),
                      ],
                    ),
                    VerticalDivider(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    Row(children: [
                      Text('R\$ ${widget.car.price}/dia'),
                    ])
                  ],
                ),
                Row(
                  children: [
                    const SizedBox(width: 6),
                    Icon(
                      Icons.pin_drop_outlined,
                      size: 15,
                      color: Colors.grey[500],
                    ),
                    Text(
                      carDistance!.isEmpty ? '' : '$carDistance de distância',
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
        arguments: {
          'car': widget.car,
          'user': carUser,
        },
      ),
      child: Column(
        children: [
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            elevation: 4,
            margin:
                const EdgeInsets.only(top: 5, left: 10, right: 10, bottom: 15),
            child: Column(children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                    ),
                    child: Image.network(
                      widget.car.imagesUrl[0].url,
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
