import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:intl/intl.dart';
import 'package:myhealth/Persistencia/P_DoarSangue.dart';
import 'package:myhealth/Persistencia/P_UserLocalModulo.dart';
import 'package:myhealth/Service/ScreeanArguments.dart';
import 'package:myhealth/class/DoarSangue.dart';
import 'package:myhealth/class/UserLocalModulo.dart';
import 'package:myhealth/class/user.dart';

class EdicaoDedoacao extends StatefulWidget {
  final DoarSangue doacao;
  final User user;
  EdicaoDedoacao({this.user, this.doacao});

  @override
  _EdicaoDedoacaoState createState() => _EdicaoDedoacaoState();
}

class _EdicaoDedoacaoState extends State<EdicaoDedoacao> {
  DoarSangue _doacaoEdicao;
  bool _userEdited = false;
  bool _novaDoacao = false;

  bool _locCadastrada = false;
  String _idDoacao = "";
  UserLocalModulo _userLocalModulo = null;
  P_UserLocalModulo conectionUserLocalModulo = new P_UserLocalModulo();

  DateTime _date = new DateTime.now();
  TimeOfDay _time = new TimeOfDay.now();


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


  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay picked =
        await showTimePicker(context: context, initialTime: _time);
    if (picked != null) {
      setState(() {
        _horaController.text = formatTimeOfDay(picked);
      });
    }
  }

  String formatTimeOfDay(TimeOfDay tod) {
    final now = new DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    final format = DateFormat.jm();
    return format.format(dt);
  }

  final _formKey = GlobalKey<FormState>();

  P_DoarSangue conectionDB = new P_DoarSangue();

  final _dataController = TextEditingController();
  final _horaController = TextEditingController();
  final _localController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.doacao == null) {
      _doacaoEdicao = DoarSangue();
      _novaDoacao = true;
    } else {
      _doacaoEdicao = widget.doacao;

      _dataController.text = _doacaoEdicao.data;
      _horaController.text = _doacaoEdicao.horario;
      _localController.text = _doacaoEdicao.local;

      _getUserLocalModulo();
    }
  }

  void _getUserLocalModulo() async {
    _userLocalModulo = await conectionUserLocalModulo.getUserLocalModulo(
        widget.user.uid, widget.doacao.idDoacao);
    if (_userLocalModulo != null) {
      setState(() {
        _locCadastrada = true;
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
            title: Text("Doação"),
            centerTitle: true,
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
                    if (_novaDoacao == true) {
                      await conectionDB.cadastraDoacao(
                        widget.user.uid,
                        _dataController.text,
                        _horaController.text,
                        _localController.text,
                      );
                    } else {
                      await conectionDB.atualizarDocao(
                          widget.user.uid,
                           _doacaoEdicao.idDoacao,
                          _dataController.text,
                          _horaController.text,
                          _localController.text);
                    }

                    Navigator.pop(context);
                  }
                },
              ),
              SpeedDialChild(
                  child: Icon(Icons.cancel),
                  backgroundColor: Colors.red,
                  label: "Excluir",
                  onTap: () {
                    if (!_novaDoacao) {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text("Excluir Doação ?"),
                              content: Text(
                                  "As informações desta doação, serão excluidas permanentemente"),
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
                                    conectionDB.excluirDoacao(
                                        _doacaoEdicao.idDoacao,
                                        widget.user.uid);
                                    Navigator.pushReplacementNamed(
                                        context, 'ListagemDeDoacoes',
                                        arguments: widget.user);
                                  },
                                )
                              ],
                            );
                          });
                    }
                  }),
              SpeedDialChild(
                child: Icon(Icons.map),
                backgroundColor: Colors.deepPurple,
                label: _locCadastrada
                    ? "Visualizar localização"
                    : "Adicionar localização",
                onTap: () async {
                  if (_formKey.currentState.validate()) {
                    if (_novaDoacao == true) {
                      _idDoacao = await conectionDB.cadastraDoacao(
                        widget.user.uid,
                        _dataController.text,
                        _horaController.text,
                        _localController.text,
                      );
                    } else {
                      await conectionDB.atualizarDocao(
                          widget.user.uid,
                          _doacaoEdicao.idDoacao,
                          _dataController.text,
                          _horaController.text,
                          _localController.text);

                      _idDoacao = _doacaoEdicao.idDoacao;
                    }

                    if (_locCadastrada) {
                      ScreeanArguments screeanArguments = new ScreeanArguments(
                          user: widget.user,
                          string1: _idDoacao,
                          string2: "DoarSangue",
                          userLocalModulo: _userLocalModulo);
                      Navigator.of(context)
                          .pushNamed('Maps', arguments: screeanArguments);
                    } else {
                      ScreeanArguments screeanArguments = new ScreeanArguments(
                          user: widget.user,
                          string1: _idDoacao,
                          string2: "DoarSangue");
                      Navigator.of(context)
                          .pushNamed('Maps', arguments: screeanArguments);
                    }
                  }
                },
              ),
            ],
          ),
          body: SingleChildScrollView(
              padding: EdgeInsets.all(10.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      controller: _dataController,
                      decoration: InputDecoration(labelText: "Data: *"),
                      validator: (val) => val.isEmpty ? 'Digite a data' : null,
                      onChanged: (text) {
                        _userEdited = true;
                        _doacaoEdicao.data = text;
                      },
                      onTap: () => _selectDate(context),
                      keyboardType: TextInputType.datetime,
                    ),
                    TextFormField(
                      controller: _horaController,
                      decoration: InputDecoration(labelText: "Horário: *"),
                      validator: (val) =>
                          val.isEmpty ? 'Digite o horário' : null,
                      onChanged: (text) {
                        _userEdited = true;
                        _doacaoEdicao.horario = text;
                      },
                      onTap: () => _selectTime(context),
                      keyboardType: TextInputType.datetime,
                    ),
                    TextFormField(
                      controller: _localController,
                      decoration: InputDecoration(labelText: "Local: *"),
                      validator: (val) => val.isEmpty ? 'Digite o local' : null,
                      onChanged: (text) {
                        _userEdited = true;
                        _doacaoEdicao.local = text;
                      },

                      
                    ),
                    Container(
                      padding: EdgeInsets.only(bottom: 30.0),
                    ),

                    Container(
                      padding: EdgeInsets.all(5.0),
                      child:  Image(image:  AssetImage("Assets/doar-sangue2.png"), fit: BoxFit.cover,),
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
                    Navigator.pushNamed(context, 'ListagemDeDoacoes',
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
