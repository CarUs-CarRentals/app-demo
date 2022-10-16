import 'package:carshare/models/address.dart';

enum UserGender {
  male,
  female,
  unknown,
}

class User {
  late final int id;
  final String login;
  final String password;
  final String email;
  final String firstName;
  final String lastName;
  final String cpf;
  final String rg;
  final String phone;
  final String about;
  final UserGender gender;
  final Address address;

  User(
    this.id,
    this.login,
    this.password,
    this.email,
    this.firstName,
    this.lastName,
    this.cpf,
    this.rg,
    this.phone,
    this.gender,
    this.about, this.address,
  );

  String get fullName {
    return '$firstName $lastName';
  }
}
