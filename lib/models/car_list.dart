import 'dart:convert';

import 'package:carshare/data/dummy_cars_data.dart';
import 'package:carshare/exceptions/http_exceptions.dart';
import 'package:carshare/models/car.dart';
import 'package:carshare/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CarList with ChangeNotifier {
  final _baseUrl = Constants.CAR_BASE_URL;

  // final String _token;
  // final String _userId;
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

  // Future<void> saveCar(Map<String, Object> data) {
  //   bool hasId = data['id'] != null;

  // final car = Car(
  //   id: hasId ? data['id'] as String : Random().nextDouble().toString(),
  // );

  // if (hasId) {
  //   return updateCar(car);
  // } else {
  //  return addCar(car);
  //}
  //}

  Future<void> addCar(Car car) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/create'),
      body: jsonEncode(
        {
          "brand": car.brand,
          "model": car.model,
          "year": car.year,
          "plate": car.plate,
        },
      ),
    );
    // final id = jsonDecode(response.body)['name'];
    // print(jsonDecode(response.body));
    // _cars.add(Product(
    //   id: id,
    //   name: product.name,
    //   description: product.description,
    //   price: product.price,
    //   imageUrl: product.imageUrl,
    // ));
    notifyListeners();
  }

  Future<void> updateCar(Car car) async {
    int index = _cars.indexWhere((p) => p.id == car.id);

    if (index >= 0) {
      await http.patch(
        Uri.parse('$_baseUrl/${car.id}'),
        body: jsonEncode(
          {
            "brand": car.brand,
            "model": car.model,
            "year": car.year,
            "plate": car.plate,
          },
        ),
      );
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
