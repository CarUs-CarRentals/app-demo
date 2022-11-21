import 'dart:convert';
import 'dart:io';

import 'package:carshare/data/store.dart';
import 'package:carshare/models/address.dart';
import 'package:carshare/models/cnh.dart';
import 'package:carshare/models/cnh.dart';
import 'package:carshare/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:carshare/exceptions/http_exceptions.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DriverLicenses with ChangeNotifier {
  final _baseUrl = Constants.DRIVER_BASE_URL;

  // final String _token;
  // final String _cnhId;
  String? _refreshToken;
  //CNH? _cnhProfile;
  //CNH? _cnhByID;

  //List<CNH> get cnhs => [..._cnhs];
  //CNH? get cnhProfile => _cnhProfile;
  //CNH? get cnhByID => _cnhByID;

  Future<void> saveCNH(Map<String, Object> data) {
    bool hasId = data['cnhID'] != "";
    final userId = data['userID'] as String;

    final cnh = Cnh(
      hasId ? data['cnhID'] as int : 0,
      rg: data['rg'] as String,
      birthDate: data['birthDate'] as DateTime,
      registerNumber: data['cnhRegisterNumber'] as String,
      cnhNumber: data['cnhNumber'] as String,
      expirationDate: data['cnhExpirationDate'] as DateTime,
      state: data['cnhState'] as BrazilStates,
    );

    if (hasId) {
      return updateCNH(cnh, userId);
    } else {
      return addCNH(cnh, userId);
    }
  }

  Future<void> addCNH(Cnh cnh, String userId) async {
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
        "userId": userId,
        "rg": cnh.rg,
        "registerNumber": cnh.registerNumber,
        "cnhNumber": cnh.cnhNumber,
        "expirationDate": cnh.expirationDate,
        "birthDate": cnh.birthDate,
        "state": cnh.state,
      }),
    );

    if (response.statusCode < 400) {
      notifyListeners();
    } else {
      throw HttpException(
        msg: "Não foi possível cadastrar a CNH",
        statusCode: response.statusCode,
      );
    }
  }

  Future<void> updateCNH(Cnh cnh, String userId) async {
    final userData = await Store.getMap('userData');
    _refreshToken = userData['refreshToken'];

    final response = await http.post(
      Uri.parse('$_baseUrl/${cnh.id}'),
      headers: {
        "content-type": "application/json",
        "accept": "application/json",
        HttpHeaders.authorizationHeader: "Bearer $_refreshToken",
      },
      body: jsonEncode({
        "userId": userId,
        "rg": cnh.rg,
        "registerNumber": cnh.registerNumber,
        "cnhNumber": cnh.cnhNumber,
        "expirationDate": cnh.expirationDate,
        "birthDate": cnh.birthDate,
        "state": cnh.state,
      }),
    );

    if (response.statusCode < 400) {
      notifyListeners();
    } else {
      throw HttpException(
        msg: "Não foi possível alterar a CNH",
        statusCode: response.statusCode,
      );
    }
  }
}
