import 'package:carshare/data/dummy_cars_review_data.dart';
import 'package:carshare/data/dummy_rental_data.dart';
import 'package:carshare/data/dummy_users_review_data.dart';
import 'package:carshare/models/rental.dart';
import 'package:flutter/cupertino.dart';

class RentalList with ChangeNotifier {
  List<Rental> _rentals = dummyRentals;

  List<Rental> get rentals => [..._rentals];

  void addRental(Rental rental) {
    _rentals.add(rental);
    notifyListeners();
  }
}
