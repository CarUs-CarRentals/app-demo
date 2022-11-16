import 'dart:io';

import 'package:carshare/data/store.dart';
import 'package:carshare/models/car.dart';
import 'package:carshare/models/car_list.dart';
import 'package:carshare/utils/location_util.dart';
import 'package:carshare/widgets/image_input.dart';
import 'package:carshare/widgets/location_input.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class CarForm extends StatefulWidget {
  const CarForm({Key? key}) : super(key: key);

  @override
  State<CarForm> createState() => _CarFormState();
}

class _CarFormState extends State<CarForm> {
  final _priceFocus = FocusNode();
  final _formKey = GlobalKey<FormState>();
  final _formData = Map<String, Object>();
  bool _editMode = false;

  //String dropdownValue = '2022';
  CarFuel? _dropdownFuelValue;
  CarGearShift? _dropdownGearValue;
  CarCategory? _dropdownCategoryValue;
  int? _dropdownYearValue;
  int _doorsValue = 1;
  int _seatsValue = 1;

  File _pickedImage = File('');
  CarImages _carImage = CarImages(url: '');
  LatLng? _latLngSelected;
  String _carAddress = '';
  String? _userId;
  List<File> _pickedImagesList = [];
  List<CarImages> _carImagesUrl = [];
  CarLocation _carLocation =
      const CarLocation(latitude: 0, longitude: 0, address: '');
  UploadTask? uploadTask;
  final _firebaseStorage = FirebaseStorage.instance;

  final List<int> yearsList = List.generate(100, (int index) => (2022 - index));

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
    print("img recebida: ${_pickedImage.path}");
    if (_pickedImage.path == "") {
      return;
    }

    int indexImg = _pickedImagesList
        .indexWhere((element) => element.path == _pickedImage.path);

