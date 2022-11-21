import 'package:carshare/models/car.dart';

enum RentalStatus {
  IN_PROGRESS,
  RENTED,
  PENDING,
  LATE,
  RESERVED,
  REFUSED,
}

class Rental {
  final int id;
  final int carId;
  final String userId;
  final DateTime rentalDate;
  final DateTime returnDate;
  final double price;
  final CarLocation location;
  final bool isReview;
  final RentalStatus status;

  Rental({
    this.price = 0,
    required this.id,
    required this.carId,
    required this.userId,
    required this.rentalDate,
    required this.returnDate,
    required this.location,
    required this.isReview,
    required this.status,
  });
}
