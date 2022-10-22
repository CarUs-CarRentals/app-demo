import '../models/review.dart';

List<CarReview> dummyCarsReviews = [
  CarReview(
    id: '1',
    userId: 'Pablo',
    carId: '1',
    description: 'Muito bom',
    value: 1.0,
    date: DateTime.now().add(Duration(days: -5)),
  ),
  CarReview(
    id: '2',
    userId: 'Vanessa',
    carId: '1',
    description:
        'bom, mas o cinto de segurança é traseiro curto, incompatível com cadeirinha infantil e o porta-malas é pequeno',
    value: 4,
    date: DateTime.now().add(Duration(days: -1)),
  ),
  CarReview(
    id: '3',
    userId: 'Ricardo',
    carId: '1',
    description: 'Já vi melhores',
    value: 3.5,
    date: DateTime.now(),
  ),
  CarReview(
    id: '4',
    userId: 'Igor',
    carId: '2',
    description: 'Tava bom, aí melhorou, agora parece que está pior',
    value: 3,
    date: DateTime.now(),
  ),
  CarReview(
    id: '5',
    userId: 'Juliana',
    carId: '2',
    description: 'Maravilindo!!! ❤❤❤ Adorei.',
    value: 5,
    date: DateTime.now(),
  ),
  CarReview(
    id: '6',
    userId: 'Henrique',
    carId: '2',
    description:
        'O Fiat Argo é um carro bastante econômico. Ainda mais as versões equipadas com o motor 1.0 Firefly Flex, que pode gerar 77 cv de potência e 10,9 kgfm de torque. Estes modelos podem fazer 13,5 km/l (gasolina) e 9,4 km/l (etanol) na cidade.',
    value: 4,
    date: DateTime.now(),
  ),
  CarReview(
    id: '7',
    userId: 'Rodolfo',
    carId: '3',
    description: 'Gostei! 🔝🔝🔝',
    value: 5,
    date: DateTime.now().add(Duration(days: -8)),
  ),
];
