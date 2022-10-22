import 'package:carshare/data/dummy_cars_review_data.dart';
import 'package:carshare/models/car.dart';
import 'package:carshare/models/review.dart';
import 'package:carshare/models/review_list.dart';
import 'package:carshare/models/user.dart';
import 'package:carshare/models/user_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class UserReviewsScreen extends StatelessWidget {
  const UserReviewsScreen({Key? key}) : super(key: key);

  _descriptionSection(BuildContext context, String description) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      width: double.infinity,
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(left: 82),
            padding: EdgeInsets.only(bottom: 15),
            child: Row(children: [
              Flexible(
                child: Text(
                  description,
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 14),
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userInfo = ModalRoute.of(context)?.settings.arguments as User;

    final provider = Provider.of<UserReviewList>(context);
    final List<UserReview> userReviews = provider.reviews
        .where((review) => review.userIdRated == userInfo.id)
        .toList();

    final userProvider = Provider.of<UserList>(context);
    //final userInfo = userProvider.userByID(review.userIdRated);

    return Scaffold(
      appBar: AppBar(
        title: Text('Avaliações Recebidas'),
      ),
      body: ListView.builder(
          itemCount: userReviews.length,
          itemBuilder: (ctx, index) {
            final review = userReviews[index];
            final userInfo = userProvider.userByID(review.userIdEvaluator);
            return Card(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                      leading: CircleAvatar(
                        radius: 30,
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        child: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: FittedBox(),
                        ),
                      ),
                      title: Text(
                        userInfo.fullName,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      subtitle: Row(
                        children: [
                          Text(
                            '${DateFormat('d MMM y').format(review.date)}  ',
                          ),
                          RatingBarIndicator(
                            rating: review.rate,
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            itemCount: 5,
                            itemSize: 16.0,
                          )
                        ],
                      )),
                  _descriptionSection(context, review.description),
                ],
              ),
            );
          }),
      // body: Center(
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: const <Widget>[
      //       Text(
      //         'NOTAS E AVALIAÇÕES DO CARRO',
      //       ),
      //     ],
      //   ),
      // ),
    );
  }
}
