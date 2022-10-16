import 'dart:convert';

import 'package:carshare/data/dummy_users_data.dart';
import 'package:carshare/models/user.dart';
import 'package:carshare/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UserList with ChangeNotifier {
  final _baseUrl = Constants.USER_BASE_URL;

  // final String _token;
  // final String _userId;
  final List<User> _users = dummyUsers; //[];

  List<User> get users => [..._users];

  int get usersCount {
    return _users.length;
  }

  User userByID(int id) {
    Iterable<User> selectedUser = _users.where((user) => user.id == id);
    return selectedUser.elementAt(0);
  }

  Future<void> loadCars() async {
    _users.clear();

    final response = await http.get(Uri.parse('$_baseUrl/all'));
    if (response.body == 'null') return;

    notifyListeners();
  }

  Future<void> updateUser(User user) async {
    int index = _users.indexWhere((p) => p.id == user.id);

    if (index >= 0) {
      await http.patch(
        Uri.parse('$_baseUrl/${user.id}'),
        body: jsonEncode(
          {
            "login": user.login,
            "password": user.password,
            "email": user.email,
            "firstName": user.firstName,
            "lastName": user.lastName,
            "cpf": user.cpf,
            "rg": user.rg,
            "phone": user.phone,
            "gender": user.gender
          },
        ),
      );
      _users[index] = user;
      notifyListeners();
    }
  }
}
