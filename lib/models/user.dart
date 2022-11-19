import 'package:carshare/models/address.dart';

enum UserGender {
  male,
  female,
  unknown,
}

class User {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String memberSince;
  final String cpf;
  final String rg;
  final String phone;
  final String about;
  final int rateNumber;
  final UserGender gender;
  final Address? address;

  User({
    this.id = '',
    this.cpf = '',
    this.rg = '',
    this.phone = '',
    this.about = '',
    this.rateNumber = 0,
    this.gender = UserGender.unknown,
    this.address,
    this.memberSince = '',
    required this.email,
    required this.firstName,
    required this.lastName,
  });

  String get fullName {
    return '$firstName $lastName';
  }
}
