import 'package:flutter/material.dart';
import 'package:myhealth/Screens/Autenticacao/wrapper.dart';
import 'package:myhealth/Screens/Cirurgias/EdicaoCirurgia.dart';
import 'package:myhealth/Screens/Cirurgias/ListagemDeCirurgias.dart';
import 'package:myhealth/Screens/Consulta/EdicaoDeConsulta.dart';
import 'package:myhealth/Screens/Consulta/ListagemDeConsultas.dart';
import 'package:myhealth/Screens/HomePage.dart';
import 'package:myhealth/Screens/PreLogin.dart';
import 'package:myhealth/Screens/Login.dart';
import 'package:myhealth/Service/ScreeanArguments.dart';
import 'Screens/Autenticacao/CadastroDePaciente.dart';
import 'class/user.dart';

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
        if (args is User) {
          return MaterialPageRoute(
              builder: (_) => ListagemDeConsultas(user: args));
        }
        return _errorRoute();
      case 'EdicaoDeConsulta':
        if (args is ScreeanArguments) {
          return MaterialPageRoute(
              builder: (_) => EdicaoDeConsulta(
                    user: args.user,
                    consulta: args.consulta,
                  ));
        }
        return _errorRoute();
      case 'NovaConsulta':
        if (args is ScreeanArguments) {
          return MaterialPageRoute(
              builder: (_) => EdicaoDeConsulta(user: args.user));
        }
        return _errorRoute();
      case 'EdicaoDeCirurgia':
        if (args is ScreeanArguments) {
          return MaterialPageRoute(
              builder: (_) => EdicaoDeCirurgia(
                    user: args.user,
                    consulta: args.cirurgia,
                  ));
        }
        return _errorRoute();
      case 'ListagemDeCirurgias':
        if (args is User) {
          return MaterialPageRoute(
              builder: (_) => ListagemDeCirurgias(user: args));
        }
        return _errorRoute();
      case 'NovaCirurgia':
        if (args is ScreeanArguments) {
          return MaterialPageRoute(
              builder: (_) => EdicaoDeCirurgia(user: args.user));
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
