import 'package:carshare/data/dummy_cars_review_data.dart';
import 'package:carshare/models/review.dart';
import 'package:flutter/cupertino.dart';

class ReviewList with ChangeNotifier {
  List<CarReview> _reviews = dummyCarsReviews;

  List<CarReview> get reviews => [..._reviews];

  void addCarReview(CarReview review) {
    _reviews.add(review);
    notifyListeners();
  }
}
