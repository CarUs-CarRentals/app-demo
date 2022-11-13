import 'package:carshare/models/car.dart';
import 'package:flutter/material.dart';

class Cars with ChangeNotifier {
  List<Car> _cars = [];

  List<Car> get cars {
    return [..._cars];
  }

  int get carsCount {
    return _cars.length;
  }

  Car getCarById(int id) {
    return _cars[id];
  }
}
