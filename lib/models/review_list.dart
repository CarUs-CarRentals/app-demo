import 'package:carshare/data/dummy_cars_review_data.dart';
import 'package:carshare/models/review.dart';
import 'package:flutter/cupertino.dart';

class ReviewList with ChangeNotifier {
  List<Review> _reviews = dummyReviewsCars;

  List<Review> get reviews => [..._reviews];

  void addCarReview(Review review) {
    _reviews.add(review);
    notifyListeners();
  }
}
