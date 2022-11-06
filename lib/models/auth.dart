import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:carshare/data/store.dart';
import 'package:carshare/exceptions/auth_exception.dart';
import 'package:carshare/models/auth_firebase.dart';
import 'package:carshare/models/user.dart';
import 'package:carshare/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Auth with ChangeNotifier {
  String? _token;
  String? _refreshToken;
  String? _email;
  String? _userId;
  DateTime? _expiryDate;
  Timer? _logoutTimer;
  User? _currentUser;

  bool get isAuth {
    final isValid = _expiryDate?.isAfter(DateTime.now()) ?? false;
    return _token != null && isValid;
  }

  String? get token {
    return isAuth ? _token : null;
  }

  String? get email {
    return isAuth ? _email : null;
  }

  String? get userId {
    return isAuth ? _userId : null;
  }

  User? get currentUser {
    return isAuth ? _currentUser : null;
  }

  Future<void> signup(
      String email, String password, String firstName, String lastName) async {
    AuthFirebase().signup(email, password);

    final url = '${Constants.USER_BASE_URL}/create';

    final response = await http.post(
      Uri.parse(url),
      headers: {
        "content-type": "application/json",
        "accept": "application/json",
      },
      body: jsonEncode({
        "login": email,
        "password": password,
        "email": email,
        "firstName": firstName,
        "lastName": lastName
      }),
    );

    final body = jsonDecode(response.body);
    print(jsonDecode(response.body));

    if (body['error'] != null) {
      print(response);
      throw AuthException(body['error']['message']);
    } else {
      notifyListeners();
    }
  }

  Future<void> login(String userLogin, String password) async {
    AuthFirebase().login(userLogin, password);
    final url = '${Constants.AUTH_BASE_URL}/login';

    final response = await http.post(
      Uri.parse(url),
      headers: {
        "content-type": "application/json",
        "accept": "application/json",
      },
      body: jsonEncode({
        "login": userLogin,
        "password": password,
      }),
    );

    print(response.statusCode);
    print(jsonDecode(response.body));

    final body = jsonDecode(response.body);

    if (body['error'] != null) {
      print(response);
      throw AuthException(body['error']['message']);
    } else {
      _token = body['token'];
      _refreshToken = body['refreshToken'];

      // _expiryDate = DateTime.now().add(
      //   Duration(
      //     seconds: body['tokenExpiration'],
      //   ),
      // );

      _expiryDate =
          DateTime.fromMillisecondsSinceEpoch(body['tokenExpiration'] * 1000);

      Store.saveMap('userData', {
        'token': _token,
        'refreshToken': _refreshToken,
        'expireDate': _expiryDate?.toIso8601String(),
      });

      getLoggedUser();
      //_autoLogout();
      notifyListeners();
    }
  }

  Future<void> getLoggedUser() async {
    final userData = await Store.getMap('userData');
    if (userData.isEmpty) return;

    final url = '${Constants.AUTH_BASE_URL}/logged';

    _refreshToken = userData['refreshToken'];

    final response = await http.get(
      Uri.parse(url),
      headers: {
        "content-type": "application/json",
        "accept": "application/json",
        HttpHeaders.authorizationHeader: "Bearer $_refreshToken",
      },
    );

    Map<String, dynamic> userJson = jsonDecode(response.body);
    _currentUser = User(
      userJson['cpf'],
      userJson['rg'],
      userJson['phone'],
      userJson['about'],
      userJson['gender'],
      userJson['address'],
      userJson['memberSince'],
      id: userJson['id'],
      email: userJson['email'],
      firstName: userJson['firstName'],
      lastName: userJson['lastName'],
    );

    notifyListeners();
  }

  Future<void> tryAutoLogin() async {
    if (isAuth) return;

    final userData = await Store.getMap('userData');
    if (userData.isEmpty) return;

    final expiryDate = DateTime.parse(userData['expireDate']);
    if (expiryDate.isBefore(DateTime.now())) return;

    _token = userData['token'];
    _refreshToken = userData['refreshToken'];
    _expiryDate = expiryDate;
    print("refreshToken: $_refreshToken");
    _autoLogout();
    notifyListeners();
  }

  void logout() {
    _token = null;
    _expiryDate = null;
    _clearLogoutTimer();
    Store.remove('userData').then((_) => notifyListeners());
  }

  void _clearLogoutTimer() {
    _logoutTimer?.cancel();
    _logoutTimer = null;
  }

  void _autoLogout() {
    _clearLogoutTimer();
    getLoggedUser();
    final timeToLogout = _expiryDate?.difference(DateTime.now()).inSeconds;
    print(timeToLogout);
    _logoutTimer = Timer(
      Duration(seconds: timeToLogout ?? 0),
      logout,
    );
  }
}
