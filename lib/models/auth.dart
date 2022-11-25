import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:carshare/data/store.dart';
import 'package:carshare/exceptions/auth_exception.dart';
import 'package:carshare/models/user.dart';
import 'package:carshare/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class Auth with ChangeNotifier {
  String? _token;
  String? _tokenBackend;
  String? _refreshToken;
  String? _refreshTokenBackend;
  String? _email;
  String? _userId;
  DateTime? _expiryDate;
  DateTime? _expiryDateBackend;
  Timer? _logoutTimer;
  Timer? _tokenExpirationTimer;
  User? _currentUser;

  bool get isAuth {
    final isValid = _expiryDate?.isAfter(DateTime.now()) ?? false;
    // final isValidBackend = _expiryDateBackend?.isAfter(DateTime.now()) ?? false;
    print(
        "$_token -------------------------------- e -------------------------------- $isValid");

    return _token != null && isValid; //&& isValidBackend;
  }

  String? get token {
    return isAuth ? _token : null;
  }

  String? get tokenBackend {
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

  String getCurrentUser() {
    return _userId.toString();
  }

  // Future<void> _authenticate(
  //     String email, String password, String urlFragment) async {
  //   final url =
  //       'https://identitytoolkit.googleapis.com/v1/accounts:$urlFragment?key=${Constants.GOOGLE_API_KEY}';
  //   final response = await http.post(
  //     Uri.parse(url),
  //     body: jsonEncode({
  //       'email': email,
  //       'password': password,
  //       'returnSecureToken': true,
  //     }),
  //   );

  //   final body = jsonDecode(response.body);
  //   print(jsonDecode(response.body));

  //   if (body['error'] != null) {
  //     throw AuthException(body['error']['message']);
  //   } else {
  //     _token = body['idToken'];
  //     _email = body['email'];
  //     _userId = body['localId'];
  //     _refreshToken = body['refreshToken'];

  //     _expiryDate = DateTime.now().add(
  //       Duration(
  //         seconds: int.parse(body['expiresIn']),
  //       ),
  //     );

  //     Store.saveMap('userDataFb', {
  //       'token': _token,
  //       'email': _email,
  //       'localId': _userId,
  //       'refreshToken': _refreshToken,
  //       'expireDate': _expiryDate?.toIso8601String(),
  //     });

  //     //_autoLogout();
  //     notifyListeners();
  //   }
  // }

  Future<void> signup(
      String email, String password, String firstName, String lastName) async {
    //return _authenticate(email, password, 'signUp');
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=${Constants.GOOGLE_API_KEY}';
    final responseGoogle = await http.post(
      Uri.parse(url),
      body: jsonEncode({
        'email': email,
        'password': password,
        'returnSecureToken': true,
      }),
    );

    final body = jsonDecode(responseGoogle.body);
    print(jsonDecode(responseGoogle.body));

    if (body['error'] != null) {
      throw AuthException(body['error']['message']);
    } else {
      final url = '${Constants.USER_BASE_URL}/create';

      final response = await http.post(
        Uri.parse(url),
        headers: {
          "content-type": "application/json",
          "accept": "application/json",
        },
        body: jsonEncode({
          "uuid": body['localId'],
          "login": email,
          "password": password,
          "email": email,
          "firstName": firstName,
          "lastName": lastName
        }),
      );

      _token = body['idToken'];
      _email = body['email'];
      //_userId = body['localId'];
      _refreshToken = body['refreshToken'];

      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(body['expiresIn']),
        ),
      );

      Store.saveMap('userDataFb', {
        'token': _token,
        'email': _email,
        //'localId': _userId,
        'refreshToken': _refreshToken,
        'expireDate': _expiryDate?.toIso8601String(),
      });

      login(email, password);

      //_autoLogout();
      notifyListeners();
    }
  }

  Future<void> login(String email, String password) async {
    //return _authenticate(email, password, 'signInWithPassword');
    const url =
        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=${Constants.GOOGLE_API_KEY}';
    final responseGoogle = await http.post(
      Uri.parse(url),
      body: jsonEncode({
        'email': email,
        'password': password,
        'returnSecureToken': true,
      }),
    );

    final body = jsonDecode(responseGoogle.body);
    print(jsonDecode(responseGoogle.body));

    if (body['error'] != null) {
      throw AuthException(body['error']['message']);
    } else {
      const url = '${Constants.AUTH_BASE_URL}/login';

      final response = await http.post(
        Uri.parse(url),
        headers: {
          "content-type": "application/json",
          "accept": "application/json",
        },
        body: jsonEncode({
          "login": email,
          "password": password,
        }),
      );

      final bodyBackend = jsonDecode(response.body);

      _token = body['idToken'];
      _email = body['email'];
      //_userId = body['localId'];
      _refreshToken = body['refreshToken'];

      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(body['expiresIn']),
        ),
      );

      _tokenBackend = bodyBackend['token'];
      _refreshTokenBackend = bodyBackend['refreshToken'];
      _expiryDateBackend = DateTime.fromMillisecondsSinceEpoch(
          bodyBackend['tokenExpiration'] * 1000);

      Store.saveMap('userData', {
        'token': _tokenBackend,
        'refreshToken': _refreshTokenBackend,
        'expireDate': _expiryDateBackend?.toIso8601String(),
      });

      Store.saveMap('userDataFb', {
        'token': _token,
        'email': _email,
        //'localId': _userId,
        'refreshToken': _refreshToken,
        'expireDate': _expiryDate?.toIso8601String(),
      });
      //_autoLogout();
      Map<String, dynamic> userLogged = await Auth().getLoggedUser();
      _userId = userLogged['uuid'] as String;
      print(_userId);
      notifyListeners();
    }
  }

  Future<void> tryAutoLogin() async {
    if (isAuth) {
      return;
    } else {
      _tryRefreshTokenBakend();
    }

    final userData = await Store.getMap('userDataFb');
    //final userDataBackend = await Store.getMap('userData');
    if (userData.isEmpty) return;
    //|| userDataBackend.isEmpty

    final expiryDate = DateTime.parse(userData['expireDate']);
    // final expiryDateBackend = DateTime.parse(userDataBackend['expireDate']);
    if (expiryDate.isBefore(DateTime.now())) return;
    //||expiryDateBackend.isBefore(DateTime.now())

    _token = userData['token'];
    //_tokenBackend = userData['token'];
    _email = userData['email'];
    //_userId = userData['localId'];
    _refreshToken = userData['refreshToken'];
    //_refreshTokenBackend = userData['refreshToken'];
    _expiryDate = expiryDate;
    print("uID: $_userId");
    notifyListeners();
  }

  void logout() {
    _token = null;
    _tokenBackend = null;
    _email = null;
    _userId = null;
    _expiryDate = null;
    _refreshTokenBackend = null;
    _expiryDateBackend = null;
    _clearLogoutTimer();

    Store.remove('userDataFb').then((_) => notifyListeners());
    Store.remove('userData').then((_) => notifyListeners());
  }

  void _clearLogoutTimer() {
    _logoutTimer?.cancel();
    _tokenExpirationTimer?.cancel();
    _logoutTimer = null;
    _tokenExpirationTimer = null;
  }

  void _autoLogout() {
    _clearLogoutTimer();
    final timeToLogout = _expiryDate?.difference(DateTime.now()).inSeconds;
    print("time to Logout: $timeToLogout");
    _logoutTimer = Timer(
      Duration(seconds: timeToLogout ?? 0),
      logout,
    );
  }

  void _tryRefreshTokenBakend() {
    final timeToRefreshToken =
        _expiryDateBackend?.difference(DateTime.now()).inSeconds;

    if (timeToRefreshToken == null) {
      return;
    }

    print("time to refresh backend: $timeToRefreshToken");

    _tokenExpirationTimer = Timer(
      Duration(seconds: timeToRefreshToken),
      refreshToken,
    );
  }

  Future<void> refreshToken() async {
    const url = '${Constants.AUTH_BASE_URL}/refresh-token';
    const urlFirebase =
        'https://securetoken.googleapis.com/v1/token?key=${Constants.GOOGLE_API_KEY}';

    final response = await http.post(
      Uri.parse(url),
      headers: {
        "content-type": "application/json",
        "accept": "application/json",
        HttpHeaders.authorizationHeader: "Bearer $_refreshTokenBackend",
      },
    );

    final responseFirebase = await http.post(
      Uri.parse(url),
      body: {
        "grant_type": "refresh_token",
        "refresh_token": _refreshToken,
      },
    );

    print(jsonDecode(response.body));
    print(jsonDecode(responseFirebase.body));
    int status = response.statusCode;
    if (status == 200) {
      _refreshTokenBackend = jsonDecode(response.body)['token'];
      _expiryDateBackend = DateTime.fromMillisecondsSinceEpoch(
          jsonDecode(response.body)['tokenExpiration'] * 1000);

      _refreshToken = jsonDecode(responseFirebase.body)['refresh_token'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(jsonDecode(responseFirebase.body)['expires_in']),
        ),
      );

      Store.saveMap('userDataFb', {
        'refreshToken': _refreshToken,
        'expireDate': _expiryDate?.toIso8601String(),
      });

      Store.saveMap('userData', {
        'token': _tokenBackend,
        'refreshToken': _refreshTokenBackend,
        'expireDate': _expiryDateBackend?.toIso8601String(),
      });

      notifyListeners();
    } else {
      logout;
    }
  }

  String? getRefreshTokenBackend() {
    final userData = Store.getMap('userData').then((data) {
      _refreshToken = data['refreshToken'];
    });

    return _refreshToken;
  }

  Future<Map<String, dynamic>> getLoggedUser() async {
    final userData = await Store.getMap('userData');
    //if (userData.isEmpty) return;

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
    return userJson;
    // return User(
    //   id: userJson['uuid'],
    //   email: userJson['email'],
    //   firstName: userJson['firstName'],
    //   lastName: userJson['lastName'],
    //   memberSince: userJson['memberSince'],
    //   about: userJson['about'],
    // );
    // return User(
    //   userJson['cpf'],
    //   userJson['rg'],
    //   userJson['phone'],
    //   userJson['about'],
    //   userJson['gender'],
    //   userJson['address'],
    //   userJson['memberSince'],
    //   id: userJson['uuid'],
    //   email: userJson['email'],
    //   firstName: userJson['firstName'],
    //   lastName: userJson['lastName'],
    // );

    //print(_currentUser!.fullName);

    //notifyListeners();
  }
}
