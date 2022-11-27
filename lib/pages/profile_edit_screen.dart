import 'package:carshare/components/user_form.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';

class ProfileEditScreen extends StatelessWidget {
  const ProfileEditScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Perfil'),
      ),
      body: const LoaderOverlay(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: UserForm(),
        ),
      ),
    );
  }
}
