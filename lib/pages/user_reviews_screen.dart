import 'package:carshare/components/review_item.dart';
import 'package:carshare/models/review.dart';
import 'package:carshare/models/user.dart';
import 'package:carshare/providers/users.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserReviewsScreen extends StatelessWidget {
  const UserReviewsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userReviews =
        ModalRoute.of(context)?.settings.arguments as List<UserReview>;

    return Scaffold(
      appBar: AppBar(
        title: Text('Avaliações Recebidas'),
      ),
      body: ListView.builder(
          itemCount: userReviews.length,
          itemBuilder: (ctx, index) {
            final review = userReviews[index];
            return ReviewItem(
              imageProfile: review.evaluatorProfileImage,
              userName: review.userEvaluatorName,
              rating: review.rate,
              description: review.description,
              date: review.date,
            );
          }),
    );
  }
}
