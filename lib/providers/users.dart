import 'dart:convert';
import 'dart:io';

import 'package:carshare/data/store.dart';
import 'package:carshare/exceptions/http_exceptions.dart';
import 'package:carshare/models/address.dart';
import 'package:carshare/models/cnh.dart';
import 'package:carshare/models/user.dart';
import 'package:carshare/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class Users with ChangeNotifier {
  final _baseUrl = Constants.USER_BASE_URL;

  // final String _token;
  // final String _userId;
  String? _refreshToken;
  User? _userProfile;
  User? _userByID;
  String? _userId;
  final List<User> _users = [];

  List<User> get users => [..._users];
  User? get userProfile => _userProfile;
  User? get userByID => _userByID;
  int get usersCount {
    return _users.length;
  }

  Future<void> saveUser(Map<String, Object> data) {
    bool hasId = data['userID'] != null;

    if (data['profileImageUrl'] == "") {
      data['profileImageUrl'] = Constants.DEFAULT_PROFILE_IMAGE;
    }

    final user = User(
      id: hasId ? data['userID'] as String : "",
      email: data['email'] as String,
      firstName: data['firstName'] as String,
      lastName: data['lastName'] as String,
      cpf: data['cpf'] as String,
      phone: data['phone'] as String,
      gender: data['gender'] as UserGender,
      about: data['about'] as String,
      address: Address(
        data['addressID'] == "" ? 0 : data['addressID'] as int,
        data['cep'] as String,
        data['state'] as BrazilStates,
        data['city'] as String,
        data['neighborhood'] as String,
        data['street'] as String,
        data['addressNumber'] as int,
      ),
      profileImageUrl: data['profileImageUrl'] as String,
    );

    return updateUser(user);
  }

  Future<void> loadProfile() async {
    _userProfile = null;

    final userDataFb = await Store.getMap('userDataFb');
    _userId = userDataFb['localId'];

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
    BrazilStates? brazilCNHStates;

    if (profileData['address'] != null) {
      brazilStates = BrazilStates.values.firstWhere((element) =>
          element.name.toString() == profileData['address']['state']);
    }

    if (profileData['cnh'] != null) {
      brazilCNHStates = BrazilStates.values.firstWhere(
          (element) => element.name.toString() == profileData['cnh']['state']);
    }

    if (profileData['gender'] == null) {
      profileData['gender'] = UserGender.OTHER.name;
    }

    UserGender userGender = UserGender.values.firstWhere(
        (element) => element.name.toString() == profileData['gender']);
    profileData['id'] = _userId as String;

    _userProfile = User(
        id: profileData['id'] ?? "",
        firstName: profileData['firstName'],
        lastName: profileData['lastName'],
        email: profileData['email'] ?? "",
        memberSince: profileData['memberSince'],
        about: profileData['about'],
        cpf: profileData['cpf'] ?? "",
        gender: userGender,
        phone: profileData['phone'] ?? "",
        rateNumber: profileData['rateNumber'],
        profileImageUrl:
            profileData['profileImageUrl'] ?? Constants.DEFAULT_PROFILE_IMAGE,
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
                userId: profileData['cnh']['userId'],
                rg: profileData['cnh']['rg'],
                registerNumber: profileData['cnh']['registerNumber'],
                cnhNumber: profileData['cnh']['cnhNumber'],
                expirationDate:
                    DateTime.parse(profileData['cnh']['expirationDate']),
                birthDate: DateTime.parse(profileData['cnh']['birthDate']),
                state: brazilCNHStates!,
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

    final response = await http.put(
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
          "phone": user.phone,
          "gender": user.gender?.name,
          "about": user.about,
          "address": user.address != null
              ? {
                  "id": user.address?.id,
                  "cep": user.address?.cep,
                  "state": user.address?.state.name,
                  "city": user.address?.city,
                  "neighborhood": user.address?.neighborhood,
                  "street": user.address?.street,
                  "number": user.address?.number,
                }
              : null,
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

  Future<User> loadUserById(String userId) async {
    _userByID = null;
    BrazilStates brazilStates = BrazilStates.UNKNOWN;

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

    if (profileData['address'] != null) {
      brazilStates = BrazilStates.values.firstWhere((element) =>
          element.name.toString() == profileData['address']['state']);
    }
    print(jsonDecode(source));

    final userByID = User(
      id: profileData['uuid'],
      firstName: profileData['firstName'],
      lastName: profileData['lastName'],
      email: profileData['lastName'],
      memberSince: profileData['memberSince'],
      about: profileData['about'],
      address: profileData['address'] == null
          ? null
          : Address(
              profileData['address']['id'],
              profileData['address']['cep'],
              brazilStates,
              profileData['address']['city'],
              profileData['address']['neighborhood'],
              profileData['address']['street'],
              profileData['address']['number'],
            ),
      profileImageUrl:
          profileData['profileImageUrl'] ?? Constants.DEFAULT_PROFILE_IMAGE,
    );

    notifyListeners();
    return userByID;
  }
}
