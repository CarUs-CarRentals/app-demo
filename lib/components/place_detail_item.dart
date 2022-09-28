import 'package:carshare/models/place.dart';
import 'package:carshare/pages/map_screen.dart';
import 'package:carshare/utils/location_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class PlaceDetailItem extends StatefulWidget {
  //-26.9069, -49.0760
  PlaceDetailItem({Key? key}) : super(key: key);

  @override
  State<PlaceDetailItem> createState() => _PlaceDetailItemState();
}

class _PlaceDetailItemState extends State<PlaceDetailItem> {
  Future<void> _selectOnMap() async {
    final LatLng selectedPosition =
        await Navigator.of(context).push(MaterialPageRoute(
      fullscreenDialog: true,
      builder: (ctx) => MapScreen(
        isReadOnly: true,
        initialLocation: PlaceLocation(latitude: -26.9069, longitude: -49.0760),
      ),
    ));

    if (selectedPosition == null) return;

    print(selectedPosition.latitude);
  }

  @override
  Widget build(BuildContext context) {
    //final locData = Location().getLocation();
    /*final PlaceLocation demoLocal =
        PlaceLocation(latitude: -26.9069, longitude: -49.0760);
    Future<String> _getAddress() async {
      return await LocationUtil.getAddressFrom(demoLocal.toLatLng());
    }*/

    //print('teste: $_getAddress');
    return ListTile(
      leading: Icon(
        Icons.pin_drop_rounded,
        size: 24,
      ),
      title: Text(
        "R. São Paulo, 1147 - Victor Konder, Blumenau - SC, 89012-001, Brazil",
        style: const TextStyle(
          fontFamily: 'RobotCondensed',
          fontSize: 14,
        ),
      ),
      trailing: Icon(
        Icons.keyboard_arrow_right_outlined,
        size: 24,
      ),
      onTap: _selectOnMap,
    );
  }
}
