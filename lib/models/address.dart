import 'package:carshare/models/user.dart';

class Address {
  final String cep;
  final String state;
  final String city;
  final String neighborhood;
  final String street;
  final int number;

  Address(
    this.cep,
    this.state,
    this.city,
    this.neighborhood,
    this.street,
    this.number,
  );

  String get fullAddress {
    return '$street, $neighborhood, $city, - $state, $cep';
  }
}
