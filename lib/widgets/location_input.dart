import 'package:carshare/models/place.dart';
import 'package:carshare/pages/map_screen.dart';
import 'package:carshare/utils/location_util.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class LocationInput extends StatefulWidget {
  final Function onSelectLocation;
  //final LatLng latLngInitial;
  const LocationInput(this.onSelectLocation, {Key? key}) : super(key: key);

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  String? _previewImageUrl;
  LatLng? _latLngSelected;

  Future<void> _getCurrentUserLocation() async {
    final locData = await Location().getLocation();
    final staticMapImageUrl = LocationUtil.generateLocationPreviewImage(
      latitude: locData.latitude,
      longitude: locData.longitude,
    );

    setState(() {
      _previewImageUrl = staticMapImageUrl;
      _latLngSelected = LatLng(locData.latitude!, locData.longitude!);
    });

    _getStoredLocation();
  }

  Future<void> _setInitialLocation(LatLng latLngInitial) async {
    final staticMapImageUrl = LocationUtil.generateLocationPreviewImage(
      latitude: latLngInitial.latitude,
      longitude: latLngInitial.longitude,
    );

    setState(() {
      _previewImageUrl = staticMapImageUrl;
      _latLngSelected = LatLng(latLngInitial.latitude, latLngInitial.longitude);
    });

    _getStoredLocation();
  }

  Future<void> _selectOnMap() async {
    final locData = await Location().getLocation();
    final LatLng selectedPosition =
        await Navigator.of(context).push(MaterialPageRoute(
      fullscreenDialog: true,
      builder: (ctx) => MapScreen(
        initialLocation: PlaceLocation(
          latitude: locData.latitude!,
          longitude: locData.longitude!,
        ),
      ),
    ));

    if (selectedPosition == null) return;

    final staticMapImageUrl = LocationUtil.generateLocationPreviewImage(
      latitude: selectedPosition.latitude,
      longitude: selectedPosition.longitude,
    );

    setState(() {
      _previewImageUrl = staticMapImageUrl;
      _latLngSelected =
          LatLng(selectedPosition.latitude, selectedPosition.longitude);
    });

    _getStoredLocation();
  }

  _getStoredLocation() {
    print("_latLngSelected: {$_latLngSelected}");
    widget.onSelectLocation(_latLngSelected);
  }

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   if (widget.latLngInitial.latitude != 0 &&
  //       widget.latLngInitial.longitude != 0) {
  //     _setInitialLocation(widget.latLngInitial);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 170,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Colors.grey,
            ),
          ),
          child: _previewImageUrl == null
              ? const Text('Localização não informada!')
              : Image.network(
                  _previewImageUrl!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton.icon(
              icon: const Icon(Icons.location_on),
              label: const Text('Localização atual'),
              onPressed: _getCurrentUserLocation,
            ),
            TextButton.icon(
              icon: const Icon(Icons.map),
              label: const Text('Selecione no Mapa'),
              onPressed: _selectOnMap,
            ),
          ],
        )
      ],
    );
  }
}
