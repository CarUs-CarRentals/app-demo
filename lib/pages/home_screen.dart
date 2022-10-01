import 'package:carshare/components/car_item.dart';
import 'package:carshare/data/dummy_cars_data.dart';
import 'package:carshare/models/car.dart';
import 'package:carshare/models/place.dart';
import 'package:carshare/utils/location_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen();

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  LatLng? _myLocation;

  Future<void> _getCurrentUserLocation() async {
    final locData = await Location().getLocation();

    setState(() {
      _myLocation =
          LatLng(locData.latitude as double, locData.longitude as double);
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    print(_myLocation);
    return Scaffold(
      body: FutureBuilder(
          future: _myLocation == null ? _getCurrentUserLocation() : null,
          builder: (ctx, snapshot) {
            return _myLocation != null
                ? ListView.builder(
                    itemCount: dummyCars.length,
                    itemBuilder: (context, index) =>
                        CarItem(dummyCars[index], _myLocation!),
                  )
                : Container();
          }),
    );
  }
}
