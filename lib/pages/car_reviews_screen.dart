import 'package:carshare/components/review_item.dart';
import 'package:carshare/models/car.dart';
import 'package:carshare/models/review.dart';
import 'package:carshare/models/review_list.dart';
import 'package:carshare/providers/users.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CarReviewsScreen extends StatelessWidget {
  const CarReviewsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final carInfo = ModalRoute.of(context)?.settings.arguments as Car;

    final provider = Provider.of<CarReviewList>(context);
    final List<CarReview> carReviews =
        provider.reviews.where((review) => review.carId == carInfo.id).toList();
    final userProvider = Provider.of<Users>(context);

    print("carINFO: ${carInfo.id}");

    return Scaffold(
      appBar: AppBar(
        title: Text('Avaliações do Veículo'),
      ),
      body: ListView.builder(
          itemCount: carReviews.length,
          itemBuilder: (ctx, index) {
            final review = carReviews[index];
            final userInfo = "userProvider.userByID(review.userIdEvaluator)";
            return ReviewItem(
              userName: "userInfo.fullName",
              rating: review.rate,
              description: review.description,
              date: review.date,
            );
          }),
    );
  }
}
