import 'package:carshare/components/review_item.dart';
import 'package:carshare/models/review.dart';
import 'package:carshare/models/review_list.dart';
import 'package:carshare/models/user.dart';
import 'package:carshare/providers/users.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserReviewsScreen extends StatelessWidget {
  const UserReviewsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userInfo = ModalRoute.of(context)?.settings.arguments as User;

    final provider = Provider.of<UserReviewList>(context);
    final List<UserReview> userReviews = provider.reviews
        .where((review) => review.userIdRated == userInfo.id)
        .toList();

    final userProvider = Provider.of<Users>(context);
    //final userInfo = userProvider.userByID(review.userIdRated);

    return Scaffold(
      appBar: AppBar(
        title: Text('Avaliações Recebidas'),
      ),
      body: ListView.builder(
          itemCount: userReviews.length,
          itemBuilder: (ctx, index) {
            final review = userReviews[index];
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
