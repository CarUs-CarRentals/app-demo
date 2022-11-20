import 'dart:io';

import 'package:carshare/components/maskFormatters.dart';
import 'package:carshare/models/address.dart';
import 'package:carshare/models/user.dart';
import 'package:carshare/widgets/image_input.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class UserForm extends StatefulWidget {
  const UserForm({Key? key}) : super(key: key);

  @override
  State<UserForm> createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  final _priceFocus = FocusNode();
  final _formKey = GlobalKey<FormState>();
  final _formData = <String, Object>{};
  bool _editMode = false;
  bool _isLoading = false;

  File _pickedImage = File('');
  String _profileImageUrl = '';

  UserGender? _dropdownGenderValue;
  BrazilStates? _dropdownStateValue;
  BrazilStates? _dropdownStateCNHValue;

  String getUserGenderText(UserGender gender) {
    switch (gender) {
      case UserGender.MALE:
        return 'Masculino';
      case UserGender.FEMALE:
        return 'Feminino';
      case UserGender.UNKNOWN:
        return '';
      default:
        return 'Desconhecido';
    }
  }

  void _selectImage(File pickedImage) {
    _pickedImage = pickedImage;
    if (_pickedImage.path == "") {
      return;
    }
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

  Future<void> _submitForm() async {}

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
                child: ImageInput(_selectImage, '', 100),
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
                        labelText: 'Nome',
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
                      decoration: const InputDecoration(labelText: 'Sobrenome'),
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
                inputFormatters: [FieldTextMask.maskCPF],
                decoration: const InputDecoration(
                  labelText: 'CPF',
                  hintText: "___.___.___-__",
                ),
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                initialValue: _formData['cpf']?.toString(),
                onSaved: (cpf) => _formData['cpf'] = cpf ?? '',
                validator: (_cpf) {
                  final cpf = _cpf ?? '';

                  if (cpf.trim().isEmpty) {
                    return 'CPF é obrigatório';
                  }

                  return null;
                },
              ),
              TextFormField(
                inputFormatters: [FieldTextMask.maskPhoneNumber],
                decoration: const InputDecoration(
                  labelText: 'Telefone',
                  hintText: "(__) _____-____",
                ),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.phone,
                initialValue: _formData['phone']?.toString(),
                onSaved: (phone) => _formData['phone'] = phone ?? '',
                validator: (_phone) {
                  final phone = _phone ?? '';

                  if (phone.trim().isEmpty) {
                    return 'Telefone é obrigatório';
                  }

                  return null;
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
                      getUserGenderText(gender),
                      textAlign: TextAlign.center,
                    )),
                  );
                }).toList(),
                onSaved: (gender) => _formData['gender'] = gender as UserGender,
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
                inputFormatters: [FieldTextMask.maskCEP],
                decoration: const InputDecoration(
                  labelText: 'CEP',
                  hintText: "_____-___",
                ),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                initialValue: _formData['cep']?.toString(),
                onSaved: (cep) => _formData['cep'] = cep ?? '',
                // validator: (_cep) {
                //   final cep = _cep ?? '';

                //   if (cep.trim().isEmpty) {
                //     return 'CPF é obrigatório';
                //   }

                //   return null;
                // },
              ),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Rua',
                      ),
                      textInputAction: TextInputAction.next,
                      initialValue: _formData['street']?.toString(),
                      onSaved: (street) => _formData['street'] = street ?? '',
                    ),
                  ),
                  SizedBox(width: 10.0),
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Numero',
                      ),
                      textInputAction: TextInputAction.next,
                      initialValue: _formData['number']?.toString(),
                      onSaved: (number) => _formData['number'] = number ?? '',
                    ),
                  ),
                ],
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Bairro',
                ),
                textInputAction: TextInputAction.next,
                initialValue: _formData['neighborhood']?.toString(),
                onSaved: (neighborhood) =>
                    _formData['neighborhood'] = neighborhood ?? '',
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Cidade',
                ),
                textInputAction: TextInputAction.next,
                initialValue: _formData['city']?.toString(),
                onSaved: (city) => _formData['city'] = city ?? '',
              ),
              DropdownButtonFormField<BrazilStates>(
                decoration: const InputDecoration(labelText: 'Estado'),
                value: _dropdownStateValue,
                onChanged: (BrazilStates? newValue) {
                  setState(() {
                    _dropdownStateValue = newValue;
                  });
                },
                items: BrazilStates.values.map((BrazilStates state) {
                  return DropdownMenuItem<BrazilStates>(
                    value: state,
                    child: Center(
                        child: Text(
                      Address.getStateText(state),
                      textAlign: TextAlign.center,
                    )),
                  );
                }).toList(),
                onSaved: (state) => _formData['state'] = state as BrazilStates,
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
                  labelText: 'RG',
                ),
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                initialValue: _formData['rg']?.toString(),
                onSaved: (rg) => _formData['rg'] = rg ?? '',
                // validator: (_rg) {
                //   final rg = _rg ?? '';

                //   if (rg.trim().isNotEmpty) {
                //     return 'CPF é obrigatório';
                //   }

                //   return null;
                // },
              ),
              TextFormField(
                  inputFormatters: [FieldTextMask.maskDate],
                  decoration: const InputDecoration(
                    labelText: 'Data de Nascimento',
                    hintText: "__/__/____",
                  ),
                  keyboardType: TextInputType.datetime,
                  textInputAction: TextInputAction.next,
                  initialValue: _formData['birthDate']?.toString(),
                  onSaved: (birthDate) =>
                      _formData['birthDate'] = birthDate ?? '',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return null;
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
                    return "wrong date";
                  }),
              TextFormField(
                inputFormatters: [FieldTextMask.maskCNHRegisterNumb],
                decoration: InputDecoration(
                    labelText: 'Número do Registro',
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
                initialValue: _formData['registerNumber']?.toString(),
                onSaved: (registerNumber) =>
                    _formData['registerNumber'] = registerNumber ?? '',
                // validator: (_rg) {
                //   final rg = _rg ?? '';

                //   if (rg.trim().isNotEmpty) {
                //     return 'CPF é obrigatório';
                //   }

                //   return null;
                // },
              ),
              TextFormField(
                inputFormatters: [FieldTextMask.maskCNHNumb],
                decoration: InputDecoration(
                    labelText: 'Número da CNH',
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
                // validator: (_rg) {
                //   final rg = _rg ?? '';

                //   if (rg.trim().isNotEmpty) {
                //     return 'CPF é obrigatório';
                //   }

                //   return null;
                // },
              ),
              TextFormField(
                  inputFormatters: [FieldTextMask.maskDate],
                  decoration: const InputDecoration(
                    labelText: 'Data de Validade',
                    hintText: "__/__/____",
                  ),
                  keyboardType: TextInputType.datetime,
                  textInputAction: TextInputAction.next,
                  initialValue: _formData['expirationDate']?.toString(),
                  onSaved: (expirationDate) =>
                      _formData['expirationDate'] = expirationDate ?? '',
                  validator: (_expirationDate) {
                    if (_expirationDate == null || _expirationDate.isEmpty) {
                      return null;
                    }
                    final components = _expirationDate.split("/");
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
                    return "wrong date";
                  }),
              DropdownButtonFormField<BrazilStates>(
                decoration: const InputDecoration(labelText: 'Estado'),
                value: _dropdownStateCNHValue,
                onChanged: (BrazilStates? newValue) {
                  setState(() {
                    _dropdownStateCNHValue = newValue;
                  });
                },
                items: BrazilStates.values.map((BrazilStates state) {
                  return DropdownMenuItem<BrazilStates>(
                    value: state,
                    child: Center(
                        child: Text(
                      Address.getStateText(state),
                      textAlign: TextAlign.center,
                    )),
                  );
                }).toList(),
                onSaved: (state) =>
                    _formData['stateCNH'] = state as BrazilStates,
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
