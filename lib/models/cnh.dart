import 'package:carshare/models/address.dart';
import 'package:carshare/models/user.dart';

class Cnh {
  final int id;
  final String rg;
  final String registerNumber;
  final String cnhNumber;
  final DateTime expirationDate;
  final DateTime birthDate;
  final BrazilStates state;

  Cnh(
    this.id, {
    required this.rg,
    required this.registerNumber,
    required this.cnhNumber,
    required this.expirationDate,
    required this.birthDate,
    required this.state,
  });
}
