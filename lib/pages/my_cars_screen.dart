import 'package:carshare/components/car_item.dart';
import 'package:carshare/components/car_item_edit.dart';
import 'package:carshare/components/cars_list_view.dart';
import 'package:carshare/models/auth.dart';
import 'package:carshare/models/car.dart';
import 'package:carshare/providers/cars.dart';
import 'package:carshare/models/user.dart';
import 'package:carshare/providers/users.dart';
import 'package:carshare/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:loader_overlay/loader_overlay.dart';

class MyCarsScreen extends StatefulWidget {
  const MyCarsScreen({Key? key}) : super(key: key);

  @override
  State<MyCarsScreen> createState() => _MyCarsScreenState();
}

class _MyCarsScreenState extends State<MyCarsScreen> {
  bool _isLoading = true;
  //List<Car>? _myCars;
  // Future<void> _getMyCars() async {
  //   Provider.of<CarList>(context, listen: false).loadCarsByUser;
  // }

  @override
  void initState() {
    super.initState();

    setState(() {
      _isLoading = true;
    });

    Provider.of<Cars>(context, listen: false).loadCarsByUser().then((value) {
      setState(() {
        if (_isLoading) {
          _isLoading = false;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final availableHeight =
        mediaQuery.size.height - kToolbarHeight - mediaQuery.padding.top;
    final provider = Provider.of<Cars>(context);
    final List<Car> carsUser = provider.carsFromUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('Meus Carros'),
        actions: [
          IconButton(
              onPressed: () => Navigator.of(context).pushNamed(
                    AppRoutes.CAR_FORM,
                  ),
              icon: Icon(Icons.add))
        ],
      ),
      body: SingleChildScrollView(
        child: LoaderOverlay(
          overlayOpacity: 1,
          overlayColor: Colors.white,
          child: SizedBox(
            width: mediaQuery.size.width,
            height: availableHeight,
            child: _isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : carsUser.length > 0
                    ? ListView.builder(
                        itemCount: carsUser.length,
                        itemBuilder: (context, index) {
                          final car = carsUser[index];
                          print(car.id);
                          return CarItemEdit(car);
                        },
                      )
                    : const Center(child: Text('Sem registros')),
          ),
        ),
      ),
    );
  }
}
