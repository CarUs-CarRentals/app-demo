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
  UNKNOWN,
}

class Address {
  final int id;
  final String cep;
  final BrazilStates state;
  final String city;
  final String neighborhood;
  final String street;
  final int number;

  Address(
    this.id,
    this.cep,
    this.state,
    this.city,
    this.neighborhood,
    this.street,
    this.number,
  );

  String get fullAddress {
    return '$street, $neighborhood, $city, - ${getStateText(state)}, $cep';
  }

  static String getStateText(BrazilStates state) {
    switch (state) {
      case BrazilStates.ACRE:
        return 'Acre';
      case BrazilStates.ALAGOAS:
        return 'Alagoas';
      case BrazilStates.AMAPA:
        return 'Amapá';
      case BrazilStates.AMAZONAS:
        return 'Amazonas';
      case BrazilStates.BAHIA:
        return 'Bahia';
      case BrazilStates.CEARA:
        return 'Ceara';
      case BrazilStates.DISTRITO_FEDERAL:
        return 'Distrito Federal';
      case BrazilStates.ESPIRITO_SANTO:
        return 'Espírito Santo';
      case BrazilStates.GOIAS:
        return 'Goiás';
      case BrazilStates.MARANHAO:
        return 'Maranhão';
      case BrazilStates.MATO_GROSSO:
        return 'Mato Grosso';
      case BrazilStates.MATO_GROSSO_DO_SUL:
        return 'Mato Grosso do Sul';
      case BrazilStates.MINAS_GERAIS:
        return 'Minas Gerais';
      case BrazilStates.PARA:
        return 'Pará';
      case BrazilStates.PARAIBA:
        return 'Paraíba';
      case BrazilStates.PARANA:
        return 'Paraná';
      case BrazilStates.PERNAMBUCO:
        return 'Pernambuco';
      case BrazilStates.PIAUI:
        return 'Piauí';
      case BrazilStates.RIO_DE_JANEIRO:
        return 'Rio de Janeiro';
      case BrazilStates.RIO_GRANDE_DO_NORTE:
        return 'Rio Grande do Norte';
      case BrazilStates.RIO_GRANDE_DO_SUL:
        return 'Rio Grande do Sul';
      case BrazilStates.RONDONIA:
        return 'Rondônia';
      case BrazilStates.RORAIMA:
        return 'Roraima';
      case BrazilStates.SANTA_CATARINA:
        return 'Santa Catarina';
      case BrazilStates.SAO_PAULO:
        return 'São Paulo';
      case BrazilStates.SERGIPE:
        return 'Sergipe';
      case BrazilStates.TOCANTINS:
        return 'Tocantins';
      default:
        return 'Desconhecido';
    }
  }
}
