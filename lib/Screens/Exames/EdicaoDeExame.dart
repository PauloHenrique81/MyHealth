import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:intl/intl.dart';
import 'package:myhealth/Persistencia/P_Exame.dart';
import 'package:myhealth/Persistencia/P_UserLocalModulo.dart';
import 'package:myhealth/Service/ScreeanArguments.dart';
import 'package:myhealth/class/Exame.dart';
import 'package:myhealth/class/UserLocalModulo.dart';
import 'package:myhealth/class/user.dart';

class EdicaoDeExame extends StatefulWidget {
  final Exame exame;
  final User user;
  EdicaoDeExame({this.user, this.exame});

  @override
  _EdicaoDeExameState createState() => _EdicaoDeExameState();
}

class _EdicaoDeExameState extends State<EdicaoDeExame> {
  Exame _exameEdicao;
  bool _userEdited = false;
  bool _novoExame = false;

  bool _locCadastrada = false;
  String _idExame = "";
  UserLocalModulo _userLocalModulo = null;
  P_UserLocalModulo conectionUserLocalModulo = new P_UserLocalModulo();

  DateTime _date = new DateTime.now();
  TimeOfDay _time = new TimeOfDay.now();

  var formasDePagamento = [
    "Dinheiro",
    "Cartão de Crédito",
    "Cartão de Débito",
    "Plano de saúde"
  ];

  String formaDePagamento = "";

  Future<Null> _selectDateResultado(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: _date,
        firstDate: new DateTime(2020),
        lastDate: new DateTime(2023));

