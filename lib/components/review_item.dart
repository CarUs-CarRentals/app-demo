import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';

class ReviewItem extends StatelessWidget {
  final String userName;
  final double rating;
  final String description;
  final DateTime date;
  const ReviewItem({
    Key? key,
    required this.userName,
    required this.rating,
    required this.description,
    required this.date,
  }) : super(key: key);

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
                userName,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              subtitle: Row(
                children: [
                  Text(
                    '${DateFormat('d MMM y').format(date)}  ',
                  ),
                  RatingBarIndicator(
                    rating: rating,
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    itemCount: 5,
                    itemSize: 16.0,
                  )
                ],
              )),
          _descriptionSection(context, description),
        ],
      ),
    );
  }
}
