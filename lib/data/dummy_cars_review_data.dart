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
];
