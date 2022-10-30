import 'package:carshare/models/car.dart';
import 'package:carshare/models/rental.dart';

List<Rental> dummyRentals = [
  Rental(
    price: 99.99,
    id: "1",
    carId: '2',
    userId: 'yiKoZG8TSUhv1fd7W572vAn46M02',
    rentalDate: DateTime.now(),
    location: CarLocation(
      latitude: -26.9069,
      longitude: -49.0760,
      address:
          "R. São Paulo, 1147 - Victor Konder, Blumenau - SC, 89012-001, Brazil",
    ),
    isReview: false,
  ),
  Rental(
    price: 159.99,
    id: "2",
    carId: '3',
    userId: 'yiKoZG8TSUhv1fd7W572vAn46M02',
    rentalDate: DateTime.now().add(Duration(days: -2)),
    returnDate: DateTime.now(),
    location: CarLocation(
      latitude: -26.8958,
      longitude: -49.2484,
      address: "R. Timbó, 337 - Rio Morto, Indaial - SC, 89130-000, Brazil",
    ),
    isReview: true,
  ),
  Rental(
    price: 39.99,
    id: "3",
    carId: '4',
    userId: 'yiKoZG8TSUhv1fd7W572vAn46M02',
    rentalDate: DateTime.now().add(Duration(days: -7)),
    returnDate: DateTime.now().add(Duration(days: -3)),
    location: CarLocation(
      latitude: -26.5074,
      longitude: -49.1288,
      address:
          "Parque Malwee - Rua Wolfgang Weege, 770, Jaraguá do Sul - SC, 89262-000, Brazil",
    ),
    isReview: true,
  ),
  Rental(
    price: 39.99,
    id: "4",
    carId: '1',
    userId: 'yiKoZG8TSUhv1fd7W572vAn46M02',
    rentalDate: DateTime.now().add(Duration(days: -8)),
    returnDate: DateTime.now().add(Duration(days: -7)),
    location: CarLocation(
      latitude: -26.7376,
      longitude: -49.1744,
      address:
          "Rua Hermann Weege, 151 - Centro, Pomerode - SC, 89107-000, Brasil",
    ),
    isReview: true,
  )
];
