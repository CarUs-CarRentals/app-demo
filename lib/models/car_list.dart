import 'dart:convert';
import 'dart:io';

import 'package:carshare/data/dummy_cars_data.dart';
import 'package:carshare/data/store.dart';
import 'package:carshare/exceptions/http_exceptions.dart';
import 'package:carshare/models/car.dart';
import 'package:carshare/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CarList with ChangeNotifier {
  final _baseUrl = Constants.CAR_BASE_URL;

  // final String _token;
  // final String _userId;
  String? _refreshToken;
  final List<Car> _cars = dummyCars; //[];

  List<Car> get cars => [..._cars];
  // List<Car> get favoriteItems =>
  //     _cars.where((car) => car.isFavorite).toList();

  // CarList([
  //   this._token = '',
  //   this._userId = '',
  //   this._cars = const [],
  // ]);

  int get carsCount {
    return _cars.length;
  }

  Future<void> loadCars() async {
    _cars.clear();

    final response = await http.get(Uri.parse('$_baseUrl/all'));
    if (response.body == 'null') return;

    // final favResponse = await http.get(
    //   Uri.parse(
    //     '${Constants.USER_FAVORITES_URL}/$_userId.json?auth=$_token',
    //   ),
    // );

    // Map<String, dynamic> favData =
    //     favResponse.body == 'null' ? {} : jsonDecode(favResponse.body);

    // Map<String, dynamic> data = jsonDecode(response.body);
    // data.forEach((productId, productData) {
    //   //final isFavorite = favData[carId] ?? false;
    //   _cars.add(
    //     Product(
    //       id: productId,
    //       name: productData['name'],
    //       description: productData['description'],
    //       price: productData['price'],
    //       imageUrl: productData['imageUrl'],
    //       isFavorite: isFavorite,
    //     ),
    //   );
    // });
    notifyListeners();
  }

  void saveCar(Map<String, Object> data) {
    bool hasId = data['id'] != null;

    final car = Car(
      id: hasId ? data['id'] as int : 0,
      brand: data['brand'] as String,
      doors: data['doors'] as int,
      fuel: data['fuel'] as CarFuel,
      gearShift: data['gearShift'] as CarGearShift,
      plate: data['plate'] as String,
      seats: data['seats'] as int,
      trunk: data['trunk'] as int,
      year: data['year'] as int,
      userId: data['userId'] as String,
      category: data['category'] as CarCategory,
      model: data['model'] as String,
      imagesUrl: data['imagesUrl'] as List<CarImages>,
      price: data['price'] as double,
      location: data['location'] as CarLocation,
      description: data['description'] as String,
    );

    if (hasId) {
      updateCar(car);
    } else {
      addCar(car);
    }
  }

  Future<void> addCar(Car car) async {
    final userData = await Store.getMap('userData');
    _refreshToken = userData['refreshToken'];

    final imageUrlJsonText = jsonEncode(car.imagesUrl,
        toEncodable: (Object? value) => value is CarImages
            ? CarImages.toJson(value)
            : throw UnsupportedError('Cannot convert to JSON: $value'));

    print(imageUrlJsonText);

    final response = await http.post(
      Uri.parse('$_baseUrl/create'),
      headers: {
        "content-type": "application/json",
        "accept": "application/json",
        HttpHeaders.authorizationHeader: "Bearer $_refreshToken",
      },
      body: jsonEncode({
        "user": car.userId,
        "brand": car.brand,
        "model": car.model,
        "year": car.year,
        "plate": car.plate,
        "fuel": car.fuel.name,
        "gearShift": car.gearShift.name,
        "category": car.category.name,
        "doors": car.doors,
        "seats": car.seats,
        "trunk": car.trunk,
        "latitude": car.location.latitude,
        "longitude": car.location.longitude,
        "imageUrl": "fahsufhklajshfklahslkfh",
        "description": car.description,
        "address": car.location.address,
        "price": car.price,
        "carImages": imageUrlJsonText,
      }),
    );
    print(response.body);
    _cars.add(car);

    notifyListeners();
  }

  Future<void> updateCar(Car car) async {
    int index = _cars.indexWhere((p) => p.id == car.id);

    if (index >= 0) {
      // await http.patch(
      //   Uri.parse('$_baseUrl/${car.id}'),
      //   body: jsonEncode(
      //     {
      //       "brand": car.brand,
      //       "model": car.model,
      //       "year": car.year,
      //       "plate": car.plate,
      //     },
      //   ),
      // );
      _cars[index] = car;
      notifyListeners();
    }
  }

  Future<void> removeCar(Car car) async {
    int index = _cars.indexWhere((p) => p.id == car.id);

    if (index >= 0) {
      final car = _cars[index];

      _cars.remove(car);
      notifyListeners();

      final response = await http.delete(
        Uri.parse('$_baseUrl/${car.id}'),
      );

      if (response.statusCode >= 400) {
        _cars.insert(index, car);
        notifyListeners();
        throw HttpException(
          msg: "Não foi possivel excluir o carro.",
          statusCode: response.statusCode,
        );
      }
    }
  }
}
