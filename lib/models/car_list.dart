import 'dart:convert';
import 'dart:io';

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
  final List<Car> _carsFromUser = [];
  final List<Car> _cars = [];

  List<Car> get cars => [..._cars];
  List<Car> get carsFromUser => [..._carsFromUser];

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
    final userData = await Store.getMap('userData');
    _refreshToken = userData['refreshToken'];

    _cars.clear();

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
    data.forEach((carData) {
      CarFuel fuel = CarFuel.values
          .firstWhere((element) => element.name.toString() == carData['fuel']);

      CarGearShift gearShift = CarGearShift.values.firstWhere(
          (element) => element.name.toString() == carData['gearShift']);

      CarCategory category = CarCategory.values.firstWhere(
          (element) => element.name.toString() == carData['category']);

      //Adiciona as imagens do carro no objeto CarImages
      List<CarImages> carImages = [];
      final List<dynamic> imagesData = carData['carImages'];
      for (var i = 0; i < imagesData.length; i++) {
        carImages.add(CarImages(url: carData['carImages'][i]['url']));
      }

      _cars.add(
        Car(
          id: carData['id'],
          brand: carData['brand'],
          userId: carData['user'],
          model: carData['model'],
          year: carData['year'],
          plate: carData['plate'],
          fuel: fuel,
          gearShift: gearShift,
          category: category,
          doors: carData['doors'],
          seats: carData['seats'],
          trunk: carData['trunk'],
          price: carData['price'],
          location: CarLocation(
              latitude: carData['latitude'],
              longitude: carData['longitude'],
              address: carData['address']),
          description: carData['description'],
          imagesUrl: carImages,
        ),
      );
    });

    notifyListeners();
  }

  Future<void> saveCar(Map<String, Object> data) {
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
      return updateCar(car);
    } else {
      return addCar(car);
    }
  }

  Future<void> addCar(Car car) async {
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
        "description": car.description,
        "address": car.location.address,
        "price": car.price,
        "carImages": car.imagesUrl
      }),
    );

    if (response.statusCode < 400) {
      _carsFromUser.add(car);
      notifyListeners();
    } else {
      throw HttpException(
        msg: "Não foi possível cadastrar o veículo",
        statusCode: response.statusCode,
      );
    }
  }

  Future<void> updateCar(Car car) async {
    int index = _carsFromUser.indexWhere((p) => p.id == car.id);

    if (index >= 0) {
      final userData = await Store.getMap('userData');
      _refreshToken = userData['refreshToken'];

      final response = await http.put(
        Uri.parse('$_baseUrl/${car.id}'),
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
          "description": car.description,
          "address": car.location.address,
          "price": car.price,
          "carImages": car.imagesUrl
        }),
      );

      if (response.statusCode < 400) {
        _carsFromUser[index] = car;
        notifyListeners();
      } else {
        throw HttpException(
          msg: "Não foi possível atualizar o veículo",
          statusCode: response.statusCode,
        );
      }
    }
  }

  Future<void> removeCar(Car car) async {
    int index = _carsFromUser.indexWhere((p) => p.id == car.id);

    if (index >= 0) {
      final myCar = _carsFromUser[index];
      _carsFromUser.remove(myCar);
      notifyListeners();

      final userData = await Store.getMap('userData');
      _refreshToken = userData['refreshToken'];

      print(car.id);

      final response = await http.delete(
        Uri.parse('$_baseUrl/${car.id}'),
        headers: {
          "content-type": "application/json",
          "accept": "application/json",
          HttpHeaders.authorizationHeader: "Bearer $_refreshToken",
        },
      );
      print(response.statusCode);

      if (response.statusCode >= 400) {
        _carsFromUser.insert(index, myCar);
        notifyListeners();
        throw HttpException(
            msg: "Não foi possível deletar o veículo",
            statusCode: response.statusCode);
      }
    }
  }

  Future<void> loadCarsByUser() async {
    _carsFromUser.clear();

    final userData = await Store.getMap('userData');
    _refreshToken = userData['refreshToken'];

    final response = await http.get(
      Uri.parse(_baseUrl),
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

    print(jsonDecode(response.body));

    data.forEach((carData) {
      CarFuel fuel = CarFuel.values
          .firstWhere((element) => element.name.toString() == carData['fuel']);

      CarGearShift gearShift = CarGearShift.values.firstWhere(
          (element) => element.name.toString() == carData['gearShift']);

      CarCategory category = CarCategory.values.firstWhere(
          (element) => element.name.toString() == carData['category']);

      //Adiciona as imagens do carro no objeto CarImages
      List<CarImages> carImages = [];
      final List<dynamic> imagesData = carData['carImages'];
      for (var i = 0; i < imagesData.length; i++) {
        carImages.add(CarImages(url: carData['carImages'][i]['url']));
      }

      //print(carData['id']);

      if (response.statusCode < 400) {
        _carsFromUser.add(
          Car(
            id: carData['id'],
            brand: carData['brand'],
            userId: carData['user'],
            model: carData['model'],
            year: carData['year'],
            plate: carData['plate'],
            fuel: fuel,
            gearShift: gearShift,
            category: category,
            doors: carData['doors'],
            seats: carData['seats'],
            trunk: carData['trunk'],
            price: carData['price'],
            location: CarLocation(
                latitude: carData['latitude'],
                longitude: carData['longitude'],
                address: carData['address']),
            description: carData['description'],
            imagesUrl: carImages,
          ),
        );
        notifyListeners();
      } else {
        throw HttpException(
          msg: "Não foi possível carrerar os seus veículos",
          statusCode: response.statusCode,
        );
      }
    });
  }
}
