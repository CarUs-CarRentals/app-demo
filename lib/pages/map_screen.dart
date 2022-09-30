import 'dart:ui';

import 'package:carshare/models/place.dart';
import 'package:custom_marker/marker_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  MapScreen({
    this.initialLocation = const PlaceLocation(
      latitude: -26.9069,
      longitude: -49.0760,
    ),
    this.isReadOnly = false,
    this.imageUrlMarker =
        "https://d1nhio0ox7pgb.cloudfront.net/_img/g_collection_png/standard/256x256/question.png",
  });

  final PlaceLocation initialLocation;
  final bool isReadOnly;
  final String imageUrlMarker;

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? _pickedPosition;
  BitmapDescriptor _marker = BitmapDescriptor.defaultMarker;

  void _selectPosition(LatLng position) {
    setState(() {
      _pickedPosition = position;
    });
  }

  _getIconMarker() async {
    final result = await MarkerIcon.downloadResizePictureCircle(
            widget.imageUrlMarker,
            size: 120,
            addBorder: true,
            borderColor: Colors.white,
            borderSize: 15)
        .then((BitmapDescriptor bitmap) {
      setState(() {
        _marker = bitmap;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _getIconMarker();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Localização'),
        actions: [
          if (!widget.isReadOnly)
            IconButton(
                onPressed: _pickedPosition == null
                    ? null
                    : () {
                        Navigator.of(context).pop(_pickedPosition);
                      },
                icon: Icon(Icons.check))
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(
            widget.initialLocation.latitude,
            widget.initialLocation.longitude,
          ),
          zoom: 15,
        ),
        onTap: widget.isReadOnly ? null : _selectPosition,
        markers: _pickedPosition == null
            ? {
                Marker(
                  markerId: MarkerId('p1'),
                  position: LatLng(
                    widget.initialLocation.latitude,
                    widget.initialLocation.longitude,
                  ),
                  icon: _marker,
                ),
              }
            : {
                Marker(
                  markerId: MarkerId('p1'),
                  position: _pickedPosition!,
                ),
              },
      ),
    );
  }
}
