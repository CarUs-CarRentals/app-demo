import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:carshare/data/dummy_users_data.dart';
import 'package:carshare/data/store.dart';
import 'package:carshare/exceptions/http_exceptions.dart';
import 'package:carshare/models/address.dart';
import 'package:carshare/models/cnh.dart';
import 'package:carshare/models/user.dart';
import 'package:carshare/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class Users with ChangeNotifier {
  final _baseUrl = Constants.USER_BASE_URL;

  // final String _token;
  // final String _userId;
  String? _refreshToken;
  User? _userProfile;
  User? _userByID;
  final List<User> _users = []; //= dummyUsers;

  List<User> get users => [..._users];
  User? get userProfile => _userProfile;
  User? get userByID => _userByID;
  int get usersCount {
    return _users.length;
  }

  // User userByID(String id) {
  //   Iterable<User> selectedUser = _users.where((user) => user.id == id);
  //   try {
  //     return selectedUser.elementAt(0);
  //   } catch (e) {
  //     return User(
  //       "88527046040",
  //       "509581912",
  //       "47999999999",
  //       "Some mim",
  //       UserGender.female,
  //       Address(
  //           "CEP", BrazilStates.SANTA_CATARINA, "Cidade", "Bairro", "Rua", 999),
  //       "",
  //       id: '1',
  //       email: "meu_email@gmail.com",
  //       firstName: "Nome",
  //       lastName: "Sobrenome",
  //     );
  //   }
  // }

  Future<void> saveUser(Map<String, Object> data) {
    bool hasId = data['userID'] != null;

    final user = User(
      id: hasId ? data['userID'] as String : "",
      email: data['email'] as String,
      firstName: data['firstName'] as String,
      lastName: data['lastName'] as String,
      cpf: data['cpf'] as String,
      phone: data['phone'] as String,
      gender: data['gender'] as UserGender,
      about: data['about'] as String,
      profileImageUrl: data['profileImageUrl'] as String,
    );

    return updateUser(user);
  }

  Future<void> loadProfile() async {
    _userProfile = null;

    final userData = await Store.getMap('userData');
    _refreshToken = userData['refreshToken'];

    final response = await http.get(
      Uri.parse('$_baseUrl/profile'),
      headers: {
        "content-type": "application/json",
        "accept": "application/json",
        HttpHeaders.authorizationHeader: "Bearer $_refreshToken",
      },
    );
    String source = Utf8Decoder().convert(response.bodyBytes);
    Map<String, dynamic> profileData = jsonDecode(source);

    BrazilStates? brazilStates;

    if (profileData['address'] != null) {
      brazilStates = BrazilStates.values.firstWhere((element) =>
          element.name.toString() == profileData['address']['state']);
    }

    _userProfile = User(
        id: "pz0pX3mJcsRN0u5yl5BSrvcB8a82", //profileData['id'] ?? "",
        firstName: profileData['firstName'],
        lastName: profileData['lastName'],
        email: "igor.ponchielli@gmail.com", //profileData['email'] ?? "",
        memberSince: profileData['memberSince'],
        about: profileData['about'],
        rateNumber: profileData['rateNumber'],
        address: profileData['address'] == null
            ? null
            : Address(
                profileData['address']['id'],
                profileData['address']['cep'],
                brazilStates!,
                profileData['address']['city'],
                profileData['address']['neighborhood'],
                profileData['address']['street'],
                profileData['address']['number'],
              ),
        cnh: profileData['cnh'] == null
            ? null
            : Cnh(
                profileData['cnh']['id'],
                rg: profileData['cnh']['rg'],
                registerNumber: profileData['cnh']['registerNumber'],
                cnhNumber: profileData['cnh']['cnhNumber'],
                expirationDate: profileData['cnh']['expirationDate'],
                birthDate: profileData['cnh']['birthDate'],
                state: profileData['cnh']['state'],
              ));

    notifyListeners();
  }

  Future<void> loadUsers() async {
    _users.clear();

    final response = await http.get(Uri.parse('$_baseUrl/all'));
    if (response.body == 'null') return;

    notifyListeners();
  }

  Future<void> updateUser(User user) async {
    final userData = await Store.getMap('userData');
    _refreshToken = userData['refreshToken'];

    final response = await http.patch(
      Uri.parse('$_baseUrl/${user.id}'),
      headers: {
        "content-type": "application/json",
        "accept": "application/json",
        HttpHeaders.authorizationHeader: "Bearer $_refreshToken",
      },
      body: jsonEncode(
        {
          "email": user.email,
          "firstName": user.firstName,
          "lastName": user.lastName,
          "cpf": user.cpf,
          "rg": user.rg,
          "phone": user.phone,
          "gender": user.gender?.name,
          "about": user.about,
          "profileImageUrl": user.profileImageUrl,
        },
      ),
    );

    if (response.statusCode < 400) {
      _userProfile = user;
      notifyListeners();
    } else {
      throw HttpException(
        msg: "Não foi possível atualizar o usuario",
        statusCode: response.statusCode,
      );
    }
  }

  Future<void> loadUserById(String userId) async {
    _userByID = null;

    final userData = await Store.getMap('userData');
    _refreshToken = userData['refreshToken'];

    final response = await http.get(
      Uri.parse('$_baseUrl/$userId'),
      headers: {
        "content-type": "application/json",
        "accept": "application/json",
        HttpHeaders.authorizationHeader: "Bearer $_refreshToken",
      },
    );
    String source = Utf8Decoder().convert(response.bodyBytes);
    Map<String, dynamic> profileData = jsonDecode(source);

    // BrazilStates brazilStates = BrazilStates.values.firstWhere((element) =>
    //     element.name.toString() == profileData['address']['state']);

    _userByID = User(
        id: profileData['uuid'],
        firstName: profileData['firstName'],
        lastName: profileData['lastName'],
        email: profileData['lastName'],
        memberSince: profileData['memberSince'],
        about: profileData['about'],
        address: null //Address(
        // profileData['address']['cep'],
        // brazilStates,
        // profileData['address']['city'],
        // profileData['address']['neighborhood'],
        // profileData['address']['street'],
        // profileData['address']['number'],
        //),
        );

    notifyListeners();
  }
}
