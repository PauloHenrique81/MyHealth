import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:intl/intl.dart';
import 'package:myhealth/Persistencia/P_Atestado.dart';
import 'package:myhealth/Persistencia/P_Imagem.dart';
import 'package:myhealth/Screens/Loading.dart';
import 'package:myhealth/Service/ScreeanArguments.dart';
import 'package:myhealth/class/Atestado.dart';
import 'package:myhealth/class/Imagem.dart';
import 'package:myhealth/class/user.dart';

class EdicaoDeAtestado extends StatefulWidget {
  final Atestado atestado;
  final User user;
  EdicaoDeAtestado({this.user, this.atestado});

  @override
  _EdicaoDeAtestadoState createState() => _EdicaoDeAtestadoState();
}

class _EdicaoDeAtestadoState extends State<EdicaoDeAtestado> {
  Atestado _atestadoEdicao;
  bool _userEdited = false;
  bool _novoAtestado = false;

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

  P_Atestado conectionDB = new P_Atestado();

  List<Imagem> imagens = new List<Imagem>();
  P_Imagem conectionDB_imagem = new P_Imagem();

  final _medicoController = TextEditingController();
  final _dataController = TextEditingController();
  final _quantidadeDeDiasController = TextEditingController();
  final _motivoController = TextEditingController();
  var idAtestado;

