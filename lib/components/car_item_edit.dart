import 'package:carshare/models/car.dart';
import 'package:carshare/models/car_list.dart';
import 'package:carshare/models/user.dart';
import 'package:carshare/models/user_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:loader_overlay/loader_overlay.dart';
import '../utils/app_routes.dart';

class CarItemEdit extends StatefulWidget {
  final Car car;

  const CarItemEdit(
    this.car, {
    Key? key,
  }) : super(key: key);

  @override
  State<CarItemEdit> createState() => _CarItemState();
}

class _CarItemState extends State<CarItemEdit> {
  User? carUser;
  bool _isLoading = true;

  Future<void> _getCarHost(String userId) async {
    await Provider.of<UserList>(context, listen: false).loadUserById(userId);
    final provider = Provider.of<UserList>(context, listen: false);
    carUser = provider.userByID;
    print(carUser?.fullName);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _getCarHost(widget.car.userId);
  }

  _bottomSection(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                widget.car.shortDescription,
                textAlign: TextAlign.left,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SizedBox(width: 6),
                        const Icon(
                          Icons.star,
                          size: 16,
                        ),
                        Text(('widget.car.review').toString()),
                        const VerticalDivider(
                          width: 10,
                        ),
                        Text(
                          "99 Locações",
                        ),
                      ],
                    ),
                  ],
                ),
                Divider(),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          style: TextButton.styleFrom(
                            textStyle: const TextStyle(fontSize: 16),
                            padding: EdgeInsets.symmetric(horizontal: 3),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            minimumSize: Size(50, 30),
                          ),
                          onPressed: () => Navigator.of(context).pushNamed(
                            AppRoutes.CAR_DETAIL,
                            arguments: {
                              'car': widget.car,
                              'user': carUser,
                            },
                          ),
                          child: const Text('Visualizar'),
                        ),
                        VerticalDivider(
                          width: 10,
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                            textStyle: const TextStyle(fontSize: 16),
                            padding: EdgeInsets.symmetric(horizontal: 3),
                            minimumSize: Size(50, 30),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          onPressed: () => Navigator.of(context).pushNamed(
                              AppRoutes.CAR_FORM,
                              arguments: widget.car),
                          child: const Text('Editar'),
                        ),
                        VerticalDivider(
                          width: 10,
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                            textStyle: const TextStyle(fontSize: 16),
                            padding: EdgeInsets.symmetric(horizontal: 3),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            minimumSize: Size(50, 30),
                          ),
                          onPressed: () => Navigator.of(context).pushNamed(
                            AppRoutes.CAR_HISTORY,
                            arguments: widget.car,
                          ),
                          child: const Text('Histórico'),
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   _getCarHost(widget.car.userId);
  // }

  @override
  void initState() {
    super.initState();

    context.loaderOverlay.show();
    setState(() {
      _isLoading = context.loaderOverlay.visible;
    });

    Provider.of<UserList>(context, listen: false)
        .loadUserById(widget.car.userId)
        .then((value) {
      setState(() {
        if (_isLoading) {
          context.loaderOverlay.hide();
        }
        setState(() {
          _isLoading = context.loaderOverlay.visible;
          _getCarHost(widget.car.userId);
        });
      });
    });

    Provider.of<CarList>(context, listen: false).loadCarsByUser().then((value) {
      setState(() {
        if (_isLoading) {
          context.loaderOverlay.hide();
        }
        setState(() {
          _isLoading = context.loaderOverlay.visible;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Column(
        children: [
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            elevation: 4,
            margin:
                const EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 10),
            child: Column(children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                    ),
                    child: Image.network(
                      widget.car.imagesUrl[0].url,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
              _bottomSection(context),
            ]),
          ),
        ],
      ),
    );
  }
}
