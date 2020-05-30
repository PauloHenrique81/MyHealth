import 'package:cpfcnpj/cpfcnpj.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:myhealth/Service/Util.dart';
import 'package:myhealth/Service/auth.dart';

class CadastroDePaciente extends StatefulWidget {
  @override
  _CadastroDePacienteState createState() => _CadastroDePacienteState();
}

class _CadastroDePacienteState extends State<CadastroDePaciente> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  DateTime _date = new DateTime.now();

  var maskFormatterCPF = new MaskTextInputFormatter(mask: '###.###.###-##', filter: { "#": RegExp(r'[0-9]') });

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: _date,
        firstDate: new DateTime(1940),
        lastDate: new DateTime(2023));

    if (picked != null) {
      setState(() {
        _dataController.text = new DateFormat("dd-MM-yyyy").format(picked);
      });
    }
  }

  String nome = '';
  String cpf = '';
  String email = '';
  String emailC = '';
  String senha = '';
  String senhaC = '';

  final _dataController = TextEditingController();

  String error = '';

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
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                        child: TextFormField(
                          validator: (val) =>
                              val.isEmpty ? 'Digite seu nome' : null,
                          onChanged: (val) {
                            setState(() {
                              nome = val;
                            });
                          },
                          style: TextStyle(
                            color: Colors.black,
                          ),
                          decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black)),
                              labelText: 'Nome *',
                              labelStyle:
                                  TextStyle(fontSize: 15, color: Colors.black)),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                        child: TextFormField(
                          controller: _dataController,
                          decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black)),
                              labelText: 'Data de nascimento *',
                              labelStyle:
                                  TextStyle(fontSize: 15, color: Colors.black)),
                          validator: (val) =>
                              val.isEmpty ? 'Digite a data' : null,
                          onChanged: (text) {
                            _dataController.text = text;
                          },
                          onTap: () => _selectDate(context),
                          keyboardType: TextInputType.datetime,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                        child: TextFormField(
                          validator: (val) {
                            if (val.isEmpty) return 'Digite seu CPF';
                             if (!Util.verificaCPF(val))
                              return 'CPF inválido';
                            return null;
                          },
                          onChanged: (val) {
                            setState(() {
                              cpf = val;
                            });
                          },
                          keyboardType: TextInputType.number,
                          inputFormatters: [maskFormatterCPF],
                          style: TextStyle(
                            color: Colors.black,
                          ),
                          decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black)),
                              labelText: 'CPF *',
                              labelStyle:
                                  TextStyle(fontSize: 15, color: Colors.black)),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                        child: TextFormField(
                          validator: (val){
                            if (val.isEmpty) return 'Digite seu E-mail';
                            if(!EmailValidator.validate(email)) return "E-mail inválido";
                            return null;
                          },
                          onChanged: (val) {
                            setState(() {
                              email = val;
                            });
                          },
                          keyboardType: TextInputType.emailAddress,
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
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                        child: TextFormField(
                          validator: (val) {
                            if (val != emailC) return 'E-mail diferentes ';
                            if(!EmailValidator.validate(email)) return "E-mail inválido";
                            if (val.isEmpty) return 'Digite seu E-mail';
                            return null;
                          },
                          onChanged: (val) {
                            setState(() {
                              emailC = val;
                            });
                          },
                          keyboardType: TextInputType.emailAddress,
                          style: TextStyle(
                            color: Colors.black,
                          ),
                          decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black)),
                              labelText: 'Confirmar e-mail *',
                              labelStyle:
                                  TextStyle(fontSize: 15, color: Colors.black)),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                        child: TextFormField(
                          validator: (val) {
                            if (val.isEmpty) return 'Digite sua senha';
                            if (val.length < 6)
                              return 'Senha de no minimo 6 digitos';
                            return null;
                          },
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
                              labelText: 'Senha *',
                              labelStyle:
                                  TextStyle(fontSize: 15, color: Colors.black)),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                        child: TextFormField(
                          validator: (val) {
                            if (val != senhaC) return 'Senhas diferentes ';
                            if (val.isEmpty) return 'Digite sua senha';
                            if (val.length < 6)
                              return 'Senha de no minimo 6 digitos';
                            return null;
                          },
                          onChanged: (val) {
                            setState(() {
                              senhaC = val;
                            });
                          },
                          obscureText: true,
                          style: TextStyle(
                            color: Colors.black,
                          ),
                          decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black)),
                              labelText: 'Confirmar senha *',
                              labelStyle:
                                  TextStyle(fontSize: 15, color: Colors.black)),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: MaterialButton(
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        dynamic result = await _auth.registrarPaciente(
                            nome, cpf, email, senha,
                            dataDeNascimento: _dataController.text);
                        if (result == null) {
                          setState(
                              () => error = 'Erro ao realizar o cadastro.');
                        } else {
                          Navigator.of(context)
                              .pushReplacementNamed('LoginPaciente');
                        }
                      }
                    },
                    child: Text(
                      'Criar conta',
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
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Text(
                          'Cancelar',
                          style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'SFUIDisplay',
                              color: Colors.red),
                        )
                      ],
                    ),
                    color: Colors.transparent,
                    elevation: 0,
                    minWidth: 350,
                    height: 60,
                    textColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                        side: BorderSide(color: Colors.black)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
