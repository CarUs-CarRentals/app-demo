import 'dart:convert';
import 'dart:io';

import 'package:carshare/data/store.dart';
import 'package:carshare/models/address.dart';
import 'package:carshare/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:carshare/exceptions/http_exceptions.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Addresses with ChangeNotifier {
  final _baseUrl = Constants.ADDR_BASE_URL;

  // final String _token;
  // final String _addressId;
  String? _refreshToken;
  //Address? _addressProfile;
  //Address? _addressByID;

  //List<Address> get addresss => [..._addresss];
  //Address? get addressProfile => _addressProfile;
  //Address? get addressByID => _addressByID;

  Future<void> saveAddress(Map<String, Object> data) {
    bool hasId = data['addressID'] != "";
    final userId = data['userID'] as String;

    if (data['addressNumber'] == "") {
      data['addressNumber'] = "0";
    }

    final address = Address(
      hasId ? data['addressID'] as int : 0,
      data['cep'] as String,
      data['state'] as BrazilStates,
      data['city'] as String,
      data['neighborhood'] as String,
      data['street'] as String,
      int.parse(data['addressNumber'].toString()),
    );

    if (hasId) {
      return updateAddress(address, userId);
    } else {
      return addAddress(address, userId);
    }
  }

  Future<void> addAddress(Address address, String userId) async {
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
        "user": userId,
        "cep": address.cep,
        "state": address.state,
        "city": address.city,
        "neighborhood": address.neighborhood,
        "street": address.street,
        "number": address.number
      }),
    );

    if (response.statusCode < 400) {
      notifyListeners();
    } else {
      throw HttpException(
        msg: "Não foi possível cadastrar o endereço",
        statusCode: response.statusCode,
      );
    }
  }

  Future<void> updateAddress(Address address, String userId) async {
    final userData = await Store.getMap('userData');
    _refreshToken = userData['refreshToken'];

    final response = await http.post(
      Uri.parse('$_baseUrl/${address.id}'),
      headers: {
        "content-type": "application/json",
        "accept": "application/json",
        HttpHeaders.authorizationHeader: "Bearer $_refreshToken",
      },
      body: jsonEncode({
        "id": address.id,
        "user": userId,
        "cep": address.cep,
        "state": address.state,
        "city": address.city,
        "neighborhood": address.neighborhood,
        "street": address.street,
        "number": address.number
      }),
    );

    if (response.statusCode < 400) {
      notifyListeners();
    } else {
      throw HttpException(
        msg: "Não foi possível alterar o endereço",
        statusCode: response.statusCode,
      );
    }
  }
}
