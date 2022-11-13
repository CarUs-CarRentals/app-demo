import 'package:carshare/components/car_form.dart';
import 'package:carshare/models/car.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'package:numberpicker/numberpicker.dart';

class CarFormScreen extends StatefulWidget {
  const CarFormScreen({Key? key}) : super(key: key);

  @override
  State<CarFormScreen> createState() => _CarFormScreenState();
}

class _CarFormScreenState extends State<CarFormScreen> {
  // final _priceFocus = FocusNode();

  // final _formKey = GlobalKey<FormState>();
  // final _formData = Map<String, Object>();

  // String dropdownValue = '2022';
  // int _currentTrunkValue = 1;

  // final List<String> yearsList =
  //     List.generate(100, (int index) => (2022 - index).toString());

  // String getFuelText(CarFuel fuel) {
  //   switch (fuel) {
  //     case CarFuel.petrol:
  //       return 'Gasolina';
  //     case CarFuel.diesel:
  //       return 'Diesel';
  //     case CarFuel.cng:
  //       return 'GNV';
  //     case CarFuel.electric:
  //       return 'Elétrico';
  //     case CarFuel.ethanol:
  //       return 'Etanol';
  //     default:
  //       return 'Desconhecido';
  //   }
  // }

  // String getGearShiftText(CarGearShift gearShift) {
  //   switch (gearShift) {
  //     case CarGearShift.automatic:
  //       return 'Automático';
  //     case CarGearShift.manual:
  //       return 'Manual';
  //     default:
  //       return 'Desconhecido';
  //   }
  // }

  // String getCategoryText(CarCategory category) {
  //   switch (category) {
  //     case CarCategory.suv:
  //       return 'SUV';
  //     case CarCategory.sedan:
  //       return 'Sedã';
  //     case CarCategory.hatchback:
  //       return 'Hatch';
  //     case CarCategory.sport:
  //       return 'Esportivo';
  //     case CarCategory.convertible:
  //       return 'Conversível';
  //     case CarCategory.wagon:
  //       return 'Perua';
  //     case CarCategory.truck:
  //       return 'Picape';
  //     default:
  //       return 'Desconhecido';
  //   }
  // }

  // _spinBoxSection(BuildContext context) {
  //   return Container(
  //     padding: const EdgeInsets.all(20),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //       children: [
  //         Column(
  //           children: [
  //             Text('Portas', style: Theme.of(context).textTheme.subtitle1),
  //             Padding(
  //               padding: const EdgeInsets.symmetric(vertical: 20),
  //               child: SpinBox(
  //                 min: 1,
  //                 max: 10,
  //                 value: 1,
  //                 decoration: InputDecoration(border: InputBorder.none),
  //                 onChanged: (value) => print(value),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    //_priceFocus.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return Scaffold(
        appBar: AppBar(
          title: Text('Formulario Carro'),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: CarForm(),
        ));
  }
}
