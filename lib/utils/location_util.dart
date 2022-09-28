import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:carshare/utils/constants.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationUtil {
  static String generateLocationPreviewImage({
    double? latitude,
    double? longitude,
  }) {
    return 'https://maps.googleapis.com/maps/api/staticmap?center=$latitude,$longitude&zoom=13&size=600x300&maptype=roadmap&markers=color:red%7Clabel:A%7C$latitude,$longitude&key=${Constants.GOOGLE_API_KEY}';
  }

  static Future<String> getAddressFrom(LatLng position) async {
    final url =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=${Constants.GOOGLE_API_KEY}';
    final response = await http.get(Uri.parse(url));
    print(jsonDecode(response.body)['results'][0]['formatted_address']);
    return jsonDecode(response.body)['results'][0]['formatted_address'];
  }
}
