import 'dart:io';

import 'package:carshare/models/car.dart';
import 'package:carshare/widgets/image_input.dart';
import 'package:carshare/widgets/location_input.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';

class CarForm extends StatefulWidget {
  const CarForm({Key? key}) : super(key: key);

  @override
  State<CarForm> createState() => _CarFormState();
}

class _CarFormState extends State<CarForm> {
  final _priceFocus = FocusNode();
  final _formKey = GlobalKey<FormState>();
  final _formData = Map<String, Object>();

  String dropdownValue = '2022';
  int _currentTrunkValue = 1;
  File _pickedImage = File('');

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

  _spinBoxSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            children: [
              Text('Portas', style: Theme.of(context).textTheme.subtitle1),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
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
        ],
      ),
    );
  }

  void _selectImage(File pickedImage) {
    _pickedImage = pickedImage;
  }

  void _submitForm() {
    print("Guardar dados do carro");
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _priceFocus.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: ListView(
        children: [
          Column(
            children: [
              SizedBox(
                height: 10,
              ),
              GridView.builder(
                  shrinkWrap: true,
                  itemCount: 6,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1,
                    mainAxisExtent: 120,
                  ),
                  itemBuilder: (context, index) {
                    return ImageInput(this._selectImage);
                  }),
              Divider(
                height: 50,
              ),
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
                items: yearsList.map<DropdownMenuItem<String>>((String value) {
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
                decoration: InputDecoration(labelText: 'Porta-malas (Litros)'),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  //FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  FilteringTextInputFormatter.digitsOnly
                ],
                textInputAction: TextInputAction.next,
              ),
              Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                Expanded(
                  child: SpinBoxTheme(
                    data: SpinBoxThemeData(
                        decoration: InputDecoration(
                            border: UnderlineInputBorder(),
                            //labelText: "teste",
                            label: Text(
                              "Portas",
                              style: TextStyle(
                                fontSize: 22,
                              ),
                            ))),
                    child: Padding(
                      padding: const EdgeInsets.only(right: 4.0),
                      child: SpinBox(
                        textStyle: TextStyle(height: 3.5),
                        min: 1,
                        max: 99,
                        value: 1,
                        onChanged: (value) => print(value),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: SpinBoxTheme(
                      data: SpinBoxThemeData(
                          decoration: InputDecoration(
                              border: UnderlineInputBorder(),
                              label: Text(
                                "Assentos",
                                style: TextStyle(
                                  fontSize: 22,
                                ),
                              ))),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 4.0),
                        child: SpinBox(
                          textStyle: TextStyle(height: 3.5),
                          min: 1,
                          max: 99,
                          value: 1,
                          onChanged: (value) => print(value),
                        ),
                      )),
                )
              ]),
              Divider(
                height: 50,
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
              Divider(
                height: 50,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Preço'),
                textInputAction: TextInputAction.next,
                focusNode: _priceFocus,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
              Divider(
                height: 50,
              ),
              LocationInput(),
            ],
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {});
            },
            style: ElevatedButton.styleFrom(
              primary: Theme.of(context).colorScheme.primary,
            ),
            child: Text(
              'Cadastrar',
              style: TextStyle(fontSize: 20),
            ),
          ),
        ],
      ),
    );
  }
}
