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
  final _priceFocus = FocusNode();

  final _formKey = GlobalKey<FormState>();
  final _formData = Map<String, Object>();

  String dropdownValue = '2022';
  int _currentTrunkValue = 1;

  final List<String> yearsList =
      List.generate(100, (int index) => (2022 - index).toString());

  String getFuelText(CarFuel fuel) {
    switch (fuel) {
      case CarFuel.petrol:
        return 'Gasolina';
      case CarFuel.diesel:
        return 'Diesel';
      case CarFuel.cng:
        return 'GNV';
      case CarFuel.electric:
        return 'Elétrico';
      case CarFuel.ethanol:
        return 'Etanol';
      default:
        return 'Desconhecido';
    }
  }

  String getGearShiftText(CarGearShift gearShift) {
    switch (gearShift) {
      case CarGearShift.automatic:
        return 'Automático';
      case CarGearShift.manual:
        return 'Manual';
      default:
        return 'Desconhecido';
    }
  }

  String getCategoryText(CarCategory category) {
    switch (category) {
      case CarCategory.suv:
        return 'SUV';
      case CarCategory.sedan:
        return 'Sedã';
      case CarCategory.hatchback:
        return 'Hatch';
      case CarCategory.sport:
        return 'Esportivo';
      case CarCategory.convertible:
        return 'Conversível';
      case CarCategory.wagon:
        return 'Perua';
      case CarCategory.truck:
        return 'Picape';
      default:
        return 'Desconhecido';
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _priceFocus.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return Scaffold(
        appBar: AppBar(
          title: Text('Formulario Carro'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Form(
            child: ListView(
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: 'Marca'),
                  textInputAction: TextInputAction.next,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Modelo'),
                  textInputAction: TextInputAction.next,
                ),
                DropdownButtonFormField(
                  decoration: InputDecoration(labelText: 'Ano'),
                  // onTap: () {
                  //   FocusScope.of(context).requestFocus(_priceFocus);
                  // },
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownValue = newValue!;
                    });
                  },
                  items:
                      yearsList.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Center(
                        child: Text(
                          value,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Placa'),
                  textInputAction: TextInputAction.next,
                ),
                DropdownButtonFormField(
                  decoration: InputDecoration(labelText: 'Combustivel'),
                  //value: dropdownValue,
                  // onTap: () {
                  //   FocusScope.of(context).requestFocus(_priceFocus);
                  // },
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownValue = newValue!;
                    });
                  },
                  items: CarFuel.values
                      .map<DropdownMenuItem<String>>((CarFuel value) {
                    return DropdownMenuItem<String>(
                      value: getFuelText(value),
                      child: Center(
                        child: Text(
                          getFuelText(value),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                DropdownButtonFormField(
                  decoration: InputDecoration(labelText: 'Câmbio'),
                  //value: dropdownValue,
                  // onTap: () {
                  //   FocusScope.of(context).requestFocus(_priceFocus);
                  // },
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownValue = newValue!;
                    });
                  },
                  items: CarGearShift.values
                      .map<DropdownMenuItem<String>>((CarGearShift value) {
                    return DropdownMenuItem<String>(
                      value: getGearShiftText(value),
                      child: Center(
                        child: Text(
                          getGearShiftText(value),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                DropdownButtonFormField(
                  decoration: InputDecoration(labelText: 'Categoria'),
                  //value: dropdownValue,
                  // onTap: () {
                  //   FocusScope.of(context).requestFocus(_priceFocus);
                  // },
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownValue = newValue!;
                    });
                  },
                  items: CarCategory.values
                      .map<DropdownMenuItem<String>>((CarCategory value) {
                    return DropdownMenuItem<String>(
                      value: getCategoryText(value),
                      child: Center(
                        child: Text(
                          getCategoryText(value),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                TextFormField(
                  decoration:
                      InputDecoration(labelText: 'Porta-malas (Litros)'),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    //FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  textInputAction: TextInputAction.next,
                ),
                SizedBox(height: 16),
                Column(
                  children: [
                    Text('Quantidade de Portas',
                        style: Theme.of(context).textTheme.subtitle1),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: SpinBox(
                        min: 1,
                        max: 10,
                        value: 1,
                        decoration: InputDecoration(border: InputBorder.none),
                        onChanged: (value) => print(value),
                      ),
                    ),
                  ],
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Preço'),
                  textInputAction: TextInputAction.next,
                  focusNode: _priceFocus,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Descrição do veículo',
                    alignLabelWithHint: true,
                  ),
                  textInputAction: TextInputAction.next,
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
              ],
            ),
          ),
        ));
  }
}
