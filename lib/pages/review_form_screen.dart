import 'dart:math';

import 'package:carshare/models/rental.dart';
import 'package:carshare/models/review.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ReviewFormScreen extends StatefulWidget {
  const ReviewFormScreen({Key? key}) : super(key: key);

  @override
  State<ReviewFormScreen> createState() => _ReviewFormScreenState();
}

class _ReviewFormScreenState extends State<ReviewFormScreen> {
  late double _rating;

  double _initialRating = 1.0;

  final _formKey = GlobalKey<FormState>();
  final _formData = Map<String, Object>();

  void _submitForm() {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }

    _formKey.currentState?.save();
    print("submit... ${_formData.values}");

    final newCarReview = CarReview(
      id: Random().nextDouble().toString(),
      rentalId: _formData['rentalId'] as String,
      userIdEvaluator: _formData['userIdEvaluator'] as String,
      carId: _formData['carId'] as String,
      description: _formData['description'] as String,
      rate: _formData['rating'] as double,
      date: DateTime.now(),
    );
  }

  @override
  void initState() {
    super.initState();
    _rating = _initialRating;
  }

  @override
  Widget build(BuildContext context) {
    final rentalDetail = ModalRoute.of(context)?.settings.arguments as Rental;

    return Scaffold(
      appBar: AppBar(
        title: Text("Avaliar"),
        actions: [
          IconButton(
              onPressed: () {
                //   _submitForm;
                // },
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Confirmar Avaliação"),
                        content: Text("Deseja confirmar sua avaliação?"),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.pop(context, 'Cancelar'),
                            child: const Text('Cancelar'),
                          ),
                          TextButton(
                            onPressed: () {
                              _submitForm();
                              Navigator.pop(context, 'Confirmar');
                            },
                            child: const Text('Confirmar'),
                          ),
                        ],
                      );
                    });
              },
              icon: Icon(Icons.save))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Form(
            key: _formKey,
            child: ListView(
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Descrição da Avaliação',
                    alignLabelWithHint: true,
                  ),
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.multiline,
                  maxLines: 5,
                  onSaved: (description) {
                    _formData['description'] = description ?? '';
                    _formData['rentalId'] = rentalDetail.id;
                    _formData['userIdEvaluator'] = rentalDetail.userId;
                    _formData['carId'] = rentalDetail.carId;
                  },
                  validator: (_description) {
                    final description = _description ?? '';

                    if (description.trim().isEmpty) {
                      return 'Descrição é obrigatório';
                    }

                    if (description.trim().length < 9) {
                      return 'Descrição precisa ser mais longa';
                    }

                    return null;
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20, left: 8, right: 8),
                  child: Column(
                    children: [
                      Text(
                        "Nota",
                      ),
                      RatingBar.builder(
                        initialRating: 1,
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                        itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        onRatingUpdate: (_rating) {
                          _formData['rating'] = _rating;
                        },
                      ),
                    ],
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
