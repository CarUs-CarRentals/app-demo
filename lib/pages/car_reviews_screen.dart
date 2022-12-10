import 'package:carshare/components/review_item.dart';
import 'package:carshare/models/car.dart';
import 'package:carshare/models/review.dart';
import 'package:carshare/models/user.dart';
import 'package:carshare/providers/reviews.dart';
import 'package:carshare/providers/users.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CarReviewsScreen extends StatefulWidget {
  const CarReviewsScreen({Key? key}) : super(key: key);

  @override
  State<CarReviewsScreen> createState() => _CarReviewsScreenState();
}

class _CarReviewsScreenState extends State<CarReviewsScreen> {
  bool _isLoading = true;
  List<User> _usersInfo = [];
  List<CarReview> _carReviews = [];
  Car? _car;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final availableHeight =
        mediaQuery.size.height - kToolbarHeight - mediaQuery.padding.top;

    final arg = ModalRoute.of(context)?.settings.arguments as Map;
    final carReviews = arg['carReviews'] as List<CarReview>;
    //final provider = Provider.of<Reviews>(context);
    //final carReviews = provider.carReviewsFromCar;
    _carReviews = carReviews;

    return Scaffold(
      appBar: AppBar(
        title: Text('Avaliações do Veículo'),
      ),
      body: _carReviews.length == 0
          ? SizedBox(
              width: mediaQuery.size.width,
              height: availableHeight,
              child: Center(
                child: Text('Sem registros'),
              ),
            )
          : ListView.builder(
              itemCount: _carReviews.length,
              itemBuilder: (ctx, index) {
                return ReviewItem(
                  imageProfile: _carReviews[index].evaluatorProfileImage,
                  userName: _carReviews[index].userEvaluatorName,
                  rating: _carReviews[index].rate,
                  description: _carReviews[index].description,
                  date: _carReviews[index].date,
                );
              }),
    );
  }
}
