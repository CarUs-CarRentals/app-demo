import 'dart:convert';
import 'dart:io';

import 'package:carshare/data/store.dart';
import 'package:carshare/exceptions/http_exceptions.dart';
import 'package:carshare/models/auth.dart';
import 'package:carshare/models/car.dart';
import 'package:carshare/models/rental.dart';
import 'package:carshare/providers/cars.dart';
import 'package:carshare/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Rentals with ChangeNotifier {
  final _baseUrl = Constants.RENTAL_BASE_URL;

  // final String _token;
  // final String _userId;
  String? _refreshToken;
  final List<Rental> _rentalFromUser = [];
  final List<Rental> _rentalFromCar = [];
  final List<Rental> _rentals = [];

  List<Rental> get rentals => [..._rentals];
  List<Rental> get rentalsFromUser => [..._rentalFromUser];
  List<Rental> get rentalsFromCar => [..._rentalFromCar];

  // List<Car> get favoriteItems =>
  //     _cars.where((car) => car.isFavorite).toList();

  // Rentals([
  //   this._token = '',
  //   this._userId = '',
  //   this._cars = const [],
  // ]);

  int get rentalsCount {
    return _rentals.length;
  }

  int get rentalsByUserCount {
    return _rentalFromUser
        .where((element) =>
            element.status != RentalStatus.RENTED &&
            element.status != RentalStatus.REFUSED)
        .length;
  }

  Future<void> loadRentals() async {
    final userData = await Store.getMap('userData');
    _refreshToken = userData['refreshToken'];

    _rentals.clear();

    final response = await http.get(
      Uri.parse('$_baseUrl/all'),
      headers: {
        "content-type": "application/json",
        "accept": "application/json",
        HttpHeaders.authorizationHeader: "Bearer $_refreshToken",
      },
    );

    List<Map<String, dynamic>> map = [];

    //Map<String, dynamic> data = jsonDecode(response.body);
    String source = Utf8Decoder().convert(response.bodyBytes);
    map = List<Map<String, dynamic>>.from(jsonDecode(source));
    List<Map<String, dynamic>> data = map;
    data.forEach((rentalData) {
      RentalStatus rentalStatus = RentalStatus.values.firstWhere(
          (element) => element.name.toString() == rentalData['status']);

      _rentals.add(Rental(
        id: rentalData['id'],
        carId: rentalData['car'],
        car: null,
        userId: rentalData['user'],
        rentalDate: rentalData['rentalDate'],
        returnDate: rentalData['returnDate'],
        price: rentalData['price'],
        location: CarLocation(
          latitude: rentalData['latitude'],
          longitude: rentalData['longitude'],
          address: rentalData['address'],
        ),
        isReview: rentalData['isReview'],
        status: rentalStatus,
      ));
    });

    notifyListeners();
  }

  Future<void> saveRental(Map<String, Object> data) async {
    Map<String, dynamic> userLogged = await Auth().getLoggedUser();
    //Map<String, dynamic> userData;

    bool hasId = data['id'] != null;

    final rental = Rental(
      id: hasId ? data['id'] as int : 0,
      carId: data['carId'] as int,
      userId: userLogged['uuid'] as String,
      rentalDate: data['rentalDate'] as DateTime,
      returnDate: data['returnDate'] as DateTime,
      price: data['price'] as double,
      location: data['location'] as CarLocation,
      isReview: data['isReview'] as bool,
      status: data['status'] as RentalStatus,
    );

    if (hasId) {
      return updateRental(rental);
    } else {
      return addRental(rental);
    }
  }

  Future<void> addRental(Rental rental) async {
    final userData = await Store.getMap('userData');
    _refreshToken = userData['refreshToken'];

    final response = await http.post(
      Uri.parse('$_baseUrl/create'),
      headers: {
        "content-type": "application/json",
        "accept": "application/json",
        HttpHeaders.authorizationHeader: "Bearer $_refreshToken",
      },
      body: jsonEncode({
        "user": rental.userId,
        "car": rental.carId,
        "rentalDate": rental.rentalDate.toIso8601String(),
        "returnDate": rental.returnDate.toIso8601String(),
        "price": rental.price,
        "latitude": rental.location.latitude,
        "longitude": rental.location.longitude,
        "address": rental.location.address,
        "status": rental.status.name
      }),
    );

    if (response.statusCode < 400) {
      //_rentalFromUser.add(rental);
      notifyListeners();
    } else {
      throw HttpException(
        msg: "Não foi possível efetuar locação",
        statusCode: response.statusCode,
      );
    }
  }

  Future<void> updateRental(Rental rental) async {
    final userData = await Store.getMap('userData');
    _refreshToken = userData['refreshToken'];

    final response = await http.put(
      Uri.parse('$_baseUrl/${rental.id}'),
      headers: {
        "content-type": "application/json",
        "accept": "application/json",
        HttpHeaders.authorizationHeader: "Bearer $_refreshToken",
      },
      body: jsonEncode({
        "user": rental.userId,
        "car": rental.carId,
        "rentalDate": "${rental.rentalDate.toIso8601String()}",
        "returnDate": "${rental.returnDate.toIso8601String()}",
        "price": rental.price,
        "latitude": rental.location.latitude,
        "longitude": rental.location.longitude,
        "address": rental.location.address,
        "status": rental.status.name,
        "isReview": rental.isReview,
      }),
    );

    if (response.statusCode < 400) {
      notifyListeners();
    } else {
      throw HttpException(
        msg: "Não foi possível atualizar a locação",
        statusCode: response.statusCode,
      );
    }
  }

  Future<void> loadRentalsByUser() async {
    final userData = await Store.getMap('userData');
    _refreshToken = userData['refreshToken'];

    _rentalFromUser.clear();

    final response = await http.get(
      Uri.parse('$_baseUrl/user'),
      headers: {
        "content-type": "application/json",
        "accept": "application/json",
        HttpHeaders.authorizationHeader: "Bearer $_refreshToken",
      },
    );

    List<Map<String, dynamic>> map = [];

    //Map<String, dynamic> data = jsonDecode(response.body);
    String source = Utf8Decoder().convert(response.bodyBytes);
    map = List<Map<String, dynamic>>.from(jsonDecode(source));

    print(jsonDecode(source));

    List<Map<String, dynamic>> data = map;
    for (var rentalData in data) {
      RentalStatus rentalStatus = RentalStatus.values.firstWhere(
          (element) => element.name.toString() == rentalData['status']);

      final car = await Cars().loadCarsById(rentalData['car']);

      _rentalFromUser.add(Rental(
        id: rentalData['id'],
        carId: rentalData['car'],
        car: car,
        userId: rentalData['user'],
        rentalDate: DateTime.parse(rentalData['rentalDate']),
        returnDate: DateTime.parse(rentalData['returnDate']),
        price: rentalData['price'],
        location: CarLocation(
          latitude: rentalData['latitude'],
          longitude: rentalData['longitude'],
          address: rentalData['address'],
        ),
        isReview: rentalData['isReview'],
        status: rentalStatus,
      ));
    }

    notifyListeners();
  }

  Future<void> loadRentalsByCar(int carId) async {
    final userData = await Store.getMap('userData');
    _refreshToken = userData['refreshToken'];

    _rentalFromCar.clear();

    final response = await http.get(
      Uri.parse('$_baseUrl/car/$carId'),
      headers: {
        "content-type": "application/json",
        "accept": "application/json",
        HttpHeaders.authorizationHeader: "Bearer $_refreshToken",
      },
    );

    List<Map<String, dynamic>> map = [];

    //Map<String, dynamic> data = jsonDecode(response.body);
    String source = Utf8Decoder().convert(response.bodyBytes);
    map = List<Map<String, dynamic>>.from(jsonDecode(source));

    print(jsonDecode(source));

    List<Map<String, dynamic>> data = map;
    data.forEach((rentalData) {
      RentalStatus rentalStatus = RentalStatus.values.firstWhere(
          (element) => element.name.toString() == rentalData['status']);

      _rentalFromCar.add(Rental(
        id: rentalData['id'],
        carId: rentalData['car'],
        userId: rentalData['user'],
        rentalDate: DateTime.parse(rentalData['rentalDate']),
        returnDate: DateTime.parse(rentalData['returnDate']),
        price: rentalData['price'],
        location: CarLocation(
          latitude: rentalData['latitude'],
          longitude: rentalData['longitude'],
          address: rentalData['address'],
        ),
        isReview: rentalData['isReview'],
        status: rentalStatus,
      ));
    });

    notifyListeners();
  }
}
