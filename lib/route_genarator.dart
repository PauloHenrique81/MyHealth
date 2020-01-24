import 'package:flutter/material.dart';
import 'package:myhealth/Screens/Autenticacao/wrapper.dart';
import 'package:myhealth/Screens/Consulta/EdicaoDeConsulta.dart';
import 'package:myhealth/Screens/Consulta/ListagemDeConsultas.dart';
import 'package:myhealth/Screens/HomePage.dart';
import 'package:myhealth/Screens/PreLogin.dart';
import 'package:myhealth/Screens/Login.dart';
import 'Screens/Autenticacao/CadastroDePaciente.dart';
import 'class/Consulta.dart';
import 'class/User.dart';

class RouteGenarator {
  static Route<dynamic> genareteRoute(RouteSettings settings) {
//Getting arguments passed in while calling Navigator.pushNamed
    final args = settings.arguments;

    switch (settings.name) {
      case 'Wrapper':
        return MaterialPageRoute(builder: (_) => Wrapper());
      case 'LoginPaciente':
        return MaterialPageRoute(builder: (_) => LoginPaciente());
      case 'CadastroDePaciente':
        return MaterialPageRoute(builder: (_) => CadastroDePaciente());
      case 'PreLogin':
        return MaterialPageRoute(builder: (_) => PreLogin());
      case 'ListagemDeConsultas':
        return MaterialPageRoute(builder: (_) => ListagemDeConsultas());
      case 'EdicaoDeConsulta':
        if (args is Consulta) {
          return MaterialPageRoute(
              builder: (_) => EdicaoDeConsulta(consulta: args));
        }
        return _errorRoute();
      case 'HomePage':
        if (args is User) {
          return MaterialPageRoute(builder: (_) => HomePage(user: args));
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