    if (indexImg >= 0) {
      _pickedImagesList.removeAt(indexImg);
      if (_carImagesUrl.length > indexImg) {
        _carImagesUrl.removeAt(indexImg);
      }
    } else {
      // if (_carImagesUrl.map((item) => item.url).contains(_pickedImage.path)) {
      //   int index = _carImagesUrl
      //       .indexWhere((element) => element.url == _pickedImage.path);
      //   _carImagesUrl.remove(_carImagesUrl[index]);

      _pickedImagesList.add(_pickedImage);
    }
  }

  void _selectLocation(LatLng selectedLocation) async {
    _latLngSelected = selectedLocation;

    print(_carLocation.address);

    await LocationUtil.getAddressFrom(selectedLocation).then((value) {
      setState(() {
        _carAddress = value;
      });
    });

    _carLocation = CarLocation(
      latitude: _latLngSelected!.latitude,
      longitude: _latLngSelected!.longitude,
      address: _carAddress.toString(),
    );

    _formData['location'] = _carLocation;
  }

  void _submitForm() async {
    _getCurrentUserId();

    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }

    _pickedImagesList.removeWhere((element) => element.path == "");

    for (var imageFile in _pickedImagesList) {
      try {
        if (!imageFile.path.startsWith("https://")) {
          await _uploadImage(imageFile);
        } else {
          _formData['imagesUrl'] = _carImagesUrl;
        }
      } catch (e) {
        throw UnsupportedError('Erro ao fazer o upload');
      }
    }
    _formKey.currentState?.save();

    Provider.of<CarList>(
      context,
      listen: false,
    ).saveCar(_formData);
    Navigator.of(context).pop();
  }

  void _getCurrentUserId() async {
    final userData = await Store.getMap('userDataFb');
    _userId = userData['localId'];
    _formData['userId'] = _userId as String;
  }

  _uploadImage(File pickedImage) async {
    final fileName =
        pickedImage.path.substring(pickedImage.path.lastIndexOf('/'));
    final path = 'images/${_userId}/${fileName}';

    final ref = _firebaseStorage.ref().child(path);
    uploadTask = ref.putFile(pickedImage);

    final snapshot = await uploadTask!.whenComplete(() => null);

    final urlDownload = await snapshot.ref.getDownloadURL();

    if (urlDownload != '') {
      _carImage = CarImages(url: urlDownload);
      _carImagesUrl.add(_carImage);
      _formData['imagesUrl'] = _carImagesUrl;
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _priceFocus.dispose();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    if (_formData.isEmpty) {
      final arg = ModalRoute.of(context)?.settings.arguments;

      if (arg != null) {
        final car = arg as Car;
        _formData['id'] = car.id;
        _formData['brand'] = car.brand;
        _formData['model'] = car.model;
        _formData['doors'] = car.doors;
        _formData['fuel'] = car.fuel;
        _formData['gearShift'] = car.gearShift;
        _formData['plate'] = car.plate;
        _formData['seats'] = car.seats;
        _formData['trunk'] = car.trunk;
        _formData['year'] = car.year;
        _formData['userId'] = car.userId;
        _formData['category'] = car.category;
        _formData['imagesUrl'] = car.imagesUrl;
        _formData['price'] = car.price;
        _formData['location'] = car.location;
        _formData['description'] = car.description;

        _editMode = true;
        _carImagesUrl = car.imagesUrl;
        _carLocation = car.location;
        _dropdownYearValue = car.year;
        _dropdownFuelValue = car.fuel;
        _dropdownGearValue = car.gearShift;
        _dropdownCategoryValue = car.category;
        _doorsValue = car.doors;
        _seatsValue = car.seats;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        children: [
          Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              GridView.builder(
                  shrinkWrap: true,
                  itemCount: 6,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1,
                    mainAxisExtent: 120,
                  ),
                  itemBuilder: (context, index) {
                    //print(_carImagesUrl[index].url);
                    return ImageInput(
                        this._selectImage,
                        _carImagesUrl.isEmpty
                            ? ""
                            : index >= _carImagesUrl.length
                                ? ""
                                : _carImagesUrl[index].url);
                  }),
              Divider(
                height: 50,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Marca'),
                textInputAction: TextInputAction.next,
                initialValue: _formData['brand']?.toString(),
                onSaved: (brand) => _formData['brand'] = brand ?? '',
                validator: (_brand) {
                  final brand = _brand ?? '';

                  if (brand.trim().isEmpty) {
                    return 'Marca é obrigatório';
                  }

                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Modelo'),
                textInputAction: TextInputAction.next,
                initialValue: _formData['model']?.toString(),
                onSaved: (model) => _formData['model'] = model ?? '',
                validator: (_model) {
                  final model = _model ?? '';

                  if (model.trim().isEmpty) {
                    return 'Modelo é obrigatório';
                  }

                  return null;
                },
              ),
              DropdownButtonFormField<int>(
                decoration: const InputDecoration(labelText: 'Ano'),
                value: _dropdownYearValue,
                onChanged: (int? newValue) {
                  setState(() {
                    _dropdownYearValue = newValue;
                  });
                },
                validator: (_dropdownYearValue) {
                  final year = _dropdownYearValue;

                  if (year == null) {
                    return 'Ano é obrigatório';
                  }

                  return null;
                },
                items: yearsList.map((int year) {
                  return DropdownMenuItem<int>(
                    value: year,
                    child: Center(
                        child: Text(
                      year.toString(),
                      textAlign: TextAlign.center,
                    )),
                  );
                }).toList(),
                onSaved: (year) => _formData['year'] = year as int,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Placa'),
                textInputAction: TextInputAction.next,
                initialValue: _formData['plate']?.toString(),
                onSaved: (plate) => _formData['plate'] = plate ?? '',
                validator: (_plate) {
                  final plate = _plate ?? '';

                  if (plate.trim().isEmpty) {
                    return 'Placa é obrigatório';
                  }

                  return null;
                },
              ),
              DropdownButtonFormField<CarFuel>(
                decoration: const InputDecoration(labelText: 'Combustível'),
                value: _dropdownFuelValue,
                validator: (_dropdownFuelValue) {
                  final fuel = _dropdownFuelValue;

                  if (fuel == null) {
                    return 'Combustível é obrigatório';
                  }

                  return null;
                },
                onChanged: (CarFuel? newValue) {
                  setState(() {
                    _dropdownFuelValue = newValue;
                  });
                },
                items: CarFuel.values.map((CarFuel fuel) {
                  return DropdownMenuItem<CarFuel>(
                    value: fuel,
                    child: Center(
                        child: Text(
                      getFuelText(fuel),
                      textAlign: TextAlign.center,
                    )),
                  );
                }).toList(),
                onSaved: (fuel) => _formData['fuel'] = fuel as CarFuel,
              ),
              DropdownButtonFormField<CarGearShift>(
                decoration: const InputDecoration(labelText: 'Câmbio'),
                value: _dropdownGearValue,
                validator: (_dropdownGearValue) {
                  final gear = _dropdownGearValue;

                  if (gear == null) {
                    return 'Câmbio é obrigatório';
                  }

                  return null;
                },
                onChanged: (CarGearShift? newValue) {
                  setState(() {
                    _dropdownGearValue = newValue;
                  });
                },
                items: CarGearShift.values.map((CarGearShift gear) {
                  return DropdownMenuItem<CarGearShift>(
                    value: gear,
                    child: Center(
                        child: Text(
                      getGearShiftText(gear),
                      textAlign: TextAlign.center,
                    )),
                  );
                }).toList(),
                onSaved: (gear) =>
                    _formData['gearShift'] = gear as CarGearShift,
              ),
              DropdownButtonFormField<CarCategory>(
                decoration: const InputDecoration(labelText: 'Categoria'),
                value: _dropdownCategoryValue,
                validator: (_dropdownCategoryValue) {
                  final category = _dropdownCategoryValue;

                  if (category == null) {
                    return 'Categoria é obrigatório';
                  }

                  return null;
                },
                onChanged: (CarCategory? newValue) {
                  setState(() {
                    _dropdownCategoryValue = newValue;
                  });
                },
                items: CarCategory.values.map((CarCategory category) {
                  return DropdownMenuItem<CarCategory>(
                    value: category,
                    child: Center(
                        child: Text(
                      getCategoryText(category),
                      textAlign: TextAlign.center,
                    )),
                  );
                }).toList(),
                onSaved: (category) =>
                    _formData['category'] = category as CarCategory,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Porta-malas (Litros)'),
                initialValue: _formData['trunk']?.toString(),
                validator: (_trunk) {
                  final trunk = _trunk;
                  if (trunk!.trim().isEmpty || int.parse(trunk) == 0) {
                    return 'Porta-malas é obrigatório';
                  }
                  return null;
                },
                onSaved: (trunk) => _formData['trunk'] = int.parse(trunk!),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
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
                        value: _doorsValue.toDouble(),
                        onChanged: (doors) =>
                            _formData['doors'] = doors.round(),
                        validator: (_doors) {
                          final doors = _doors;

                          if (int.parse(doors!) <= 1) {
                            return 'Nº de porta maior que 1';
                          }

                          return null;
                        },
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
                          value: _seatsValue.toDouble(),
                          onChanged: (seats) =>
                              _formData['seats'] = seats.round(),
                          validator: (_seats) {
                            final seats = _seats;

                            if (int.parse(seats!) <= 1) {
                              return 'Nº de assento maior que 1';
                            }

                            return null;
                          },
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
                initialValue: _formData['description']?.toString(),
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
                initialValue: _formData['price']?.toString(),
                textInputAction: TextInputAction.next,
                onSaved: (price) => _formData['price'] = double.parse(price!),
                focusNode: _priceFocus,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (_price) {
                  final price = _price ?? '';

                  if (price.trim().isEmpty) {
                    return 'Preço é obrigatório';
                  }

                  if (double.parse(price) <= 0) {
                    return 'Preço deve ser maior que R\$ 0,00';
                  }

                  return null;
                },
              ),
              Divider(
                height: 50,
              ),
              _carLocation.address == ''
                  ? LocationInput(() => _selectLocation(
                      LatLng(_carLocation.latitude, _carLocation.longitude)))
                  : LocationInput(this._selectLocation),
            ],
          ),
          ElevatedButton(
            onPressed: () {
              if ((_pickedImagesList.isEmpty && _carImagesUrl.isEmpty) ||
                  _latLngSelected == null) {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: _latLngSelected == null
                            ? Text("Selecione a localização do carro")
                            : Text("Adicione ao menos uma imagem"),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context, 'OK');
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    });
              } else {
                _submitForm();
              }
            },
            style: ElevatedButton.styleFrom(
              primary: Theme.of(context).colorScheme.primary,
            ),
            child: _editMode
                ? Text(
                    'Salvar Alterações',
                    style: TextStyle(fontSize: 20),
                  )
                : Text(
                    'Cadastrar',
                    style: TextStyle(fontSize: 20),
                  ),
          ),
        ],
      ),
    );
  }
}
