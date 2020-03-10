import 'package:flutter/material.dart';
import 'package:myhealth/Screens/Autenticacao/wrapper.dart';
import 'package:myhealth/Screens/Cirurgias/EdicaoCirurgia.dart';
import 'package:myhealth/Screens/Cirurgias/ListagemDeCirurgias.dart';
import 'package:myhealth/Screens/Consulta/EdicaoDeConsulta.dart';
import 'package:myhealth/Screens/Consulta/ListagemDeConsultas.dart';
import 'package:myhealth/Screens/Exames/EdicaoDeExame.dart';
import 'package:myhealth/Screens/HomePage.dart';
import 'package:myhealth/Screens/Perfil.dart';
import 'package:myhealth/Screens/PreLogin.dart';
import 'package:myhealth/Screens/Login.dart';
import 'package:myhealth/Screens/Profissional/EdicaoDoProfissional.dart';
import 'package:myhealth/Screens/Profissional/ListagemDeProfissional.dart';
import 'package:myhealth/Screens/Receita/EdicaoDaReceita.dart';
import 'package:myhealth/Screens/Receita/ListagemDeReceita.dart';
import 'package:myhealth/Screens/Vacinas/ListagemVacinasAdolescente.dart';
import 'package:myhealth/Screens/Vacinas/ListagemVacinasAdulto.dart';
import 'package:myhealth/Screens/Vacinas/ListagemVacinasGestante.dart';
import 'package:myhealth/Screens/Vacinas/ListagemVacinasIdoso.dart';
import 'package:myhealth/Screens/Vacinas/ListagensTiposDeVacinas.dart';
import 'package:myhealth/Service/ImageCapture.dart';
import 'package:myhealth/Service/ScreeanArguments.dart';
import 'package:myhealth/class/Imagem.dart';
import 'Screens/Autenticacao/CadastroDePaciente.dart';
import 'Screens/Exames/ListagemDeExames.dart';
import 'Screens/Vacinas/ListagemVacinasCrianca.dart';
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
      case 'EdicaoDeProfissional':
        if (args is ScreeanArguments) {
          return MaterialPageRoute(
              builder: (_) => EdicaoDeProfissional(
                    user: args.user,
                    profissional: args.profissional,
                  ));
        }
        return _errorRoute();
      case 'ListagemDeProfissionais':
        if (args is User) {
          return MaterialPageRoute(
              builder: (_) => ListagemDeProfissionais(user: args));
        }
        return _errorRoute();
      case 'NovoProfissional':
        if (args is ScreeanArguments) {
          return MaterialPageRoute(
              builder: (_) => EdicaoDeProfissional(user: args.user));
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

      case 'EdicaoDeReceita':
        if (args is ScreeanArguments) {
          return MaterialPageRoute(
              builder: (_) => EdicaoDeReceita(
                    user: args.user,
                    receita: args.receita,
                  ));
        }
        return _errorRoute();
      case 'ListagemDeReceitas':
        if (args is User) {
          return MaterialPageRoute(
              builder: (_) => ListagemDeReceitas(user: args));
        }
        return _errorRoute();
      case 'NovaReceita':
        if (args is ScreeanArguments) {
          return MaterialPageRoute(
              builder: (_) => EdicaoDeReceita(user: args.user));
        }
        return _errorRoute();

      case 'EdicaoDeExame':
        if (args is ScreeanArguments) {
          return MaterialPageRoute(
              builder: (_) => EdicaoDeExame(
                    user: args.user,
                    exame: args.exame,
                  ));
        }
        return _errorRoute();
      case 'ListagemDeExames':
        if (args is User) {
          return MaterialPageRoute(
              builder: (_) => ListagemDeExames(user: args));
        }
        return _errorRoute();
      case 'NovoExame':
        if (args is ScreeanArguments) {
          return MaterialPageRoute(
              builder: (_) => EdicaoDeExame(user: args.user));
        }
        return _errorRoute();
      case 'HomePage':
        if (args is User) {
          return MaterialPageRoute(builder: (_) => HomePage(user: args));
        }
        return _errorRoute();
      case 'ListagemTiposDeVacinas':
        if (args is User) {
          return MaterialPageRoute(
              builder: (_) => ListagemTiposDeVacinas(user: args));
        }
        return _errorRoute();
      case 'ListagemVacinasCrianca':
        if (args is ScreeanArguments) {
          return MaterialPageRoute(
              builder: (_) => ListagemVacinasCrianca(
                    user: args.user,
                    vacinas: args.vacina,
                  ));
        }
        return _errorRoute();
      case 'ListagemVacinasAdolescente':
        if (args is ScreeanArguments) {
          return MaterialPageRoute(
              builder: (_) => ListagemVacinasAdolescente(
                    user: args.user,
                    vacinas: args.vacina,
                  ));
        }
        return _errorRoute();
      case 'ListagemVacinasAdulto':
        if (args is ScreeanArguments) {
          return MaterialPageRoute(
              builder: (_) => ListagemVacinasAdulto(
                    user: args.user,
                    vacinas: args.vacina,
                  ));
        }
        return _errorRoute();
      case 'ListagemVacinasIdoso':
        if (args is ScreeanArguments) {
          return MaterialPageRoute(
              builder: (_) => ListagemVacinasIdoso(
                    user: args.user,
                    vacinas: args.vacina,
                  ));
        }
        return _errorRoute();
      case 'ListagemVacinasGestante':
        if (args is ScreeanArguments) {
          return MaterialPageRoute(
              builder: (_) => ListagemVacinasGestante(
                    user: args.user,
                    vacinas: args.vacina,
                  ));
        }
        return _errorRoute();
      case 'ImageCapture':
        if (args is ScreeanArguments) {
          return MaterialPageRoute(
              builder: (_) => ImageCapture(
                    user: args.user,
                    imagem: args.imagem,
                  ));
        }
        return _errorRoute();
      case 'Perfil':
        if (args is String) {
          return MaterialPageRoute(builder: (_) => Perfil(uid: args));
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
