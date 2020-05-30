import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:myhealth/Persistencia/P_Profissional.dart';
import 'package:myhealth/Service/Util.dart';
import 'package:myhealth/UserProfissional/Authenticate/AuthProfissional.dart';

class CadastroDeProfissional extends StatefulWidget {
  @override
  _CadastroDeProfissionalState createState() => _CadastroDeProfissionalState();
}

class _CadastroDeProfissionalState extends State<CadastroDeProfissional> {
  final AuthProfissional _auth = AuthProfissional();
  final P_Profissional  profissionalBD = P_Profissional();
  
  final _formKey = GlobalKey<FormState>();

  var maskFormatterCPF = new MaskTextInputFormatter(mask: '###.###.###-##', filter: { "#": RegExp(r'[0-9]') });
 
  String nome = '';
  String cpf = '';                                        
  String idProfissao = '';
  String profissao = '';
  String email = '';
  String emailC = '';
  String senha = '';
  String senhaC = '';

  String error = '';

  var profissionais = [
    "Médico",
    "Fisioterapeuta",
    "Psicólogo",
    "Nutricionista",
    "Dentista"
  ];


    _modalInvertido(String texto) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Dado inválido"),
            content: Text("Este " + texto + " já esta cadastrado no sistema"),
            actions: <Widget>[
              FlatButton(
                child: Text("voltar"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }
  
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
                          keyboardType: TextInputType.text,
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
                          keyboardType: TextInputType.number,
                          inputFormatters: [maskFormatterCPF],
                          validator: (val) {
                            if (val.isEmpty) return 'Digite seu CPF';
                             if (!Util.verificaCPF(val)) return 'CPF inválido';
                            return null;
                          },
                          onChanged: (val) {
                            setState(() {
                              cpf = val;
                            });
                          },
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
                          validator: (val) => val.isEmpty
                              ? 'Digite seu identificador profissional'
                              : null,
                          onChanged: (val) {
                            setState(() {
                              idProfissao = val;
                            });
                          },
                          style: TextStyle(
                            color: Colors.black,
                          ),
                          decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black)),
                              labelText: 'Identificador Profissional *',
                              labelStyle:
                                  TextStyle(fontSize: 15, color: Colors.black)),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                        child: Row(
                          children: <Widget>[
                            Text("Profissão : ", style:TextStyle( color: Colors.black)),
                            Expanded(
                              child: DropdownButton(
                                hint: Text(profissao),
                                items: profissionais
                                    .map((String progissaoEscolhida) {
                                  return DropdownMenuItem<String>(
                                    value: progissaoEscolhida,
                                    child: Text(progissaoEscolhida),
                                  );
                                }).toList(),
                                onChanged: (text) {
                                  setState(() {
                                    profissao = text;
                                  });
                                },
                                isExpanded: true,
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                        child: TextFormField(
                          keyboardType: TextInputType.emailAddress,
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
                          keyboardType: TextInputType.emailAddress,
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
                          keyboardType: TextInputType.visiblePassword,
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

                         var listaDeEmails =
                            await profissionalBD.listaDeEmailsCadastrado();

                        if (!Util.verificaSeFoiCadastrado(
                            email, listaDeEmails)) {
                          var listaDeCpfs = await profissionalBD.listaDeCpfsCadastrado();

                          if (!Util.verificaSeFoiCadastrado(cpf, listaDeCpfs)) {


                        dynamic result = await _auth.cadastroPorEmaileSenha(
                            nome, cpf, idProfissao, profissao, email, senha);
                        if (result == null) {
                          setState(
                              () => error = 'Erro ao realizar o cadastro.');
                        } else {
                          Navigator.of(context)
                              .pushReplacementNamed('LoginProfissional');
                        }
                         } else {
                            _modalInvertido("CPF");
                          }
                        } else {
                          _modalInvertido("e-mail");
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
                    textColor: Colors.black,
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
