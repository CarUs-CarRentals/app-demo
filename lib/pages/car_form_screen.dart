import 'package:carshare/components/car_form.dart';
import 'package:carshare/exceptions/http_exceptions.dart';
import 'package:carshare/models/car.dart';
import 'package:carshare/models/car_list.dart';
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

    return Scaffold(
        appBar: AppBar(
          title: const Text('Formulario Carro'),
          actions: [
            if (arg != null)
              IconButton(
                onPressed: () {
                  final car = arg as Car;
                  showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: Text("Excluir carro"),
                      content: Text("Deseja confirmar a exclusão?"),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
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
                        await Provider.of<CarList>(context, listen: false)
                            .removeCar(car);
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
                icon: const Icon(Icons.delete),
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
