import 'package:flutter/material.dart';
import 'package:myhealth/Persistencia/P_Profissional.dart';
import 'package:myhealth/class/Profissional.dart';
import 'package:myhealth/class/user.dart';

class EdicaoDeProfissional extends StatefulWidget {
  final Profissional profissional;
  final User user;
  EdicaoDeProfissional({this.user, this.profissional});

  @override
  _EdicaoDeProfissionalState createState() => _EdicaoDeProfissionalState();
}

class _EdicaoDeProfissionalState extends State<EdicaoDeProfissional> {
  Profissional _profissionalEdicao;
  bool _userEdited = false;
  bool _novoProfissional = false;

  String profissao = "";

  var profissionais = [
    "Médico",
    "Fisioterapeuta",
    "Psicólogo",
    "Nutricionista",
    "Dentista,"
  ];
  final _formKey = GlobalKey<FormState>();

  P_Profissional conectionDB = new P_Profissional();

  final _profissaoController = TextEditingController();
  final _nomeController = TextEditingController();
  final _especialidadeController = TextEditingController();
  final _identificacaoController = TextEditingController();
  final _localDeAtendimentoController = TextEditingController();
  final _statusController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.profissional == null) {
      _profissionalEdicao = Profissional();
      _novoProfissional = true;
    } else {
      _profissionalEdicao = widget.profissional;

      _profissaoController.text = _profissionalEdicao.profissao;
      _nomeController.text = _profissionalEdicao.nome;
      _especialidadeController.text = _profissionalEdicao.especialidade;
      _identificacaoController.text = _profissionalEdicao.identificacao;
      _localDeAtendimentoController.text =
          _profissionalEdicao.localDeAtendimento;
      _statusController.text = _profissionalEdicao.status;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () => _requestPop(context),
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.deepPurple,
            title: Text(_profissionalEdicao.nome ?? "Novo Profissional"),
            centerTitle: true,
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              if (_formKey.currentState.validate()) {
                if (_novoProfissional == true) {
                  await conectionDB.cadastraProfissional(
                      widget.user.uid,
                      _profissaoController.text,
                      _nomeController.text,
                      _localDeAtendimentoController.text,
                      especialidade: _especialidadeController.text,
                      identificacao: _identificacaoController.text,
                      status: _statusController.text);
                } else {
                  await conectionDB.atualizarProfissional(
                      widget.user.uid,
                      _profissionalEdicao.idProfissional,
                      _nomeController.text,
                      _localDeAtendimentoController.text,
                      _profissaoController.text,
                      especialidade: _especialidadeController.text,
                      identificacao: _identificacaoController.text,
                      status: _statusController.text);
                }

                Navigator.pop(context);
              }
            },
            child: Icon(Icons.save),
            backgroundColor: Colors.deepPurple,
          ),
          body: SingleChildScrollView(
              padding: EdgeInsets.all(10.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text("Profissão"),
                        DropdownButton(
                          hint: Text(profissao),
                          items: profissionais.map((String progissaoEscolhida) {
                            return DropdownMenuItem<String>(
                              value: progissaoEscolhida,
                              child: Text(progissaoEscolhida),
                            );
                          }).toList(),
                          onChanged: (text) {
                            _userEdited = true;
                            _profissionalEdicao.profissao = text;

                            setState(() {
                              profissao = text;
                            });
                          },
                        ),
                      ],
                    ),
                    TextField(
                      controller: _especialidadeController,
                      decoration: InputDecoration(labelText: "Especialidade:"),
                      onChanged: (text) {
                        _userEdited = true;
                        _profissionalEdicao.especialidade = text;
                      },
                    ),
                    TextFormField(
                      controller: _nomeController,
                      decoration: InputDecoration(labelText: "Nome:"),
                      validator: (val) => val.isEmpty ? 'Digite o Nome' : null,
                      onChanged: (text) {
                        _userEdited = true;
                        _profissionalEdicao.nome = text;
                      },
                    ),
                    TextFormField(
                        controller: _identificacaoController,
                        decoration:
                            InputDecoration(labelText: "Identificação:"),
                        onChanged: (text) {
                          _userEdited = true;
                          _profissionalEdicao.identificacao = text;
                        })
                  ],
                ),
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
                    Navigator.pushNamed(context, 'ListagemDeProfissionais',
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
