import 'package:flutter/material.dart';
import 'package:myhealth/Screens/Autenticacao/CadastroDePaciente.dart';
import 'package:myhealth/Screens/Login.dart';

class Autenticacao extends StatefulWidget {
  @override
  _AutenticacaoState createState() => _AutenticacaoState();
}

class _AutenticacaoState extends State<Autenticacao> {
  bool showSignIn = true;

  void toggleView() {
    setState(() {
      showSignIn = !showSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showSignIn) {
      return LoginPaciente();
    } else {
      return CadastroDePaciente();
    }
  }
}
