import 'package:carshare/models/car.dart';

class Rental {
  final String id;
  final String carId;
  final String userId;
  final DateTime rentalDate;
  final DateTime? returnDate;
  final double price;
  final CarLocation location;
  final bool isReview;

  Rental({
    this.price = 0,
    required this.id,
    required this.carId,
    required this.userId,
    required this.rentalDate,
    this.returnDate,
    required this.location,
    required this.isReview,
  });
}
