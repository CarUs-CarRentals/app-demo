import 'dart:convert';
import 'dart:io';

import 'package:carshare/data/store.dart';
import 'package:carshare/exceptions/http_exceptions.dart';
import 'package:carshare/models/auth.dart';
import 'package:carshare/models/car.dart';
import 'package:carshare/models/rental.dart';
import 'package:carshare/models/review.dart';
import 'package:carshare/providers/cars.dart';
import 'package:carshare/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class Reviews with ChangeNotifier {
  final _baseUrl = Constants.RATE_BASE_URL;

  // final String _token;
  // final String _userId;
  String? _refreshToken;
  final List<CarReview> _carReviews = [];
  final List<CarReview> _carReviewsFromCar = [];
  final List<UserReview> _userReviews = [];
  final List<UserReview> _userReviewsFromUser = [];

  List<CarReview> get carReviews => [..._carReviews];

  // List<Car> get favoriteItems =>
  //     _cars.where((car) => car.isFavorite).toList();

  // Reviews([
  //   this._token = '',
  //   this._userId = '',
  //   this._cars = const [],
  // ]);

  Future<void> loadCarReviews() async {
    final userData = await Store.getMap('userData');
    _refreshToken = userData['refreshToken'];

    _carReviews.clear();

    final response = await http.get(
      Uri.parse('$_baseUrl-car/'),
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
    data.forEach((reviewData) {
      _carReviews.add(CarReview(
        id: reviewData['id'],
        carId: reviewData['carId'],
        date: reviewData['date'],
        description: reviewData['description'],
        rate: reviewData['rate'],
        rentalId: reviewData[''],
        userIdEvaluator: reviewData['userUuid'],
      ));
    });

    notifyListeners();
  }

  Future<void> saveCarReview(Map<String, Object> data) async {
    Map<String, dynamic> userLogged = await Auth().getLoggedUser();
    //Map<String, dynamic> userData;

    bool hasId = data['id'] != null;

    final review = CarReview(
      id: hasId ? data['id'] as int : 0,
      carId: data['carId'] as int,
      date: data['date'] as DateTime,
      description: data['description'] as String,
      rate: data['rate'] as double,
      rentalId: data[''] as int,
      userIdEvaluator: userLogged['uuid'] as String,
    );

    if (!hasId) {
      //return;
      return addCarReview(review);
      // updateCarReview(rental);
    }
  }

  Future<void> addCarReview(CarReview carReview) async {
    final userData = await Store.getMap('userData');
    _refreshToken = userData['refreshToken'];

    final formatDate = DateFormat('yyyy-mm-dd');

    final response = await http.post(
      Uri.parse('$_baseUrl-car/create'),
      headers: {
        "content-type": "application/json",
        "accept": "application/json",
        HttpHeaders.authorizationHeader: "Bearer $_refreshToken",
      },
      body: jsonEncode({
        "userUuid": carReview.userIdEvaluator,
        "carId": carReview.carId,
        "rate": carReview.rate,
        "description": carReview.description,
        "date": formatDate.format(carReview.date),
      }),
    );

    if (response.statusCode < 400) {
      //_rentalFromUser.add(rental);
      notifyListeners();
    } else {
      throw HttpException(
        msg: "Não foi possível efetuar avaliação",
        statusCode: response.statusCode,
      );
    }
  }

  Future<void> loadCarReviewsByCar(int carId) async {
    final userData = await Store.getMap('userData');
    _refreshToken = userData['refreshToken'];

    _carReviewsFromCar.clear();

    final response = await http.get(
      Uri.parse('$_baseUrl-car/car/$carId'),
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
    data.forEach((reviewData) async {
      _carReviewsFromCar.add(CarReview(
        id: reviewData['id'],
        rentalId: reviewData['rentalId'],
        userIdEvaluator: reviewData['userIdEvaluator'],
        carId: reviewData['carId'],
        description: reviewData['description'],
        rate: reviewData['rate'],
        date: reviewData['date'],
      ));
    });

    notifyListeners();
  }

  Future<void> saveUserReview(Map<String, Object> data) async {
    Map<String, dynamic> userLogged = await Auth().getLoggedUser();
    //Map<String, dynamic> userData;

    bool hasId = data['id'] != null;

    final review = UserReview(
      id: hasId ? data['id'] as int : 0,
      userIdRated: data['evaluatedUser'] as String,
      date: data['date'] as DateTime,
      description: data['description'] as String,
      rate: data['rate'] as double,
      rentalId: data[''] as int,
      userIdEvaluator: userLogged['uuid'] as String,
    );

    if (!hasId) {
      return addUserReview(review);
    }
  }

  Future<void> addUserReview(UserReview userReview) async {
    final userData = await Store.getMap('userData');
    _refreshToken = userData['refreshToken'];

    final formatDate = DateFormat('yyyy-mm-dd');

    final response = await http.post(
      Uri.parse('$_baseUrl-user/create'),
      headers: {
        "content-type": "application/json",
        "accept": "application/json",
        HttpHeaders.authorizationHeader: "Bearer $_refreshToken",
      },
      body: jsonEncode({
        "ratedUser": userReview.userIdRated,
        "evaluatedUser": userReview.userIdEvaluator,
        "rate": userReview.rate,
        "description": userReview.description,
        "date": formatDate.format(userReview.date),
      }),
    );

    if (response.statusCode < 400) {
      //_rentalFromUser.add(rental);
      notifyListeners();
    } else {
      throw HttpException(
        msg: "Não foi possível efetuar avaliação",
        statusCode: response.statusCode,
      );
    }
  }

  Future<void> loadUserReviewsByUser(String userId) async {
    final userData = await Store.getMap('userData');
    _refreshToken = userData['refreshToken'];

    _userReviewsFromUser.clear();

    final response = await http.get(
      Uri.parse('$_baseUrl-user/user/$userId'),
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
    data.forEach((reviewData) async {
      _userReviewsFromUser.add(UserReview(
        id: reviewData['id'],
        rentalId: reviewData['rentalId'],
        userIdEvaluator: reviewData['evaluatedUser'],
        userIdRated: reviewData['ratedUser'],
        description: reviewData['description'],
        rate: reviewData['rate'],
        date: reviewData['date'],
      ));
    });

    notifyListeners();
  }
}
