import 'package:flutter/material.dart';
import 'package:myhealth/Screens/Consulta/ListagemDeConsultas.dart';
import 'package:myhealth/Screens/HomePage.dart';
import 'package:myhealth/Screens/PreLogin.dart';
import 'package:myhealth/Screens/SignInOne.dart';
import 'package:myhealth/Screens/SignInTwo.dart';

import 'class/UserDetails.dart';

class RouteGenarator {
  static Route<dynamic> genareteRoute(RouteSettings settings) {
//Getting arguments passed in while calling Navigator.pushNamed
    final args = settings.arguments;

    switch (settings.name) {
      case 'LoginMedico':
        return MaterialPageRoute(builder: (_) => SignInOne());
      case 'LoginPaciente':
        return MaterialPageRoute(builder: (_) => SignInTwo());
      case 'PreLogin':
        return MaterialPageRoute(builder: (_) => PreLogin());
      case 'ListagemDeConsultas':
        return MaterialPageRoute(builder: (_) => ListagemDeConsultas());
      case 'HomePage':
        //Validation of correct data type
        if (args is UserDetails) {
          return MaterialPageRoute(builder: (_) => HomePage(detailsUser: args));
        }

        return _errorRoute();

      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}
