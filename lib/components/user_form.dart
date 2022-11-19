import 'dart:io';

import 'package:carshare/components/maskFormatters.dart';
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

  UserGender? _dropdownGenderValue;

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

  @override
  Widget build(BuildContext context) {
    final snackMsg = ScaffoldMessenger.of(context);

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
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(labelText: 'Nome'),
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
              TextFormField(
                inputFormatters: [FieldTextMask.maskCPF],
                decoration: const InputDecoration(
                  labelText: 'CPF',
                  hintText: "___.___.___-__",
                ),
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
                  hintText: "+55 (__) _____-____",
                ),
                textInputAction: TextInputAction.next,
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
            ]),
          ],
        ));
  }
}
