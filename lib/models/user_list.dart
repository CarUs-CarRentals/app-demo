import 'dart:convert';

import 'package:carshare/data/dummy_users_data.dart';
import 'package:carshare/models/address.dart';
import 'package:carshare/models/user.dart';
import 'package:carshare/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class UserList with ChangeNotifier {
  final _baseUrl = Constants.USER_BASE_URL;

  // final String _token;
  // final String _userId;
  final List<User> _users = dummyUsers; //[];

  List<User> get users => [..._users];

  int get usersCount {
    return _users.length;
  }

  User userByID(String id) {
    Iterable<User> selectedUser = _users.where((user) => user.id == id);
    try {
      return selectedUser.elementAt(0);
    } catch (e) {
      return User(
        "88527046040",
        "509581912",
        "47999999999",
        "Some mim",
        UserGender.female,
        Address("CEP", "UF", "Cidade", "Bairro", "Rua", 999),
        "",
        id: '1',
        email: "meu_email@gmail.com",
        firstName: "Nome",
        lastName: "Sobrenome",
      );
    }
  }

  // User loadCurrentUser() {
  //   Auth().getLoggedUser();

  // }

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
