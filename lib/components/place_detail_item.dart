import 'package:carshare/models/place.dart';
import 'package:carshare/pages/map_screen.dart';
import 'package:carshare/utils/location_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class PlaceDetailItem extends StatefulWidget {
  double carLatitude;
  double carlongitude;
  String carAddress;
  String imageUrl;

  PlaceDetailItem(
      this.carLatitude, this.carlongitude, this.carAddress, this.imageUrl,
      {Key? key})
      : super(key: key);

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
        initialLocation: PlaceLocation(
            latitude: widget.carLatitude, longitude: widget.carlongitude),
        imageUrlMarker: widget.imageUrl,
      ),
    ));

    if (selectedPosition == null) return;
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        Icons.pin_drop_rounded,
        size: 24,
      ),
      title: Text(
        widget.carAddress,
        style: const TextStyle(
          fontFamily: 'RobotCondensed',
          fontSize: 14,
        ),
      ),
      trailing: Icon(
        Icons.keyboard_arrow_right_outlined,
        size: 32,
      ),
      onTap: _selectOnMap,
    );
  }
}
