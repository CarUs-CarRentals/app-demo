import 'package:carshare/models/review.dart';

List<Review> dummyReviewsCars = [
  Review(
    id: '1',
    userName: 'Pablo',
    carId: '1',
    title: 'Muito bom',
    value: 1.0,
    date: DateTime.now().add(Duration(days: -5)),
  ),
  Review(
    id: '2',
    userName: 'Vanessa',
    carId: '1',
    title:
        'bom, mas o cinto de segurança é traseiro curto, incompatível com cadeirinha infantil e o porta-malas é pequeno',
    value: 4,
    date: DateTime.now().add(Duration(days: -1)),
  ),
  Review(
    id: '3',
    userName: 'Ricardo',
    carId: '1',
    title: 'Já vi melhores',
    value: 3.5,
    date: DateTime.now(),
  ),
  Review(
    id: '4',
    userName: 'Igor',
    carId: '2',
    title: 'Tava bom, aí melhorou, agora parece que está pior',
    value: 3,
    date: DateTime.now(),
  ),
  Review(
    id: '5',
    userName: 'Juliana',
    carId: '2',
    title: 'Maravilindo!!! ❤❤❤ Adorei.',
    value: 5,
    date: DateTime.now(),
  ),
  Review(
    id: '6',
    userName: 'Henrique',
    carId: '2',
    title:
        'O Fiat Argo é um carro bastante econômico. Ainda mais as versões equipadas com o motor 1.0 Firefly Flex, que pode gerar 77 cv de potência e 10,9 kgfm de torque. Estes modelos podem fazer 13,5 km/l (gasolina) e 9,4 km/l (etanol) na cidade.',
    value: 4,
    date: DateTime.now(),
  ),
];
