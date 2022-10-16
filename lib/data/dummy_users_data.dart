import 'package:carshare/models/address.dart';
import 'package:carshare/models/user.dart';

List<User> dummyUsers = [
  User(
      1,
      "igor.ponchielli",
      "123456",
      "igor.ponchielli@gmail.com",
      "Igor Felipe",
      "Ponchielli",
      "11060338920",
      "6063687",
      "47992766776",
      UserGender.male,
      "Eu sou o Igor, um cara muito legal",
      Address(
          "89107-000", "SC", "Pomerode", "Testo Rega", "Rua Horst Rauh", 403)),
  User(
      2,
      "pedro",
      "123456",
      "pedroh.zwang@gmail.com",
      "Pedro",
      "Zwang",
      "55139786010",
      "102499883",
      "985049059",
      UserGender.male,
      "Eu sou o Pedro, um cara muito legal",
      Address("89012-001", "SC", "Blumenau", "Victor Konder", "Rua São Paulo",
          1147)),
  User(
      3,
      "eduarda.nogueira",
      "JFClo42r4W",
      "eduarda.ana.nogueira@mabeitex.com.br",
      "Eduarda Ana",
      "Nogueira",
      "88527046040",
      "509581912",
      "21982784009",
      UserGender.female,
      "Eu sou o Eduarda, uma pessoa muito legal",
      Address(
          "89259-480", "SC", "Jaraguá do Sul", "Vila Nova", "Rua Pomerode", 50))
];
