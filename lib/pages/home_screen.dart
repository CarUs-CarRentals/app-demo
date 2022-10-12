import 'dart:math';

import 'package:carshare/components/car_item.dart';
import 'package:carshare/data/dummy_cars_data.dart';
import 'package:carshare/models/car.dart';
import 'package:carshare/models/car_list.dart';
import 'package:carshare/models/place.dart';
import 'package:carshare/utils/location_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen();

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
    //_getCarDistance();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    final provider = Provider.of<CarList>(context);
    final List<Car> cars = provider.cars;

    return Scaffold(
      body: FutureBuilder<List<dynamic>>(
          future: Future.wait(
              [_getCurrentUserLocation()]), //_getCurrentUserLocation(),
          builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
            if (snapshot.hasData) {
              final myLocation = snapshot.data![0];
              print("localizacao: $myLocation");
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
                        print("id: ${cars[idx].id} - ${cars[idx].distance}");
                      });
                    }

                    final sortedCars = cars
                      ..sort(((item1, item2) =>
                          item1.distance.compareTo(item2.distance)));
                    final car = sortedCars[index];
                    return CarItem(car, myLocation);
                  });
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }
}
