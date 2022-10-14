import 'package:flutter/material.dart';

class ProfileUserScreen extends StatelessWidget {
  const ProfileUserScreen({Key? key}) : super(key: key);

  _descriptionSection(BuildContext context, String description) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      width: double.infinity,
      child: Column(
        children: <Widget>[
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: Text(
                  'Sobre mim:',
                  textAlign: TextAlign.left,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Flexible(
                child: Text(
                  description,
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 14),
                ),
              ),
            ],
          ),
          Padding(padding: EdgeInsets.only(top: 30)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Perfil do Proprietario'),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: <Widget>[
            ListTile(
              trailing: Container(
                height: 150,
                width: mediaQuery.size.width / 4.5,
                alignment: Alignment.topRight,
                child: const CircleAvatar(radius: 150),
              ),
              title: Container(
                padding: const EdgeInsets.only(top: 10.0),
                child: Text('Igor Felipe Ponchielli',
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                    )),
              ),
              subtitle: Container(
                padding: const EdgeInsets.only(top: 20.0),
                child: Text("membro desde 2022"),
              ),
              dense: false,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 25.0),
              child: ListTile(
                leading: Container(
                  width: 24,
                  child: Icon(
                    Icons.reviews,
                    size: 24,
                  ),
                ),
                title: Text(
                  "44 Avaliações",
                  style: const TextStyle(
                    fontFamily: 'RobotCondensed',
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () {},
                dense: false,
              ),
            ),
            Divider(),
            _descriptionSection(context,
                "Augusto Miguelino, tem 35 anos, se formou na Escola Petro, cursou engenharia mecatrônica na Universidade Sem Fim, formando-se em 2002. Atuou como engenheiro na empresa Enga, sendo desligado em 2010. Em 2011 resolveu voltar para a faculdade escolhendo o curso de web designer, depois de formado resolveu abrir a sua própria empresa e atua na área desde então."),
            ListTile(
              leading: Container(
                width: 24,
                child: Icon(
                  Icons.pin_drop_rounded,
                  size: 24,
                ),
              ),
              title: Text(
                "Testo Rega, Pomerode - SC, 89107-000, Brasil",
                style: const TextStyle(
                  fontFamily: 'RobotCondensed',
                  fontSize: 14,
                ),
              ),
              dense: false,
            ),
            Divider(),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                primary: Theme.of(context).colorScheme.primary,
              ),
              child: const Text(
                'Editar Perfil',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
