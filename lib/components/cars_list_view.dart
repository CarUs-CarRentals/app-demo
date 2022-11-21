import 'dart:math';

import 'package:carshare/components/car_item.dart';
import 'package:carshare/models/car.dart';
import 'package:carshare/providers/cars.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

class CarsListView extends StatefulWidget {
  final String titleList;
  const CarsListView({Key? key, required this.titleList}) : super(key: key);

  @override
  State<CarsListView> createState() => _CarsListViewState();
}

class _CarsListViewState extends State<CarsListView> {
  bool _isLoading = true;
  int? carDistance;

  Future<LatLng> _getCurrentUserLocation() async {
    final _locationData = await Location().getLocation();
    return LatLng(
        _locationData.latitude as double, _locationData.longitude as double);
  }

  int _calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return (1000 * 12742 * asin(sqrt(a))).round();
  }

  @override
  void initState() {
    super.initState();
    
    context.loaderOverlay.show();
    setState(() {
      _isLoading = context.loaderOverlay.visible;
    });

    Provider.of<Cars>(context, listen: false).loadCars().then((value) {
      setState(() {
        if (_isLoading) {
          context.loaderOverlay.hide();
        }
        setState(() {
          _isLoading = context.loaderOverlay.visible;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<Cars>(context);
    final List<Car> cars = provider.cars;

    return Scaffold(
      body: FutureBuilder<List<dynamic>>(
          future: Future.wait([_getCurrentUserLocation()]),
          builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
            if (snapshot.hasData) {
              final myLocation = snapshot.data![0];
              return ListView.builder(
                  itemCount: cars.length,
                  itemBuilder: (context, index) {
                    if (cars[index].distance == 0) {
                      cars.asMap().forEach((idx, value) {
                        final distance = _calculateDistance(
                            myLocation.latitude,
                            myLocation.longitude,
                            cars[idx].location.latitude,
                            cars[idx].location.longitude);

                        cars[idx].distance = distance;
                      });
                    }

                    final sortedCars = cars
                      ..sort(((item1, item2) =>
                          item1.distance.compareTo(item2.distance)));
                    final car = sortedCars[index];
                    return index == 0
                        ? Column(
                            children: [
                              Row(
                                children: [
                                  const Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                  ),
                                  Text(
                                    widget.titleList,
                                    textAlign: TextAlign.left,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                ],
                              ),
                              CarItem(car, myLocation),
                            ],
                          )
                        : CarItem(car, myLocation);
                  });
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }
}
