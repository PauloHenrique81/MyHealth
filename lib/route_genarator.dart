import 'package:flutter/material.dart';
import 'package:myhealth/Screens/HomePage.dart';
import 'package:myhealth/Screens/PreLogin.dart';
import 'package:myhealth/Screens/SignInOne.dart';
import 'package:myhealth/Screens/SignInTwo.dart';

class RouteGenarator {
  static Route<dynamic> genareteRoute(RouteSettings settings) {
//Getting arguments passed in while calling Navigator.pushNamed
    //final args = settings.arguments;

    switch (settings.name) {
      case 'LoginMedico':
        return MaterialPageRoute(builder: (_) => SignInOne());
      case 'LoginPaciente':
        return MaterialPageRoute(builder: (_) => SignInTwo());
      case 'PreLogin':
        return MaterialPageRoute(builder: (_) => PreLogin());
      case 'HomePage':
        return MaterialPageRoute(builder: (_) => HomePage());
      // case '':
      //   //Validation of correct data type
      //   if (args is String) {
      //     return MaterialPageRoute(builder: (_) => page(data: args));
      //   }

      //return _errorRoute();

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
