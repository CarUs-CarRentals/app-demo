import 'dart:ui';

import 'package:carshare/models/place.dart';
import 'package:flutter/material.dart';
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
  });

  final PlaceLocation initialLocation;
  final bool isReadOnly;

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? _pickedPosition;

  void _selectPosition(LatLng position) {
    setState(() {
      _pickedPosition = position;
    });
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
          zoom: 13,
        ),
        onTap: widget.isReadOnly ? null : _selectPosition,
        markers: _pickedPosition == null
            ? {}
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
