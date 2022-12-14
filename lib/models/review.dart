class CarReview {
  final int id;
  final int rentalId;
  final String userIdEvaluator;
  final int carId;
  final String description;
  final double rate;
  final DateTime date;
  String userEvaluatorName;
  String evaluatorProfileImage;

  CarReview({
    required this.id,
    required this.rentalId,
    required this.userIdEvaluator,
    required this.carId,
    required this.description,
    required this.rate,
    required this.date,
    this.userEvaluatorName = '',
    this.evaluatorProfileImage = '',
  });
}

class UserReview {
  final int id;
  final String userIdRated;
  final String userIdEvaluator;
  final int rentalId;
  final String description;
  final double rate;
  final DateTime date;
  String userEvaluatorName;
  String evaluatorProfileImage;

  UserReview({
    required this.id,
    required this.userIdRated,
    required this.userIdEvaluator,
    required this.rentalId,
    required this.description,
    required this.rate,
    required this.date,
    this.userEvaluatorName = '',
    this.evaluatorProfileImage = '',
  });
}
