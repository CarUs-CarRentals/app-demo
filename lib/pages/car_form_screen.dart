import 'package:carshare/components/car_form.dart';
import 'package:carshare/exceptions/http_exceptions.dart';
import 'package:carshare/models/car.dart';
import 'package:carshare/providers/cars.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:provider/provider.dart';

class CarFormScreen extends StatefulWidget {
  const CarFormScreen({Key? key}) : super(key: key);

  @override
  State<CarFormScreen> createState() => _CarFormScreenState();
}

class _CarFormScreenState extends State<CarFormScreen> {
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    //_priceFocus.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final arg = ModalRoute.of(context)?.settings.arguments;
    final snackMsg = ScaffoldMessenger.of(context);
    final car = arg as Car;

    return Scaffold(
        appBar: AppBar(
          title: const Text('Formulario Carro'),
          actions: [
            if (arg != null)
              car.active == true
                  ? IconButton(
                      onPressed: () {
                        showDialog<bool>(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: Text("Inativar carro"),
                            content: Text(
                                "Deseja confirmar a inativação?\n\nO carro não estará mais disponivel para locação ao inativa-lo."),
                            actions: [
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                                child: Text("Não"),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(true);
                                },
                                child: Text("Sim"),
                              )
                            ],
                          ),
                        ).then((value) async {
                          if (value ?? false) {
                            try {
                              car.active = false;
                              await Provider.of<Cars>(context, listen: false)
                                  .inactivateCar(car);
                              await Provider.of<Cars>(context, listen: false)
                                  .updateCar(car);
                              Navigator.of(context).pop();
                            } on HttpException catch (error) {
                              snackMsg.showSnackBar(SnackBar(
                                content: Text(
                                  error.toString(),
                                ),
                              ));
                            }
                          }
                        });
                      },
                      icon: Icon(Icons.lock),
                    )
                  : IconButton(
                      onPressed: () {
                        showDialog<bool>(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: Text("Ativar carro"),
                            content: Text(
                                "Deseja confirmar a ativação?\n\nO carro estará disponivel para locação novamente."),
                            actions: [
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                                child: Text("Não"),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(true);
                                },
                                child: Text("Sim"),
                              )
                            ],
                          ),
                        ).then((value) async {
                          if (value ?? false) {
                            try {
                              car.active = true;
                              await Provider.of<Cars>(context, listen: false)
                                  .updateCar(car);
                              Navigator.of(context).pop();
                            } on HttpException catch (error) {
                              snackMsg.showSnackBar(SnackBar(
                                content: Text(
                                  error.toString(),
                                ),
                              ));
                            }
                          }
                        });
                      },
                      icon: Icon(Icons.lock_open),
                    )
          ],
        ),
        body: const LoaderOverlay(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: CarForm(),
          ),
        ));
  }
}
