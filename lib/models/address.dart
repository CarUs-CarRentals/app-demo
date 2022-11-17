import 'package:carshare/models/user.dart';

enum BrazilStates {
  ACRE,
  ALAGOAS,
  AMAPA,
  AMAZONAS,
  BAHIA,
  CEARA,
  DISTRITO_FEDERAL,
  ESPIRITO_SANTO,
  GOIAS,
  MARANHAO,
  MATO_GROSSO,
  MATO_GROSSO_DO_SUL,
  MINAS_GERAIS,
  PARA,
  PARAIBA,
  PARANA,
  PERNAMBUCO,
  PIAUI,
  RIO_DE_JANEIRO,
  RIO_GRANDE_DO_NORTE,
  RIO_GRANDE_DO_SUL,
  RONDONIA,
  RORAIMA,
  SANTA_CATARINA,
  SAO_PAULO,
  SERGIPE,
  TOCANTINS,
}

class Address {
  final String cep;
  final BrazilStates state;
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
