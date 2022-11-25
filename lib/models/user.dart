import 'package:carshare/models/address.dart';
import 'package:carshare/models/cnh.dart';

enum UserGender {
  MALE,
  FEMALE,
  OTHERS,
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
  final UserGender? gender;
  final Address? address;
  final Cnh? cnh;
  final String profileImageUrl;

  User({
    this.profileImageUrl = '',
    this.id = '',
    this.cpf = '',
    this.rg = '',
    this.phone = '',
    this.about = '',
    this.address,
    this.cnh,
    this.gender,
    this.rateNumber = 0,
    this.memberSince = '',
    required this.email,
    required this.firstName,
    required this.lastName,
  });

  String get fullName {
    return '$firstName $lastName';
  }

  static String getUserGenderText(gender) {
    switch (gender) {
      case UserGender.MALE:
        return 'Masculino';
      case UserGender.FEMALE:
        return 'Feminino';
      default:
        return 'Não informado';
    }
  }
}
