import 'dart:math';

import 'package:carshare/models/rental.dart';
import 'package:carshare/models/review.dart';
import 'package:carshare/providers/rentals.dart';
import 'package:carshare/providers/reviews.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';

class ReviewFormScreen extends StatefulWidget {
  const ReviewFormScreen({Key? key}) : super(key: key);

  @override
  State<ReviewFormScreen> createState() => _ReviewFormScreenState();
}

class _ReviewFormScreenState extends State<ReviewFormScreen> {
  bool _isLoading = false;
  bool _reviewCar = false;
  Rental? _rental;

  final _formKey = GlobalKey<FormState>();
  final _formData = Map<String, Object>();

  Future<void> _submitForm(bool reviewCar) async {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }

    context.loaderOverlay.show();
    setState(() {
      _isLoading = context.loaderOverlay.visible;
    });

    _formKey.currentState?.save();
    print("submit... ${_formData.values}");

    // final newCarReview = CarReview(
    //   id: _formData['id'] as int,
    //   rentalId: _formData['rentalId'] as int,
    //   userIdEvaluator: _formData['userIdEvaluator'] as String,
    //   carId: _formData['carId'] as int,
    //   description: _formData['description'] as String,
    //   rate: _formData['rating'] as double,
    //   date: DateTime.now(),
    // );

    // final newUserReview = UserReview(
    //   id: _formData['id'] as int,
    //   userIdRated: _formData['userIdRated'] as String,
    //   userIdEvaluator: _formData['userIdEvaluator'] as String,
    //   rentalId: _formData['rentalId'] as int,
    //   description: _formData['description'] as String,
    //   rate: _formData['rating'] as double,
    //   date: DateTime.now(),
    // );

    try {
      if (reviewCar) {
        await Provider.of<Reviews>(
          context,
          listen: false,
        ).saveCarReview(_formData).then((_) {
          _rental?.isReview = true;
          Provider.of<Rentals>(context, listen: false).updateRental(_rental!);
        });
      } else {
        await Provider.of<Reviews>(
          context,
          listen: false,
        ).saveUserReview(_formData).then((_) {
          _rental?.isReview = true;
          Provider.of<Rentals>(context, listen: false).updateRental(_rental!);
        });
      }

      //await Provider.of<Cars>(context, listen: false).loadCarsByUser();
      Navigator.of(context).pop();
    } catch (error) {
      if (_isLoading) {
        context.loaderOverlay.hide();
      }
      setState(() {
        _isLoading = context.loaderOverlay.visible;
      });
      await showDialog<void>(
          context: context,
          builder: (ctx) => AlertDialog(
                title: Text('Ocorreu um erro!'),
                content: Text(error.toString()),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'OK'),
                    child: const Text('OK'),
                  ),
                ],
              ));
    } finally {
      if (_isLoading) {
        context.loaderOverlay.hide();
      }
      setState(() {
        _isLoading = context.loaderOverlay.visible;
      });
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    if (_formData.isEmpty) {
      final arg = ModalRoute.of(context)?.settings.arguments as Map;

      if (arg != null) {
        final rental = arg['rental'] as Rental;
        final reviewCar = arg['reviewCar'] as bool;
        //final rental = arg;
        //['rental'] as Rental;
        //_formData['id'] = ;
        _formData['rentalId'] = rental.id;
        _formData['userIdRated'] = rental.userId;
        //_formData['userIdEvaluator']
        _formData['carId'] = rental.carId;
        _formData['description'] = "";
        _formData['rating'] = 0.0;
        _formData['date'] = DateTime.now();

        _reviewCar = reviewCar;
        _rental = rental;

        print("review Car: ${reviewCar}");
        print("rental ID: ${rental.id}");
        print("ratedUser: ${rental.userId}");
        print("ratedCar: ${rental.carId}");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    //final arg = ModalRoute.of(context)?.settings.arguments as Map;

    //final rentalDetail = arg['rental'] as Rental;
    //final reviewCar = arg['reviewCar'] as bool;

    final mediaQuery = MediaQuery.of(context);
    final availableHeight =
        mediaQuery.size.height - kToolbarHeight - mediaQuery.padding.top;

    return Scaffold(
      appBar: AppBar(
        title: Text("Avaliar"),
        actions: [
          IconButton(
              onPressed: () {
                //   _submitForm;
                // },
                FocusScope.of(context).requestFocus(new FocusNode());
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
                              Navigator.pop(context, 'Confirmar');
                              _submitForm(_reviewCar);
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
      body: LoaderOverlay(
        child: SizedBox(
          width: mediaQuery.size.width,
          height: availableHeight,
          child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Descrição da Avaliação',
                        alignLabelWithHint: true,
                      ),
                      initialValue: _formData['description'] as String,
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.multiline,
                      maxLines: 5,
                      onSaved: (description) {
                        _formData['description'] = description ?? '';
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
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20, left: 8, right: 8),
                    child: Column(
                      children: [
                        Text(
                          "Nota",
                        ),
                        RatingBar.builder(
                          initialRating: _formData['rating'] as double,
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
                            FocusScope.of(context)
                                .requestFocus(new FocusNode());
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
