class CarReview {
  final String id;
  final String userIdEvaluator;
  final String carId;
  final String description;
  final double rate;
  final DateTime date;

  CarReview({
    required this.id,
    required this.userIdEvaluator,
    required this.carId,
    required this.description,
    required this.rate,
    required this.date,
  });
}

class UserReview {
  final String id;
  final String userIdRated;
  final String userIdEvaluator;
  final String description;
  final double rate;
  final DateTime date;

  UserReview({
    required this.id,
    required this.userIdRated,
    required this.userIdEvaluator,
    required this.description,
    required this.rate,
    required this.date,
  });
}

