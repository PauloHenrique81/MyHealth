import 'package:flutter/material.dart';
import 'package:myhealth/Persistencia/P_HabilitarProfissional.dart';
import 'package:myhealth/class/HabilitarProfissional.dart';
import 'package:myhealth/class/Profissional.dart';
import 'package:myhealth/class/user.dart';

class HabilitarProfissionalEdicao extends StatefulWidget {
  final Profissional profissional;
  final User user;
  HabilitarProfissionalEdicao({this.user, this.profissional});

  @override
  _HabilitarProfissionalEdicaoState createState() =>
      _HabilitarProfissionalEdicaoState();
}

class _HabilitarProfissionalEdicaoState
    extends State<HabilitarProfissionalEdicao> {
  Profissional _profissionalEdicao;
  bool _userEdited = false;
  bool _novoProfissional = false;
  HabilitarProfissional habilitarProfissional;
  final _formKey = GlobalKey<FormState>();

  P_HabilitarProfissional conectionDB = new P_HabilitarProfissional();

  String habilitado = "";
  var tipoUser = ["Sim", "Não"];

  final _profissaoController = TextEditingController();
  final _nomeController = TextEditingController();
  final _localDeAtendimentoController = TextEditingController();

  final _habilitadoController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.profissional == null) {
      _profissionalEdicao = Profissional();
    } else {
      _profissionalEdicao = widget.profissional;

      _profissaoController.text = _profissionalEdicao.profissao;
      _nomeController.text = _profissionalEdicao.nome;
      _localDeAtendimentoController.text =
          _profissionalEdicao.localDeAtendimento;
    }

    _getHabilitadoProfissional();
  }

  void _getHabilitadoProfissional() async {
    habilitarProfissional = await conectionDB.getHabilitarProfissional(
        widget.user.uid, widget.profissional.idProfissional);

    if (habilitarProfissional == null) {
      setState(() {
        habilitado = "Não";
      });

      _novoProfissional = true;
    } else {
      _novoProfissional = false;

      setState(() {
        habilitado = habilitarProfissional.estaHabilitado;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () => _requestPop(context),
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.deepPurple,
            title: Text(_profissionalEdicao.nome),
            centerTitle: true,
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              if (_formKey.currentState.validate()) {
                if (_novoProfissional == true) {
                  if (_userEdited) {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text("Habilitar Profissional"),
                            content: Text(
                                "Ao habilitar um profissional, tal profissional podera ter acesso a algumas informações suas."),
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
                                  conectionDB.cadastraHabilitarProfissional(
                                      widget.user.uid,
                                      widget.profissional.idProfissional,
                                      habilitado);

                                  Navigator.popAndPushNamed(
                                      context, 'HabilitarProfissional',
                                      arguments: widget.user);
                                },
                              )
                            ],
                          );
                        });
                  }
                } else {
                  conectionDB.atualizarProfissional(
                      habilitarProfissional.idDocumento, habilitado);
                  Navigator.popAndPushNamed(context, 'HabilitarProfissional',
                      arguments: widget.user);
                }
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
                    Container(
                      alignment: Alignment.center,
                      height: 10.0,
                      decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          color:
                              habilitado == "Sim" ? Colors.green : Colors.red),
                    ),
                    TextFormField(
                      keyboardType: TextInputType.text,
                      controller: _nomeController,
                      decoration: InputDecoration(labelText: "Nome:"),
                      onChanged: (text) {
                        _profissionalEdicao.nome = text;
                      },
                    ),
                    TextFormField(
                        keyboardType: TextInputType.text,
                        controller: _profissaoController,
                        decoration: InputDecoration(labelText: "Profissão:"),
                        onChanged: (text) {
                          _profissionalEdicao.profissao = text;
                        }),
                    TextFormField(
                        keyboardType: TextInputType.text,
                        controller: _localDeAtendimentoController,
                        decoration:
                            InputDecoration(labelText: "Local de atendimento:"),
                        onChanged: (text) {
                          _profissionalEdicao.localDeAtendimento = text;
                        }),
                    Padding(padding: EdgeInsets.only(top: 10.0)),
                    Row(
                      children: <Widget>[
                        Text("Habilitar : "),
                        Expanded(
                          child: DropdownButton(
                            hint: Text(habilitado),
                            items: tipoUser.map((String tipoUserEscolhido) {
                              return DropdownMenuItem<String>(
                                value: tipoUserEscolhido,
                                child: Text(tipoUserEscolhido),
                              );
                            }).toList(),
                            onChanged: (text) {
                              _userEdited = true;
                              _profissionalEdicao.tipoUser = text;
                              _habilitadoController.text = text;

                              setState(() {
                                habilitado = text;
                              });
                            },
                            isExpanded: true,
                          ),
                        )
                      ],
                    ),
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
                    Navigator.popAndPushNamed(context, 'HabilitarProfissional',
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
