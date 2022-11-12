// ignore_for_file: library_private_types_in_public_api

import 'package:carshare/exceptions/auth_exception.dart';
import 'package:carshare/models/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum AuthMode { signUp, login }

class AuthForm extends StatefulWidget {
  const AuthForm({Key? key}) : super(key: key);

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  AuthMode _authMode = AuthMode.login;
  final Map<String, String> _authData = {
    'login': '',
    'password': '',
    'email': '',
    'firstName': '',
    'lastName': '',
  };

  bool _isLogin() => _authMode == AuthMode.login;
  bool _isSignup() => _authMode == AuthMode.signUp;

  void _switchAuthMode() {
    setState(() {
      if (_isLogin()) {
        _authMode = AuthMode.signUp;
      } else {
        _authMode = AuthMode.login;
      }
    });
  }

  void _showErrorDialog(String msg) {
    showDialog(
      context: context,
      builder: ((cxt) => AlertDialog(
            title: const Text('Ocorreu um Erro'),
            content: Text(msg),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Fechar'),
              ),
            ],
          )),
    );
  }

  Future<void> _submit() async {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }

    setState(() {
      _isLoading = true;
    });
    _formKey.currentState?.save();
    Auth auth = Provider.of(context, listen: false);
    //Navigator.of(context).pushNamed(AppRoutes.HOME);

    try {
      if (_isLogin()) {
        print(_authData);
        await auth.login(
          _authData['email']!,
          _authData['password']!,
        );
      } else {
        print(_authData);
        await auth.signup(
          _authData['email']!,
          _authData['password']!,
          _authData['firstName']!,
          _authData['lastName']!,
        );
      }
    } on AuthException catch (error) {
      _showErrorDialog(error.toString());
    } catch (error) {
      print(error.toString());
      _showErrorDialog('Ocorreu um erro inesperado!');
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        height: _isLogin() ? 320 : 472,
        width: deviceSize.width * 0.75,
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              if (_isSignup())
                Row(
                  children: [
                    SizedBox(
                      width: deviceSize.width * 0.335,
                      child: TextFormField(
                        decoration: const InputDecoration(labelText: 'Nome'),
                        keyboardType: TextInputType.name,
                        onSaved: (name) => _authData['firstName'] = name ?? '',
                        validator: (_name) {
                          final name = _name ?? '';
                          if (name.trim().isEmpty) {
                            return 'Informe um nome';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(
                      width: deviceSize.width * 0.335,
                      child: TextFormField(
                        decoration:
                            const InputDecoration(labelText: 'Sobrenome'),
                        keyboardType: TextInputType.name,
                        onSaved: (lastname) =>
                            _authData['lastName'] = lastname ?? '',
                        validator: (_lastname) {
                          final lastname = _lastname ?? '';
                          if (lastname.trim().isEmpty) {
                            return 'Informe um sobrenome';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              // TextFormField(
              //   decoration: const InputDecoration(labelText: 'Login'),
              //   keyboardType: TextInputType.text,
              //   onSaved: (login) => _authData['login'] = login ?? '',
              //   validator: (_login) {
              //     final login = _login ?? '';
              //     if (login.trim().isEmpty) {
              //       return 'Informe seu login';
              //     }
              //     return null;
              //   },
              // ),

              TextFormField(
                decoration: const InputDecoration(labelText: 'E-mail'),
                keyboardType: TextInputType.emailAddress,
                onSaved: (email) => _authData['email'] = email ?? '',
                validator: (_email) {
                  final email = _email ?? '';
                  if (email.trim().isEmpty || !email.contains('@')) {
                    return 'Informe um e-mail válido.';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Senha'),
                keyboardType: TextInputType.emailAddress,
                obscureText: true,
                controller: _passwordController,
                onSaved: (password) => _authData['password'] = password ?? '',
                validator: (_password) {
                  final password = _password ?? '';
                  if (password.isEmpty || password.length < 5) {
                    return 'Informe uma senha válida';
                  }
                  return null;
                },
              ),
              if (_isSignup())
                TextFormField(
                  decoration:
                      const InputDecoration(labelText: 'Confirmar Senha'),
                  keyboardType: TextInputType.emailAddress,
                  obscureText: true,
                  validator: _isLogin()
                      ? null
                      : (_password) {
                          final password = _password ?? '';
                          if (password != _passwordController.text) {
                            return 'Senhas informadas não conferem.';
                          }
                          return null;
                        },
                ),
              SizedBox(height: 20),
              if (_isLoading)
                CircularProgressIndicator()
              else
                ElevatedButton(
                  onPressed: _submit,
                  child: Text(
                    _isLogin() ? 'ENTRAR' : 'REGISTRAR',
                  ),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 8,
                    ),
                  ),
                ),
              const Spacer(),
              TextButton(
                onPressed: _switchAuthMode,
                child: Text(
                  _isLogin() ? 'DESEJA SE REGISTRAR?' : 'JÁ POSSUI CONTA',
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
