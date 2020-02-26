import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myhealth/Persistencia/P_Receita.dart';
import 'package:myhealth/class/Imagem.dart';
import 'package:myhealth/class/Receita.dart';
import 'package:myhealth/class/user.dart';

class EdicaoDeReceita extends StatefulWidget {
  final Receita receita;
  final User user;
  EdicaoDeReceita({this.user, this.receita});

  @override
  _EdicaoDeReceitaState createState() => _EdicaoDeReceitaState();
}

class _EdicaoDeReceitaState extends State<EdicaoDeReceita> {
  Receita _receitaEdicao;
  bool _userEdited = false;
  bool _novaReceita = false;

  DateTime _date = new DateTime.now();

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: _date,
        firstDate: new DateTime(2020),
        lastDate: new DateTime(2023));

    if (picked != null) {
      setState(() {
        _dataController.text = new DateFormat("dd-MM-yyyy").format(picked);
      });
    }
  }

  final _formKey = GlobalKey<FormState>();

  P_Receita conectionDB = new P_Receita();

  final _medicoController = TextEditingController();
  final _dataController = TextEditingController();
  final _descricaoController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.receita == null) {
      _receitaEdicao = Receita();
      _novaReceita = true;
    } else {
      _receitaEdicao = widget.receita;

      _medicoController.text = _receitaEdicao.medico;
      _dataController.text = _receitaEdicao.data;
      _descricaoController.text = _receitaEdicao.descricao;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () => _requestPop(context),
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.deepPurple,
            title: Text("Nova Receita"),
            centerTitle: true,
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              if (_formKey.currentState.validate()) {
                if (_novaReceita == true) {
                  await conectionDB.cadastraReceita(widget.user.uid,
                      _medicoController.text, _dataController.text,
                      descricao: _descricaoController.text);
                } else {
                  await conectionDB.atualizarReceita(
                      widget.user.uid,
                      _receitaEdicao.idReceita,
                      _medicoController.text,
                      _dataController.text,
                      descricao: _descricaoController.text);
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
                    TextFormField(
                      keyboardType: TextInputType.text,
                      controller: _medicoController,
                      decoration: InputDecoration(labelText: "Médico"),
                      validator: (val) =>
                          val.isEmpty ? 'Digite o nome do Médico' : null,
                      onChanged: (text) {
                        _userEdited = true;
                        _receitaEdicao.medico = text;
                      },
                    ),
                    TextFormField(
                      controller: _dataController,
                      decoration: InputDecoration(labelText: "Data:"),
                      validator: (val) => val.isEmpty ? 'Digite a data' : null,
                      onChanged: (text) {
                        _userEdited = true;
                        _receitaEdicao.data = text;
                      },
                      onTap: () => _selectDate(context),
                      keyboardType: TextInputType.datetime,
                    ),
                    TextFormField(
                        keyboardType: TextInputType.text,
                        controller: _descricaoController,
                        decoration: InputDecoration(labelText: "Descrição:"),
                        onChanged: (text) {
                          _userEdited = true;
                          _receitaEdicao.descricao = text;
                        }),
                    Padding(padding: EdgeInsets.all(10.0)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        IconButton(
                            icon: Icon(Icons.add_a_photo),
                            splashColor: Colors.cyan,
                            iconSize: 40.0,
                            tooltip: "Adicionar foto",
                            onPressed: () async {
                              var idReceita;
                              if (_formKey.currentState.validate()) {
                                if (_novaReceita == true) {
                                  idReceita = await conectionDB.cadastraReceita(
                                      widget.user.uid,
                                      _medicoController.text,
                                      _dataController.text,
                                      descricao: _descricaoController.text);
                                } else {
                                  await conectionDB.atualizarReceita(
                                      widget.user.uid,
                                      _receitaEdicao.idReceita,
                                      _medicoController.text,
                                      _dataController.text,
                                      descricao: _descricaoController.text);
                                  idReceita = _receitaEdicao.idReceita;
                                }
                                Imagem img = new Imagem(
                                    idUser: widget.user.uid,
                                    modulo: "Receitas",
                                    idItem: idReceita);
                                Navigator.pushNamed(context, 'ImageCapture',
                                    arguments: img);
                              }
                            })
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