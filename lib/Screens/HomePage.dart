import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:myhealth/Service/auth.dart';
import 'package:myhealth/class/user.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:myhealth/route_genarator.dart';

class HomePage extends StatelessWidget {
  User user;
  HomePage({this.user});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: new ThemeData(
          primarySwatch: Colors.deepPurple,
          primaryColor: defaultTargetPlatform == TargetPlatform.iOS
              ? Colors.grey[50]
              : null),
      home: new _HomePage(
        user: user,
      ),
      onGenerateRoute: RouteGenarator.genareteRoute,
    );
  }
}

class _HomePage extends StatelessWidget {
  final User user;

  _HomePage({this.user});
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text("MyHealth"),
        actions: <Widget>[
          IconButton(
            icon: Icon(FontAwesomeIcons.signOutAlt, size: 20.0),
            color: Colors.white,
            onPressed: () async {
              await _auth.signOut();
              Navigator.of(context).pushNamed('LoginPaciente');
            },
          ),
        ],
        elevation: defaultTargetPlatform == TargetPlatform.android ? 5.0 : 0.0,
      ),
      drawer: new Drawer(
        child: new ListView(
          children: <Widget>[
            new UserAccountsDrawerHeader(
              accountName: new Text(user.userName ?? "Paciente"),
              accountEmail: new Text(user.userEmail),
              currentAccountPicture: new CircleAvatar(
                backgroundImage: NetworkImage(user.photoUrl ?? ""),
              ),
            ),
            new ListTile(
              title: new Text("Perfil"),
              trailing: new Icon(Icons.person_outline),
              onTap: () =>
                  Navigator.pushNamed(context, 'Perfil', arguments: user.uid),
            ),
            new ListTile(
              title: new Text("Consultas"),
              trailing: new Icon(Icons.receipt),
              onTap: () => Navigator.pushNamed(context, 'ListagemDeConsultas',
                  arguments: user),
            ),
            new ListTile(
              title: new Text("Cirurgias"),
              trailing: new Icon(Icons.receipt),
              onTap: () => Navigator.pushNamed(context, 'ListagemDeCirurgias',
                  arguments: user),
            ),
            new ListTile(
              title: new Text("Exames"),
              trailing: new Icon(Icons.receipt),
              onTap: () => Navigator.pushNamed(context, 'ListagemDeExames',
                  arguments: user),
            ),
            new ListTile(
              title: new Text("Profissionais"),
              trailing: new Icon(Icons.receipt),
              onTap: () => Navigator.pushNamed(
                  context, 'ListagemDeProfissionais',
                  arguments: user),
            ),
            new ListTile(
              title: new Text("Receitas"),
              trailing: new Icon(Icons.receipt),
              onTap: () => Navigator.pushNamed(context, 'ListagemDeReceitas',
                  arguments: user),
            ),
            new ListTile(
              title: new Text("Vacinas"),
              trailing: new Icon(Icons.receipt),
              onTap: () => Navigator.pushNamed(
                  context, 'ListagemTiposDeVacinas',
                  arguments: user),
            ),
            new ListTile(
              title: new Text("Atestados"),
              trailing: new Icon(Icons.receipt),
              onTap: () => Navigator.pushNamed(context, 'ListagemDeAtestados',
                  arguments: user),
            ),
            new ListTile(
              title: new Text("Fechar"),
              trailing: new Icon(Icons.close),
              onTap: () => Navigator.of(context).pop(),
            )
          ],
        ),
      ),
      body: new Container(
        child: new Center(
          child: new Text("Home Page"),
        ),
      ),
    );
  }
}
