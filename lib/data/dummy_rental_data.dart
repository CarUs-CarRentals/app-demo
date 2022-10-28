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
      latitude: -26.7376,
      longitude: -49.1744,
      address: "",
    ),
    isReview: false,
  ),
  Rental(
    price: 159.99,
    id: "1",
    carId: '3',
    userId: 'yiKoZG8TSUhv1fd7W572vAn46M02',
    rentalDate: DateTime.now().add(Duration(days: -2)),
    returnDate: DateTime.now(),
    location: CarLocation(
      latitude: -26.7376,
      longitude: -49.1744,
      address: "",
    ),
    isReview: false,
  ),
  Rental(
    price: 39.99,
    id: "1",
    carId: '4',
    userId: 'yiKoZG8TSUhv1fd7W572vAn46M02',
    rentalDate: DateTime.now().add(Duration(days: -7)),
    returnDate: DateTime.now().add(Duration(days: -3)),
    location: CarLocation(
      latitude: -26.7376,
      longitude: -49.1744,
      address: "",
    ),
    isReview: false,
  )
];
