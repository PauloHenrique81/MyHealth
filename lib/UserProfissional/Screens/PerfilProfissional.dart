import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:myhealth/Persistencia/P_Profissional.dart';
import 'package:myhealth/class/Profissional.dart';
import 'package:myhealth/class/user.dart';

class PerfilProfissional extends StatefulWidget {
  final User user;
  PerfilProfissional({this.user});

  @override
  _PerfilProfissionalState createState() => _PerfilProfissionalState();
}

class _PerfilProfissionalState extends State<PerfilProfissional> {
  Profissional _profissional;
  P_Profissional conectionDB = new P_Profissional();

  DateTime _date = new DateTime.now();
  var _userEdited = false;

  var maskFormatterCPF = new MaskTextInputFormatter(mask: '###.###.###-##', filter: { "#": RegExp(r'[0-9]') });
var maskFormatterTelefone = new MaskTextInputFormatter(mask: '(##) #####-####', filter: { "#": RegExp(r'[0-9]') });

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: _date,
        firstDate: new DateTime(1900),
        lastDate: new DateTime(2023));

    if (picked != null) {
      setState(() {
        _dataDeNascimentoController.text =
            new DateFormat("dd-MM-yyyy").format(picked);
      });
    }
  }

  String formatTimeOfDay(TimeOfDay tod) {
    final now = new DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    final format = DateFormat.jm();
    return format.format(dt);
  }

  buscaProfissional(String uid) async {
    return await conectionDB.getProfissionalUser(uid);
  }

  final _formKey = GlobalKey<FormState>();

  final _nomeController = TextEditingController();
  final _cpfController = TextEditingController();
  final _dataDeNascimentoController = TextEditingController();
  final _emailController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _especialidadeController = TextEditingController();
  final _sexoController = TextEditingController();
  final _identificacaoController = TextEditingController();
  final _localDeAtendimentoController = TextEditingController();
  final _profissaoController = TextEditingController();


    var profissionais = [
    "Médico",
    "Fisioterapeuta",
    "Psicólogo",
    "Nutricionista",
    "Dentista"
  ];

    String profissao = '';

  @override
  void initState() {
    super.initState();

    _carregaPaciente();
  }

  _carregaPaciente() async {
    _profissional = await buscaProfissional(widget.user.uid);

    _nomeController.text = _profissional.nome;
    _dataDeNascimentoController.text = _profissional.dataDeNascimento;
    _cpfController.text = _profissional.cpf;
    _emailController.text = _profissional.email;
    _telefoneController.text = _profissional.telefone;
    _especialidadeController.text = _profissional.especialidade;
    _sexoController.text = _profissional.sexo;
    _identificacaoController.text = _profissional.identificacao;
    _localDeAtendimentoController.text = _profissional.localDeAtendimento;
    _profissaoController.text = _profissional.profissao;

    setState(() {
      profissao = _profissional.profissao;

    });
    

  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () => _requestPop(context),
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blue,
            title: Text("Perfil"),
            centerTitle: true,
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              if (_formKey.currentState.validate()) {
                await conectionDB.atualizarProfissional(
                  widget.user.uid,
                  _profissional.idProfissional,
                  _nomeController.text,
                  _localDeAtendimentoController.text,
                  _profissaoController.text,
                  especialidade: _especialidadeController.text,
                  identificacao: _identificacaoController.text,
                  telefone: _telefoneController.text,
                  cpf: _cpfController.text,
                  dataDeNascimento: _dataDeNascimentoController.text,
                  sexo: _sexoController.text,
                  email: _emailController.text,
                  tipoUser: "Sim"
                );

                Navigator.pop(context);
              }
            },
            child: Icon(Icons.save),
            backgroundColor: Colors.blue,
          ),
          body: SingleChildScrollView(
              padding: EdgeInsets.all(10.0),
              child: Column(
                children: <Widget>[
                  Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          controller: _nomeController,
                          decoration: InputDecoration(labelText: "Nome:"),
                          validator: (val) =>
                              val.isEmpty ? 'Digite seu nome' : null,
                          onChanged: (text) {
                            setState(() {
                              _userEdited = true;
                              _profissional.nome = text;
                            });
                          },
                        ),
                        TextField(
                            controller: _cpfController,
                            decoration: InputDecoration(labelText: "CPF:"),
                            inputFormatters: [maskFormatterCPF],
                            onChanged: (text) {
                              _userEdited = true;
                              _profissional.cpf = text;
                            },
                            keyboardType: TextInputType.number),
                        TextFormField(
                          controller: _dataDeNascimentoController,
                          decoration:
                              InputDecoration(labelText: "Data de nascimento:"),
                          validator: (val) =>
                              val.isEmpty ? 'Digite a data' : null,
                          onChanged: (text) {
                            _userEdited = true;
                            _profissional.dataDeNascimento = text;
                          },
                          onTap: () => _selectDate(context),
                          keyboardType: TextInputType.datetime,
                        ),
                        TextFormField(
                            controller: _emailController,
                            decoration: InputDecoration(labelText: "E-mail:"),
                            onChanged: (text) {
                              _userEdited = true;
                              _profissional.email = text;
                            },
                            keyboardType: TextInputType.emailAddress),
                        TextFormField(
                            keyboardType: TextInputType.number,
                            controller: _telefoneController,
                            inputFormatters: [maskFormatterTelefone],
                            decoration: InputDecoration(labelText: "Telefone:"),
                            onChanged: (text) {
                              _userEdited = true;
                              _profissional.telefone = text;
                            },
                          ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 3, 0, 0),
                        child: Row(
                          children: <Widget>[
                            Text("Profissão : ", style:TextStyle( color: Colors.black)),
                            Expanded(
                              child: DropdownButton(
                                hint: Text(profissao,style: TextStyle(color: Colors.black),),
                                items: profissionais
                                    .map((String progissaoEscolhida) {
                                  return DropdownMenuItem<String>(
                                    value: progissaoEscolhida,
                                    child: Text(progissaoEscolhida),
                                  );
                                }).toList(),
                                onChanged: (text) {
                                  _profissaoController.text = text;

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
                        TextFormField(
                          controller: _identificacaoController,
                          decoration: InputDecoration(
                              labelText: "Identificação da profissão:"),
                          onChanged: (text) {
                            _userEdited = true;
                            _profissional.identificacao = text;
                          },
                        ),
                        TextFormField(
                          controller: _especialidadeController,
                          decoration:
                              InputDecoration(labelText: "Especialidade:"),
                          onChanged: (text) {
                            _userEdited = true;
                            _profissional.especialidade = text;
                          },
                        ),
                        TextFormField(
                          controller: _sexoController,
                          decoration: InputDecoration(labelText: "Sexo:"),
                          onChanged: (text) {
                            _userEdited = true;
                            _profissional.sexo = text;
                          },
                          keyboardType: TextInputType.text,
                        ),
                        TextFormField(
                          controller: _localDeAtendimentoController,
                          decoration: InputDecoration(
                              labelText: "Local de atendimento:"),
                          onChanged: (text) {
                            _userEdited = true;
                            _profissional.localDeAtendimento = text;
                          },
                          keyboardType: TextInputType.text,
                        )
                      ],
                    ),
                  ),
                ],
              )),
        ));
  }

  Future<bool> _requestPop(BuildContext context) {
    if (_userEdited) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Descartar alterações?"),
              content: Text("Se sair as alterações serão perdidas."),
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
                  Navigator.pushNamedAndRemoveUntil(
                      context, 'HomePageProfissional',
                      (Route<dynamic> route) => false ,
                      arguments: widget.user);
                  },
                )
              ],
            );
          });
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }
}