  @override
  void initState() {
    super.initState();

    if (widget.atestado == null) {
      _atestadoEdicao = Atestado();
      _novoAtestado = true;
    } else {
      _atestadoEdicao = widget.atestado;

      _medicoController.text = _atestadoEdicao.medico;
      _dataController.text = _atestadoEdicao.data;
      _quantidadeDeDiasController.text = _atestadoEdicao.quantidadeDeDias;
      _motivoController.text = _atestadoEdicao.motivo;

      idAtestado = _atestadoEdicao.idAtestado;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () => _requestPop(context),
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.deepPurple,
            title: Text("Novo Atestado"),
            centerTitle: true,
            actions: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.refresh,
                  color: Colors.white,
                ),
                onPressed: () {
                  setState(() {});
                },
              )
            ],
          ),
          floatingActionButton: SpeedDial(
            animatedIcon: AnimatedIcons.menu_close,
            overlayColor: Colors.black87,
            animatedIconTheme: IconThemeData.fallback(),
            children: [
              SpeedDialChild(
                child: Icon(Icons.save),
                backgroundColor: Colors.deepPurple,
                label: "Salvar",
                onTap: () async {
                  if (_formKey.currentState.validate()) {
                    if (_novoAtestado == true) {
                      await conectionDB.cadastraAtestado(
                          widget.user.uid,
                          _medicoController.text,
                          _dataController.text,
                          _quantidadeDeDiasController.text,
                          _motivoController.text);
                    } else {
                      await conectionDB.atualizarAtestado(
                          widget.user.uid,
                          _atestadoEdicao.idAtestado,
                          _medicoController.text,
                          _dataController.text,
                          _quantidadeDeDiasController.text,
                          _motivoController.text);
                      idAtestado = _atestadoEdicao.idAtestado;
                    }

                    Navigator.pop(context);
                  }
                },
              ),
              SpeedDialChild(
                  child: Icon(Icons.image),
                  backgroundColor: Colors.red,
                  label: "Excluir imagens",
                  onTap: () {
                    if (!_novoAtestado) {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text("Excluir Imagens ?"),
                              content: Text("Todas as imagens serão deletadas"),
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
                                    if (imagens != null) {
                                      conectionDB_imagem.excluirImagem(
                                          widget.user.uid,
                                          _atestadoEdicao.idAtestado);
                                    }
                                    Navigator.pop(context);
                                  },
                                )
                              ],
                            );
                          });
                    }
                  }),
              SpeedDialChild(
                  child: Icon(Icons.cancel),
                  backgroundColor: Colors.red,
                  label: "Excluir atestado",
                  onTap: () {
                    if (!_novoAtestado) {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text("Excluir Atestado ?"),
                              content: Text(
                                  "As informações deste Atestado, serão excluidos permanentemente"),
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
                                    conectionDB.excluirAtestado(
                                        _atestadoEdicao.idAtestado,
                                        widget.user.uid);

                                    Navigator.pushReplacementNamed(
                                        context, 'ListagemDeAtestados',
                                        arguments: widget.user);
                                  },
                                )
                              ],
                            );
                          });
                    }
                  }),
            ],
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
                      decoration: InputDecoration(labelText: "Médico: *"),
                      validator: (val) =>
                          val.isEmpty ? 'Digite o nome do Médico' : null,
                      onChanged: (text) {
                        _userEdited = true;
                        _atestadoEdicao.medico = text;
                      },
                    ),
                    TextFormField(
                      controller: _dataController,
                      decoration: InputDecoration(labelText: "Data: *"),
                      validator: (val) => val.isEmpty ? 'Digite a data' : null,
                      onChanged: (text) {
                        _userEdited = true;
                        _atestadoEdicao.data = text;
                      },
                      onTap: () => _selectDate(context),
                      keyboardType: TextInputType.datetime,
                    ),
                    TextFormField(
                        keyboardType: TextInputType.text,
                        controller: _quantidadeDeDiasController,
                        decoration:
                            InputDecoration(labelText: "Quantidade de dias: *"),
                         validator: (val) => val.isEmpty ? 'Digite a qauntidade de dias' : null,
                        onChanged: (text) {
                          _userEdited = true;
                          _atestadoEdicao.quantidadeDeDias = text;
                        }),
                    TextFormField(
                        keyboardType: TextInputType.text,
                        controller: _motivoController,
                        decoration: InputDecoration(labelText: "Motivo:"),
                        onChanged: (text) {
                          _userEdited = true;
                          _atestadoEdicao.motivo = text;
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
                              if (_formKey.currentState.validate()) {
                                if (_novoAtestado == true) {
                                  idAtestado =
                                      await conectionDB.cadastraAtestado(
                                          widget.user.uid,
                                          _medicoController.text,
                                          _dataController.text,
                                          _quantidadeDeDiasController.text,
                                          _motivoController.text);
                                  _novoAtestado = false;
                                } else {
                                  await conectionDB.atualizarAtestado(
                                      widget.user.uid,
                                      _atestadoEdicao.idAtestado,
                                      _medicoController.text,
                                      _dataController.text,
                                      _quantidadeDeDiasController.text,
                                      _motivoController.text);
                                  idAtestado = _atestadoEdicao.idAtestado;
                                }

                                Imagem img = new Imagem(
                                    idUser: widget.user.uid,
                                    modulo: "Atestados",
                                    idItem: idAtestado);
                                _inserirImagem(user: widget.user, imagem: img);
                              }
                            })
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                            child: SizedBox(
                          height: 500.0,
                          child: FutureBuilder(
                              future: buscaImagens(widget.user.uid, idAtestado),
                              builder: (BuildContext context,
                                  AsyncSnapshot snapshot) {
                                if (snapshot.data == null) {
                                  return Container(
                                    child: Center(
                                      child: LoadingAnimation(),
                                    ),
                                  );
                                } else {
                                  return ListView.builder(
                                      padding: EdgeInsets.all(10.0),
                                      scrollDirection: Axis.horizontal,
                                      itemCount: snapshot.data.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return snapshot.data.length == 0
                                            ? null
                                            : GestureDetector(
                                                child: Card(
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsets.all(10.0),
                                                    child: Container(
                                                      child: Image.network(
                                                          snapshot
                                                              .data[index].url),
                                                    ),
                                                  ),
                                                ),
                                                onTap: () {},
                                              );
                                      });
                                }
                              }),
                        ))
                      ],
                    )
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
                    Navigator.pushNamed(context, 'ListagemDeAtestados',
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

  void _inserirImagem({User user, Imagem imagem}) {
    ScreeanArguments screeanArguments =
        new ScreeanArguments(user: user, imagem: imagem);
    Navigator.of(context)
        .pushNamed('ImageCapture', arguments: screeanArguments);
  }

  Future buscaImagens(String idUser, String idItem) async {
    if (idItem != null) {
      imagens = await conectionDB_imagem.listaDeImagens(idUser, idItem);
    }
    return imagens;
  }
}
