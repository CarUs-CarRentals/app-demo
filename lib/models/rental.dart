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
  final Car? car;
  final String userId;
  final DateTime rentalDate;
  final DateTime returnDate;
  final double price;
  final CarLocation location;
  final bool isReview;
  RentalStatus status;

  Rental({
    this.price = 0,
    this.car,
    required this.id,
    required this.carId,
    required this.userId,
    required this.rentalDate,
    required this.returnDate,
    required this.location,
    required this.isReview,
    required this.status,
  });

  static String getRentalStatusText(RentalStatus rentalStatus) {
    switch (rentalStatus) {
      case RentalStatus.IN_PROGRESS:
        return 'Em andamento';
      case RentalStatus.LATE:
        return 'Devolução em atraso';
      case RentalStatus.PENDING:
        return 'Pendente de aprovação';
      case RentalStatus.REFUSED:
        return 'Locação recusada';
      case RentalStatus.RENTED:
        return 'Locação concluída';
      case RentalStatus.RESERVED:
        return 'Locação reservada';
      default:
        return 'Desconhecido';
    }
  }
}
