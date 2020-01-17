import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:myhealth/Screens/SignInTwo.dart';
import 'package:myhealth/class/UserDetails.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:myhealth/route_genarator.dart';

class HomePage extends StatelessWidget {
  final UserDetails detailsUser;

  HomePage({Key key, @required this.detailsUser}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: new ThemeData(
          primarySwatch: Colors.deepPurple,
          primaryColor: defaultTargetPlatform == TargetPlatform.iOS
              ? Colors.grey[50]
              : null),
      home: new _HomePage(detailsUser: detailsUser),
      onGenerateRoute: RouteGenarator.genareteRoute,
    );
  }
}

class _HomePage extends StatelessWidget {
  final UserDetails detailsUser;
  _HomePage({Key key, @required this.detailsUser}) : super(key: key);
  final GoogleSignIn _gSignIn = GoogleSignIn();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text("MyHelth"),
        actions: <Widget>[
          IconButton(
            icon: Icon(FontAwesomeIcons.signOutAlt, size: 20.0),
            color: Colors.white,
            onPressed: () {
              _gSignIn.signOut();
              Navigator.of(context).push(new MaterialPageRoute(
                  builder: (BuildContext context) => new SignInTwo()));
            },
          ),
        ],
        elevation: defaultTargetPlatform == TargetPlatform.android ? 5.0 : 0.0,
      ),
      drawer: new Drawer(
        child: new ListView(
          children: <Widget>[
            new UserAccountsDrawerHeader(
              accountName: new Text(detailsUser.userName),
              accountEmail: new Text(detailsUser.userEmail),
              currentAccountPicture: new CircleAvatar(
                backgroundImage: NetworkImage(detailsUser.photoUrl),
              ),
            ),
            new ListTile(
              title: new Text("Perfil"),
              trailing: new Icon(Icons.person_outline),
            ),
            new ListTile(
              title: new Text("Consultas"),
              trailing: new Icon(Icons.receipt),
              onTap: () =>
                  Navigator.of(context).pushNamed('ListagemDeConsultas'),
            ),
            new ListTile(
              title: new Text("teste2"),
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
