import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:myhealth/Service/Util.dart';
import 'package:myhealth/Service/auth.dart';

class RecuperarSenhaPaciente extends StatefulWidget {
  @override
  _RecuperarSenhaPacienteState createState() => _RecuperarSenhaPacienteState();
}

class _RecuperarSenhaPacienteState extends State<RecuperarSenhaPaciente> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  String email = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
        image: AssetImage('Assets/fundoBranco.jpg'),
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
                          validator: (val)   {
                            if(val.isEmpty) return 'Digite seu e-mail';
                             if(!EmailValidator.validate(email)) return "E-mail inválido";
                            return null;
                          },
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
                              labelText: 'E-mail *',
                              labelStyle:
                                  TextStyle(fontSize: 15, color: Colors.black)),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: MaterialButton(
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        var listaDeEmails = await _auth.listaDeEmailsCadastrado();
                        
                        if(Util.verificaSeFoiCadastrado(email, listaDeEmails)){
                          
                            showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text("Resetar senha?"),
                                content: Text(
                                    "Sera enviado no seu e-mail, um link para recuperar sua senha"),
                                actions: <Widget>[
                                  FlatButton(
                                    child: Text("Cancelar"),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                  FlatButton(
                                    child: Text("Sim"),
                                    onPressed: () {
                                      _auth.resetPassword(email);
                                      Navigator.pushReplacementNamed(
                                          context, 'LoginPaciente');
                                    },
                                  )
                                ],
                              );
                            });

                        }else{
                            showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text("E-mail inválido"),
                                content: Text(
                                    "Este e-mail não está cadastrado no sistema"),
                                actions: <Widget>[
                                  FlatButton(
                                    child: Text("Voltar"),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              );
                            });
                        }


                        
                      }
                    },
                    child: Text(
                      'Recuperar',
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
