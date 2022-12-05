import 'dart:io';

import 'package:brasil_fields/brasil_fields.dart';
import 'package:carshare/components/maskFormatters.dart';
import 'package:carshare/data/store.dart';
import 'package:carshare/models/address.dart';
import 'package:carshare/models/user.dart';
import 'package:carshare/providers/addresses.dart';
import 'package:carshare/providers/drive_licenses.dart';
import 'package:carshare/providers/users.dart';
import 'package:carshare/utils/constants.dart';
import 'package:carshare/widgets/image_input.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';

class UserForm extends StatefulWidget {
  const UserForm({Key? key}) : super(key: key);

  @override
  State<UserForm> createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  final _formKey = GlobalKey<FormState>();
  final _formData = <String, Object>{};
  final _firebaseStorage = FirebaseStorage.instance;
  bool _isLoading = false;

  File _pickedImage = File('');
  String _profileImageUrl = '';

  UploadTask? uploadTask;
  String? _userId;
  UserGender? _dropdownGenderValue;
  BrazilStates? _dropdownStateValue;
  BrazilStates? _dropdownStateCNHValue;

  void _selectImage(File pickedImage) {
    if (pickedImage.path == _pickedImage.path) {
      _pickedImage = File('');
      return;
    }
    _pickedImage = pickedImage;
    // if (_pickedImage.path == "") {
    //   return;
    // }
  }

