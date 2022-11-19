import 'package:carshare/models/address.dart';

enum UserGender {
  MALE,
  FEMALE,
  UNKNOWN,
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
  final String profileImageUrl;

  User({
    this.profileImageUrl = '',
    this.id = '',
    this.cpf = '',
    this.rg = '',
    this.phone = '',
    this.about = '',
    this.rateNumber = 0,
    this.gender = UserGender.UNKNOWN,
    this.address,
    this.memberSince = '',
    required this.email,
    required this.firstName,
    required this.lastName,
  });

  String get fullName {
    return '$firstName $lastName';
  }

  String get userGenderText {
    switch (gender) {
      case UserGender.MALE:
        return 'Masculino';
      case UserGender.FEMALE:
        return 'Feminino';
      case UserGender.UNKNOWN:
        return 'Desconhecido';
      default:
        return 'Desconhecido';
    }
  }
}
