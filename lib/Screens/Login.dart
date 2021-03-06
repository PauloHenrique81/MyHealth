import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:myhealth/Service/auth.dart';

class LoginPaciente extends StatefulWidget {
  @override
  _LoginPacienteState createState() => _LoginPacienteState();
}

class _LoginPacienteState extends State<LoginPaciente> {
  final AuthService _auth = AuthService();

  final _formKey = GlobalKey<FormState>();

  String email = '';

  String senha = '';

  String error = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
        image: AssetImage('Assets/loginPaciente.png'),
        fit: BoxFit.cover,
      )),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.transparent,
          ),
          child: Padding(
            padding: EdgeInsets.all(23),
            child: ListView(
              children: <Widget>[
                SizedBox(
                  height: 200,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                        child: TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          validator: (val) =>
                              val.isEmpty ? 'Digite seu e-mail' : null,
                          onChanged: (val) {
                            setState(() {
                              email = val;
                            });
                          },
                          style: TextStyle(
                            color: Colors.black,
                          ),
                          decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black)),
                              labelText: 'E-mail',
                              labelStyle:
                                  TextStyle(fontSize: 15, color: Colors.black)),
                        ),
                      ),
                      TextFormField(
                        validator: (val) =>
                            val.isEmpty ? 'Digite sua senha' : null,
                        onChanged: (val) {
                          setState(() {
                            senha = val;
                          });
                        },
                        obscureText: true,
                        style: TextStyle(
                          color: Colors.black,
                        ),
                        decoration: InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black)),
                            labelText: 'Senha',
                            labelStyle:
                                TextStyle(fontSize: 15, color: Colors.black)),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20, bottom: 5),
                  child: InkWell(
                    child: Text(
                      'Esqueceu sua senha?',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          fontFamily: 'SFUIDisplay',
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    onTap: (){
                      Navigator.pushNamed(context, 'RecuperarSenhaPaciente');
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: MaterialButton(
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        dynamic result =
                            await _auth.logarComEmailESenha(email, senha);
                        if (result == null) {
                          setState(() => error = 'E-mail ou senha incorretos.');
                        } else {
                           Navigator.of(context).pushNamedAndRemoveUntil(
                            'HomePage',(Route<dynamic> route) => false , arguments: result);
                        }
                      }
                    },
                    child: Text(
                      'Entrar',
                      style: TextStyle(
                          fontSize: 15,
                          fontFamily: 'SFUIDisplay',
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    color: Colors.black,
                    elevation: 0,
                    minWidth: 350,
                    height: 60,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50)),
                  ),
                ),
                SizedBox(
                  height: 12.0,
                ),
                Center(
                  child: Text(error,
                      style: TextStyle(color: Colors.red, fontSize: 14.0)),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: MaterialButton(
                    onPressed: () async {
                      await _auth.signInWithGmail().then((user) {
                        if (user != null) {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                            'HomePage',(Route<dynamic> route) => false , arguments: user);
                        }
                      });
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Icon(FontAwesomeIcons.google),
                        Text(
                          'Entrar com Gmail',
                          style: TextStyle(
                              fontSize: 15, fontFamily: 'SFUIDisplay'),
                        )
                      ],
                    ),
                    color: Colors.transparent,
                    elevation: 0,
                    minWidth: 350,
                    height: 60,
                    textColor: Colors.black,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                        side: BorderSide(color: Colors.black)),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 30),
                  child: Center(
                    child: RichText(
                      text: TextSpan(children: [
                        TextSpan(
                          text: "Ainda não tem uma conta?",
                          style: TextStyle(
                            fontFamily: 'SFUIDisplay',
                            color: Colors.black,
                            fontSize: 15,
                          ),
                        ),
                        TextSpan(
                            text: " Criar conta",
                            style: TextStyle(
                              fontFamily: 'SFUIDisplay',
                              color: Color(0xffff2d55),
                              fontSize: 15,
                            ),
                            recognizer: new TapGestureRecognizer()
                              ..onTap = () => Navigator.of(context)
                                  .pushNamed('CadastroDePaciente'))
                      ]),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