    if (picked != null) {
      setState(() {
        _dataResultadoController.text =
            new DateFormat("dd-MM-yyyy").format(picked);
      });
    }
  }

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

  P_Exame conectionDB = new P_Exame();

  final _nomeMedicoController = TextEditingController();

  final _tipoExameController = TextEditingController();
  final _dataController = TextEditingController();
  final _horaController = TextEditingController();
  final _localController = TextEditingController();
  final _dataResultadoController = TextEditingController();
  final _formaDePagamentoController = TextEditingController();
  final _valorController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.exame == null) {
      _exameEdicao = Exame();
      _novoExame = true;
    } else {
      _exameEdicao = widget.exame;

      _nomeMedicoController.text = _exameEdicao.nomeDoMedico;
      _tipoExameController.text = _exameEdicao.tipoExame;
      _dataController.text = _exameEdicao.data;
      _horaController.text = _exameEdicao.horario;
      _localController.text = _exameEdicao.local;
      _dataResultadoController.text = _exameEdicao.dataResultado;
      _formaDePagamentoController.text = _exameEdicao.formaDePagamento;
      _valorController.text = _exameEdicao.valor;
      formaDePagamento = _exameEdicao.formaDePagamento;
      _getUserLocalModulo();
    }
  }

  void _getUserLocalModulo() async {
    _userLocalModulo = await conectionUserLocalModulo.getUserLocalModulo(
        widget.user.uid, widget.exame.idExame);
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
            title: Text(_exameEdicao.nomeDoMedico ?? "Novo Exame"),
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
                    if (_novoExame == true) {
                      await conectionDB.cadastraExame(
                        widget.user.uid,
                        _nomeMedicoController.text,
                        _tipoExameController.text,
                        _dataController.text,
                        _horaController.text,
                        _localController.text,
                      );
                    } else {
                      await conectionDB.atualizarExame(
                          widget.user.uid,
                          _exameEdicao.idExame,
                          _nomeMedicoController.text,
                          _tipoExameController.text,
                          _dataController.text,
                          _horaController.text,
                          _localController.text,
                          dataResultado: _dataResultadoController.text,
                          formaDePagamento: _formaDePagamentoController.text,
                          valor: _valorController.text);
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
                    if (!_novoExame) {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text("Excluir Exame ?"),
                              content: Text(
                                  "As informações deste exame, serão excluidos permanentemente"),
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
                                    conectionDB.excluirExame(
                                        _exameEdicao.idExame, widget.user.uid);
                                    Navigator.pushReplacementNamed(
                                        context, 'ListagemDeExames',
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
                backgroundColor: Colors.blue,
                label: _locCadastrada
                    ? "Visualizar localização"
                    : "Adicionar localização",
                onTap: () async {
                  if (_formKey.currentState.validate()) {
                    if (_novoExame == true) {
                      _idExame = await conectionDB.cadastraExame(
                        widget.user.uid,
                        _nomeMedicoController.text,
                        _tipoExameController.text,
                        _dataController.text,
                        _horaController.text,
                        _localController.text,
                      );
                    } else {
                      await conectionDB.atualizarExame(
                          widget.user.uid,
                          _exameEdicao.idExame,
                          _nomeMedicoController.text,
                          _tipoExameController.text,
                          _dataController.text,
                          _horaController.text,
                          _localController.text,
                          dataResultado: _dataResultadoController.text,
                          formaDePagamento: _formaDePagamentoController.text,
                          valor: _valorController.text);

                      _idExame = _exameEdicao.idExame;
                    }

                    if (_locCadastrada) {
                      ScreeanArguments screeanArguments = new ScreeanArguments(
                          user: widget.user,
                          string1: _idExame,
                          string2: "Exame",
                          userLocalModulo: _userLocalModulo);
                      Navigator.of(context)
                          .pushNamed('Maps', arguments: screeanArguments);
                    } else {
                      ScreeanArguments screeanArguments = new ScreeanArguments(
                          user: widget.user,
                          string1: _idExame,
                          string2: "Exame");
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
                      controller: _nomeMedicoController,
                      decoration: InputDecoration(labelText: "Nome do Médico: *"),
                      validator: (val) =>
                          val.isEmpty ? 'Digite o nome do Médico' : null,
                      onChanged: (text) {
                        _userEdited = true;
                        setState(() {
                          _exameEdicao.nomeDoMedico = text;
                        });
                      },
                    ),
                    TextField(
                      controller: _tipoExameController,
                      decoration: InputDecoration(labelText: "Tipo de Exame:"),
                      onChanged: (text) {
                        _userEdited = true;
                        _exameEdicao.tipoExame = text;
                      },
                    ),
                    TextFormField(
                      controller: _dataController,
                      decoration: InputDecoration(labelText: "Data: *"),
                      validator: (val) => val.isEmpty ? 'Digite a data' : null,
                      onChanged: (text) {
                        _userEdited = true;
                        _exameEdicao.data = text;
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
                        _exameEdicao.horario = text;
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
                        _exameEdicao.local = text;
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                      child: Text(
                        "Pós exame",
                        style: TextStyle(fontSize: 22.0),
                      ),
                    ),
                    TextFormField(
                      controller: _dataResultadoController,
                      decoration:
                          InputDecoration(labelText: "Data do resultado:"),
                      onChanged: (text) {
                        _userEdited = true;
                        _exameEdicao.dataResultado = text;
                      },
                      onTap: () => _selectDateResultado(context),
                    ),
                    TextFormField(
                      controller: _valorController,
                      decoration: InputDecoration(labelText: "Valor:"),
                      onChanged: (text) {
                        _userEdited = true;
                        _exameEdicao.valor = text;
                      },
                      keyboardType: TextInputType.number,
                    ),
                    Row(
                      children: <Widget>[
                        Text("Forma de Pagamento : ", style:TextStyle( color: Colors.black)),
                        Expanded(
                          child: DropdownButton(
                            hint: Text(formaDePagamento),
                            items: formasDePagamento
                                .map((String formaDePagamentoEscolhida) {
                              return DropdownMenuItem<String>(
                                value: formaDePagamentoEscolhida,
                                child: Text(formaDePagamentoEscolhida),
                              );
                            }).toList(),
                            onChanged: (text) {
                              _userEdited = true;
                              _exameEdicao.formaDePagamento = text;
                              _formaDePagamentoController.text = text;

                              setState(() {
                                formaDePagamento = text;
                              });
                            },
                            isExpanded: true,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 70),
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
                    Navigator.pushNamed(context, 'ListagemDeExames',
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