  _cnhTipDialog({required String title, required String imageUrl}) {
    return showDialog(
        context: context,
        useSafeArea: true,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: Container(
                height: 200,
                width: double.infinity,
                child: Image.network(
                  imageUrl,
                )),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        });
  }

  void _getCurrentUserId() async {
    final userData = await Store.getMap('userDataFb');
    _userId = userData['localId'];
    _formData['userId'] = _userId as String;
  }

  _uploadImage(File pickedImage) async {
    final fileName =
        pickedImage.path.substring(pickedImage.path.lastIndexOf('/'));
    final path = 'images/${_formData['userID']}$fileName';

    final ref = _firebaseStorage.ref().child(path);
    uploadTask = ref.putFile(pickedImage);

    final snapshot = await uploadTask!.whenComplete(() => null);

    final urlDownload = await snapshot.ref.getDownloadURL();

    if (urlDownload != '') {
      _profileImageUrl = urlDownload;
      _formData['profileImageUrl'] = _profileImageUrl;
    }
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    if (_formData.isEmpty) {
      final arg = ModalRoute.of(context)?.settings.arguments;

      if (arg != null) {
        final user = arg as User;
        _formData['userID'] = user.id;
        _formData['email'] = user.email;
        _formData['firstName'] = user.firstName;
        _formData['lastName'] = user.lastName;
        _formData['about'] = user.about;
        _formData['profileImageUrl'] = user.profileImageUrl;
        _formData['gender'] = user.gender ?? '';
        _formData['cpf'] = user.cpf;
        _formData['phone'] = user.phone;
        _formData['addressID'] = user.address?.id ?? '';
        _formData['cep'] = user.address?.cep ?? '';
        _formData['state'] = user.address?.state ?? '';
        _formData['city'] = user.address?.city ?? '';
        _formData['neighborhood'] = user.address?.neighborhood ?? '';
        _formData['street'] = user.address?.street ?? '';
        _formData['addressNumber'] = user.address?.number ?? '';
        _formData['cnhID'] = user.cnh?.id ?? '';
        _formData['rg'] = user.cnh?.rg ?? '';
        _formData['birthDate'] = user.cnh?.birthDate ?? '';
        _formData['cnhRegisterNumber'] = user.cnh?.registerNumber ?? '';
        _formData['cnhNumber'] = user.cnh?.cnhNumber ?? '';
        _formData['cnhExpirationDate'] = user.cnh?.expirationDate ?? '';
        _formData['cnhState'] = user.cnh?.state ?? '';

        if (_formData['profileImageUrl'] != Constants.DEFAULT_PROFILE_IMAGE) {
          _profileImageUrl = _formData['profileImageUrl'] as String;
        }
        _dropdownGenderValue = user.gender;
        _dropdownStateValue = user.address?.state;
        _dropdownStateCNHValue = user.cnh?.state;
      }
    }
  }

  Future<void> _submitForm() async {
    _getCurrentUserId();
    final driverLicenseProvider =
        Provider.of<DriverLicenses>(context, listen: false);
    final userProvider = Provider.of<Users>(context, listen: false);
    final navigator = Navigator.of(context);
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }

    context.loaderOverlay.show();
    setState(() {
      _isLoading = context.loaderOverlay.visible;
    });

    try {
      if (!_pickedImage.path.startsWith("https://") &&
          _pickedImage.path.isNotEmpty) {
        await _uploadImage(_pickedImage);
      } else {
        _formData['profileImageUrl'] = _profileImageUrl;
      }
    } catch (e) {
      throw UnsupportedError('Erro ao fazer o upload');
    }

    _formKey.currentState?.save();

    try {
      await Provider.of<Users>(
        context,
        listen: false,
      ).saveUser(_formData);
      await userProvider.loadProfile();
      await driverLicenseProvider.saveCNH(_formData);
      int count = 0;
      navigator.popUntil((_) => count++ >= 2);
    } catch (error) {
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
  Widget build(BuildContext context) {
    final snackMsg = ScaffoldMessenger.of(context);
    final mediaQuery = MediaQuery.of(context);

    return Form(
        key: _formKey,
        child: ListView(
          children: [
            Column(children: [
              const SizedBox(
                height: 30,
              ),
              SizedBox(
                height: 120,
                width: 120,
                child: ImageInput(
                    _selectImage,
                    _profileImageUrl.isEmpty
                        ? "${_formData['profileImageUrl']}"
                        : _profileImageUrl,
                    100),
              ),
              const SizedBox(
                height: 30,
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Dados de Perfil',
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Nome*',
                      ),
                      textInputAction: TextInputAction.next,
                      initialValue: _formData['firstName']?.toString(),
                      onSaved: (firstName) =>
                          _formData['firstName'] = firstName ?? '',
                      validator: (_firstName) {
                        final firstName = _firstName ?? '';

                        if (firstName.trim().isEmpty) {
                          return 'Nome é obrigatório';
                        }

                        return null;
                      },
                    ),
                  ),
                  SizedBox(width: 10.0),
                  Expanded(
                    child: TextFormField(
                      decoration:
                          const InputDecoration(labelText: 'Sobrenome*'),
                      textInputAction: TextInputAction.next,
                      initialValue: _formData['lastName']?.toString(),
                      onSaved: (lastName) =>
                          _formData['lastName'] = lastName ?? '',
                      validator: (_lastName) {
                        final lastName = _lastName ?? '';

                        if (lastName.trim().isEmpty) {
                          return 'Sobrenome é obrigatório';
                        }

                        return null;
                      },
                    ),
                  )
                ],
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Sobre mim',
                  alignLabelWithHint: true,
                ),
                textInputAction: TextInputAction.newline,
                keyboardType: TextInputType.multiline,
                initialValue: _formData['about']?.toString(),
                maxLines: null,
                maxLength: 255,
                onSaved: (about) {
                  _formData['about'] = about ?? '';
                },
              ),
              const Divider(
                height: 50,
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Dados Pessoais',
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
              TextFormField(
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  CpfInputFormatter()
                ],
                decoration: const InputDecoration(
                  labelText: 'CPF*',
                ),
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                initialValue: _formData['cpf']?.toString() != ""
                    ? UtilBrasilFields.obterCpf(
                        "${_formData['cpf']?.toString()}")
                    : "",
                onSaved: (cpf) => _formData['cpf'] =
                    UtilBrasilFields.removeCaracteres(cpf.toString()),
                validator: (_cpf) {
                  final cpf = _cpf ?? '';

                  if (cpf.trim().isEmpty) {
                    return 'CPF é obrigatório';
                  }

                  if (!UtilBrasilFields.isCPFValido(cpf)) {
                    return 'CPF Inválido';
                  }
                },
              ),
              TextFormField(
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  TelefoneInputFormatter()
                ],
                decoration: const InputDecoration(
                  labelText: 'Telefone*',
                ),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.phone,
                initialValue: _formData['phone']?.toString() != ""
                    ? UtilBrasilFields.obterTelefone(
                        "${_formData['phone']?.toString()}",
                        ddd: true,
                        mascara: true)
                    : "",
                onSaved: (phone) => _formData['phone'] =
                    UtilBrasilFields.removeCaracteres(phone.toString()),
                validator: (_phone) {
                  final phone;
                  if (_phone != "") {
                    phone = UtilBrasilFields.obterTelefone(_phone.toString(),
                        mascara: false);
                  } else {
                    phone = _phone;
                  }

                  print(phone);

                  if (phone.trim().isEmpty) {
                    return 'Telefone é obrigatório';
                  }

                  if (phone.length != 10 && phone.length != 11) {
                    return 'Telefone é inválido';
                  }
                },
              ),
              DropdownButtonFormField<UserGender>(
                decoration: const InputDecoration(labelText: 'Sexo'),
                value: _dropdownGenderValue,
                onChanged: (UserGender? newValue) {
                  setState(() {
                    _dropdownGenderValue = newValue;
                  });
                },
                items: UserGender.values.map((UserGender gender) {
                  return DropdownMenuItem<UserGender>(
                    value: gender,
                    child: Center(
                        child: Text(
                      User.getUserGenderText(gender),
                      textAlign: TextAlign.center,
                    )),
                  );
                }).toList(),
                onSaved: (gender) {
                  if (gender == null) {
                    _formData['gender'] = UserGender.OTHER;
                  } else {
                    _formData['gender'] = gender as UserGender;
                  }
                },
                validator: (_dropdownGenderValue) {
                  var gender = _dropdownGenderValue;

                  if (gender == null) {
                    _formData['gender'] = UserGender.OTHER;
                    return null;
                  }

                  return null;
                },
              ),
              const Divider(
                height: 50,
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Dados de Endereço',
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
              TextFormField(
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  CepInputFormatter()
                ],
                decoration: const InputDecoration(
                  labelText: 'CEP*',
                ),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                initialValue: UtilBrasilFields.obterCep(
                    "${_formData['cep']?.toString()}"),
                onSaved: (cep) => _formData['cep'] =
                    UtilBrasilFields.removeCaracteres(cep.toString()),
                validator: (_cep) {
                  final cep =
                      UtilBrasilFields.removeCaracteres(_cep.toString());

                  if (cep.trim().isEmpty) {
                    return 'CEP é obrigatório';
                  }

                  if (cep.length != 8) {
                    return 'CEP é inválido';
                  }
                },
              ),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Rua*',
                      ),
                      textInputAction: TextInputAction.next,
                      initialValue: _formData['street']?.toString(),
                      onSaved: (street) => _formData['street'] = street ?? '',
                      validator: (_street) {
                        final street = _street ?? '';

                        if (street.trim().isEmpty) {
                          return 'Rua é obrigatório';
                        }
                      },
                    ),
                  ),
                  SizedBox(width: 10.0),
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Numero*',
                      ),
                      textInputAction: TextInputAction.next,
                      initialValue: _formData['addressNumber']?.toString(),
                      onSaved: (number) => _formData['addressNumber'] =
                          int.parse(number.toString()),
                      validator: (_number) {
                        final number = _number ?? '';

                        if (number.trim().isEmpty) {
                          return 'Nº é obrigatório';
                        }
                      },
                    ),
                  ),
                ],
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Bairro*',
                ),
                textInputAction: TextInputAction.next,
                initialValue: _formData['neighborhood']?.toString(),
                onSaved: (neighborhood) =>
                    _formData['neighborhood'] = neighborhood ?? '',
                validator: (_neighborhood) {
                  final neighborhood = _neighborhood ?? '';

                  if (neighborhood.trim().isEmpty) {
                    return 'Bairro é obrigatório';
                  }
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Cidade*',
                ),
                textInputAction: TextInputAction.next,
                initialValue: _formData['city']?.toString(),
                onSaved: (city) => _formData['city'] = city ?? '',
                validator: (_city) {
                  final city = _city ?? '';

                  if (city.trim().isEmpty) {
                    return 'Cidade é obrigatório';
                  }
                },
              ),
              DropdownButtonFormField<BrazilStates>(
                decoration: const InputDecoration(labelText: 'Estado*'),
                value: _dropdownStateValue,
                onChanged: (BrazilStates? newValue) {
                  setState(() {
                    _dropdownStateValue = newValue;
                  });
                },
                items: BrazilStates.values
                    .where((e) => e != BrazilStates.UNKNOWN)
                    .map((BrazilStates state) {
                  return DropdownMenuItem<BrazilStates>(
                    value: state,
                    child: Center(
                        child: Text(
                      Address.getStateText(state),
                      textAlign: TextAlign.center,
                    )),
                  );
                }).toList(),
                onSaved: (state) {
                  if (state == null) {
                    _formData['state'] = BrazilStates.UNKNOWN;
                  } else {
                    _formData['state'] = state as BrazilStates;
                  }
                },
                validator: (_dropdownStateValue) {
                  var state = _dropdownStateValue;

                  if (state == null) {
                    return 'Estado é obrigatório';
                  }
                },
              ),
              const Divider(
                height: 50,
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Dados da sua CNH',
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
              TextFormField(
                inputFormatters: [FieldTextMask.maskRG],
                decoration: const InputDecoration(
                  labelText: 'RG*',
                ),
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                initialValue: _formData['rg']?.toString(),
                onSaved: (rg) => _formData['rg'] = rg ?? '',
                validator: (_rg) {
                  final rg = _rg ?? '';

                  if (rg.trim().isEmpty) {
                    return 'RG é obrigatório';
                  }
                },
              ),
              TextFormField(
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  DataInputFormatter()
                ],
                decoration: const InputDecoration(
                  labelText: 'Data de Nascimento*',
                ),
                keyboardType: TextInputType.datetime,
                textInputAction: TextInputAction.next,
                initialValue: _formData['birthDate']?.toString() != ""
                    ? UtilData.obterDataDDMMAAAA(
                        DateTime.parse("${_formData['birthDate']?.toString()}"))
                    : "",
                onSaved: (birthDate) => _formData['birthDate'] =
                    UtilData.obterDateTime(birthDate.toString()),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Data de Nascimento é obrigatório";
                  }
                  final components = value.split("/");
                  if (components.length == 3) {
                    final day = int.tryParse(components[0]);
                    final month = int.tryParse(components[1]);
                    final year = int.tryParse(components[2]);
                    if (day != null && month != null && year != null) {
                      final date = DateTime(year, month, day);
                      if (date.year == year &&
                          date.month == month &&
                          date.day == day) {
                        return null;
                      }
                    }
                  }
                  return "Data Inválida";
                },
              ),
              TextFormField(
                inputFormatters: [FieldTextMask.maskCNHRegisterNumb],
                decoration: InputDecoration(
                    labelText: 'Número do Registro*',
                    suffixIcon: IconButton(
                      icon: Icon(Icons.help),
                      onPressed: () {
                        _cnhTipDialog(
                          title: "Onde está o Número do Registro?",
                          imageUrl:
                              "https://firebasestorage.googleapis.com/v0/b/carus-app-363822.appspot.com/o/CNH_tooptip%2FN-Registro-CNH-1024x750.webp?alt=media&token=071f91f2-e7c8-468e-9430-96fe184bc047",
                        );
                      },
                    )),
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                initialValue: _formData['cnhRegisterNumber']?.toString(),
                onSaved: (registerNumber) =>
                    _formData['cnhRegisterNumber'] = registerNumber ?? '',
                validator: (_cnhRegisterNumber) {
                  final cnhRegisterNumber = _cnhRegisterNumber ?? '';

                  if (cnhRegisterNumber.trim().isEmpty) {
                    return 'Número do Registro é obrigatório';
                  }
                },
              ),
              TextFormField(
                inputFormatters: [FieldTextMask.maskCNHNumb],
                decoration: InputDecoration(
                    labelText: 'Número da CNH*',
                    suffixIcon: IconButton(
                      icon: Icon(Icons.help),
                      onPressed: () {
                        _cnhTipDialog(
                          title: "Onde está o Número da CNH?",
                          imageUrl:
                              "https://firebasestorage.googleapis.com/v0/b/carus-app-363822.appspot.com/o/CNH_tooptip%2FEspelho-CNH-1024x750.webp?alt=media&token=23f5f5a6-49a6-4f15-818c-50858d07f44e",
                        );
                      },
                    )),
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                initialValue: _formData['cnhNumber']?.toString(),
                onSaved: (cnhNumber) =>
                    _formData['cnhNumber'] = cnhNumber ?? '',
                validator: (_cnhNumber) {
                  final cnhNumber = _cnhNumber ?? '';

                  if (cnhNumber.trim().isEmpty) {
                    return 'Número da CNH é obrigatório';
                  }
                },
                // },
              ),
              TextFormField(
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  DataInputFormatter()
                ],
                decoration: const InputDecoration(
                  labelText: 'Data de Validade*',
                ),
                keyboardType: TextInputType.datetime,
                textInputAction: TextInputAction.next,
                initialValue: _formData['cnhExpirationDate']?.toString() != ""
                    ? UtilData.obterDataDDMMAAAA(DateTime.parse(
                        "${_formData['cnhExpirationDate']?.toString()}"))
                    : "",
                onSaved: (expirationDate) => _formData['cnhExpirationDate'] =
                    UtilData.obterDateTime(expirationDate.toString()),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Data de Validade é obrigatório";
                  }
                  final components = value.split("/");
                  if (components.length == 3) {
                    final day = int.tryParse(components[0]);
                    final month = int.tryParse(components[1]);
                    final year = int.tryParse(components[2]);
                    if (day != null && month != null && year != null) {
                      final date = DateTime(year, month, day);
                      if (date.year == year &&
                          date.month == month &&
                          date.day == day) {
                        return null;
                      }
                    }
                  }
                  return "Data Inválida";
                },
              ),
              DropdownButtonFormField<BrazilStates>(
                decoration: const InputDecoration(labelText: 'Estado*'),
                value: _dropdownStateCNHValue,
                onChanged: (BrazilStates? newValue) {
                  setState(() {
                    _dropdownStateCNHValue = newValue;
                  });
                },
                items: BrazilStates.values
                    .where((e) => e != BrazilStates.UNKNOWN)
                    .map((BrazilStates state) {
                  return DropdownMenuItem<BrazilStates>(
                    value: state,
                    child: Center(
                        child: Text(
                      Address.getStateText(state),
                      textAlign: TextAlign.center,
                    )),
                  );
                }).toList(),
                onSaved: (state) {
                  if (state == null) {
                    _formData['cnhState'] = BrazilStates.UNKNOWN;
                  } else {
                    _formData['cnhState'] = state as BrazilStates;
                  }
                },
                validator: (_dropdownStateCNHValue) {
                  var state = _dropdownStateCNHValue;

                  if (state == null) {
                    return 'Estado é obrigatório';
                  }
                },
              ),
            ]),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
                onPressed: () {
                  try {
                    _submitForm();
                  } on HttpException catch (error) {
                    snackMsg.showSnackBar(SnackBar(
                      content: Text(
                        error.toString(),
                      ),
                    ));
                  }
                },
                style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).colorScheme.primary,
                ),
                child: const Text(
                  'Salvar Alterações do Perfil',
                  style: TextStyle(fontSize: 20),
                )),
          ],
        ));
  }
}
