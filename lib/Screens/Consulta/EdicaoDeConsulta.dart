import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:intl/intl.dart';
import 'package:myhealth/Persistencia/P_Consulta.dart';
import 'package:myhealth/Persistencia/P_UserLocalModulo.dart';
import 'package:myhealth/Service/ScreeanArguments.dart';
import 'package:myhealth/class/Consulta.dart';
import 'package:myhealth/class/UserLocalModulo.dart';
import 'package:myhealth/class/user.dart';

class EdicaoDeConsulta extends StatefulWidget {
  final Consulta consulta;
  final User user;
  EdicaoDeConsulta({this.user, this.consulta});

  @override
  _EdicaoDeConsultaState createState() => _EdicaoDeConsultaState();
}

class _EdicaoDeConsultaState extends State<EdicaoDeConsulta> {
  Consulta _consultaEdicao;
  bool _userEdited = false;
  bool _novaConsulta = false;
  bool _locCadastrada = false;
  String _idConsulta = "";
  UserLocalModulo _userLocalModulo = null;

  DateTime _date = new DateTime.now();
  TimeOfDay _time = new TimeOfDay.now();

  var formasDePagamento = [
    "Dinheiro",
    "Cartão de Crédito",
    "Cartão de Débito",
    "Plano de saúde"
  ];

  String formaDePagamento = "";

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

  DatabaseService conectionDB = new DatabaseService();

  P_UserLocalModulo conectionUserLocalModulo = new P_UserLocalModulo();

  final _nomeMedicoController = TextEditingController();

  final _especialidadeController = TextEditingController();
  final _dataController = TextEditingController();
  final _horaController = TextEditingController();
  final _localController = TextEditingController();
  final _diagnosticoController = TextEditingController();
  final _examesController = TextEditingController();
  final _medicamentosController = TextEditingController();
  final _formaDePagamentoController = TextEditingController();
  final _valorController = TextEditingController();
  final __codProfissionalController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.consulta == null) {
      _consultaEdicao = Consulta();
      _novaConsulta = true;
    } else {
      _consultaEdicao = widget.consulta;

      _nomeMedicoController.text = _consultaEdicao.nomeDoMedico;
      _especialidadeController.text = _consultaEdicao.especialidade;
      _dataController.text = _consultaEdicao.data;
      _horaController.text = _consultaEdicao.horario;
      _localController.text = _consultaEdicao.local;
      _diagnosticoController.text = _consultaEdicao.diagnostico;
      _examesController.text = _consultaEdicao.exames;
      _medicamentosController.text = _consultaEdicao.medicamentos;
      _formaDePagamentoController.text = _consultaEdicao.formaDePagamento;
      _valorController.text = _consultaEdicao.valor;
      formaDePagamento = _consultaEdicao.formaDePagamento;
      __codProfissionalController.text = _consultaEdicao.codigoDoProfissional;
      _getUserLocalModulo();
    }
  }

  void _getUserLocalModulo() async {
    _userLocalModulo = await conectionUserLocalModulo.getUserLocalModulo(
        widget.user.uid, widget.consulta.idConsulta);
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
            title: Text(_consultaEdicao.nomeDoMedico ?? "Nova Consulta"),
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
                    if (_novaConsulta == true) {
                      await conectionDB.cadastraConsulta(
                          widget.user.uid,
                          _nomeMedicoController.text,
                          _dataController.text,
                          _horaController.text,
                          _localController.text,
                          especialidade: _especialidadeController.text,
                          codigoDoProfissional: __codProfissionalController.text);
                    } else {
                      await conectionDB.atualizarConsulta(
                          widget.user.uid,
                          _consultaEdicao.idConsulta,
                          _nomeMedicoController.text,
                          _dataController.text,
                          _horaController.text,
                          _localController.text,
                          especialidade: _especialidadeController.text,
                          diagnostico: _diagnosticoController.text,
                          exames: _examesController.text,
                          medicamentos: _medicamentosController.text,
                          formaDePagamento: _formaDePagamentoController.text,
                          valor: _valorController.text,
                          codigoDoProfissional: __codProfissionalController.text);
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
                    if (!_novaConsulta) {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text("Excluir Consulta ?"),
                              content: Text(
                                  "As informações desta consulta, serão excluidas permanentemente"),
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
                                    conectionDB.excluirConsulta(
                                        _consultaEdicao.idConsulta,
                                        widget.user.uid);
                                    Navigator.pushReplacementNamed(
                                        context, 'ListagemDeConsultas',
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
                    ? "Vizualizar localização"
                    : "Adicionar localização",
                onTap: () async {
                  if (_formKey.currentState.validate()) {
                    if (_novaConsulta == true) {
                      _idConsulta = await conectionDB.cadastraConsulta(
                          widget.user.uid,
                          _nomeMedicoController.text,
                          _dataController.text,
                          _horaController.text,
                          _localController.text,
                          especialidade: _especialidadeController.text,
                          codigoDoProfissional: __codProfissionalController.text);
                    } else {
                      await conectionDB.atualizarConsulta(
                          widget.user.uid,
                          _consultaEdicao.idConsulta,
                          _nomeMedicoController.text,
                          _dataController.text,
                          _horaController.text,
                          _localController.text,
                          especialidade: _especialidadeController.text,
                          diagnostico: _diagnosticoController.text,
                          exames: _examesController.text,
                          medicamentos: _medicamentosController.text,
                          formaDePagamento: _formaDePagamentoController.text,
                          valor: _valorController.text,
                          codigoDoProfissional: __codProfissionalController.text);

                      _idConsulta = _consultaEdicao.idConsulta;
                    }

                    if (_locCadastrada) {
                      ScreeanArguments screeanArguments = new ScreeanArguments(
                          user: widget.user,
                          string1: _idConsulta,
                          string2: "Consulta",
                          userLocalModulo: _userLocalModulo);
                      Navigator.of(context)
                          .pushNamed('Maps', arguments: screeanArguments);
                    } else {
                      ScreeanArguments screeanArguments = new ScreeanArguments(
                          user: widget.user,
                          string1: _idConsulta,
                          string2: "Consulta");
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
                      decoration:
                          InputDecoration(labelText: "Nome do Profissional: *"),
                      validator: (val) =>
                          val.isEmpty ? 'Digite o nome do Profissional' : null,
                      onChanged: (text) {
                        _userEdited = true;
                        setState(() {
                          _consultaEdicao.nomeDoMedico = text;
                        });
                      },
                    ),
                    TextField(
                      controller: _especialidadeController,
                      decoration: InputDecoration(
                          labelText: "Especialidade do Profissional:"),
                      onChanged: (text) {
                        _userEdited = true;
                        _consultaEdicao.especialidade = text;
                      },
                    ),
                    TextField(
                      controller: __codProfissionalController,
                      decoration: InputDecoration(
                          labelText: "Codigo de identificação  do Profissional:"),
                      onChanged: (text) {
                        _userEdited = true;
                        _consultaEdicao.codigoDoProfissional = text;
                      },
                    ),
                    TextFormField(
                      controller: _dataController,
                      decoration: InputDecoration(labelText: "Data: *"),
                      validator: (val) => val.isEmpty ? 'Digite a data' : null,
                      onChanged: (text) {
                        _userEdited = true;
                        _consultaEdicao.data = text;
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
                        _consultaEdicao.horario = text;
                      },
                      onTap: () => _selectTime(context),
                      keyboardType: TextInputType.datetime,
                    ),
                    TextFormField(
                      controller: _localController,
                      decoration:
                          InputDecoration(labelText: "Nome do local: *"),
                      validator: (val) => val.isEmpty ? 'Digite o local' : null,
                      onChanged: (text) {
                        _userEdited = true;
                        _consultaEdicao.local = text;
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                      child: Text(
                        "Pós consulta",
                        style: TextStyle(fontSize: 22.0),
                      ),
                    ),
                    TextFormField(
                      controller: _diagnosticoController,
                      decoration:
                          InputDecoration(labelText: "Diagnóstico dado:"),
                      onChanged: (text) {
                        _userEdited = true;
                        _consultaEdicao.diagnostico = text;
                      },
                    ),
                    TextFormField(
                      controller: _examesController,
                      decoration:
                          InputDecoration(labelText: "Exames solicitados:"),
                      onChanged: (text) {
                        _userEdited = true;
                        _consultaEdicao.exames = text;
                      },
                    ),
                    TextFormField(
                      controller: _medicamentosController,
                      decoration: InputDecoration(
                          labelText: "Medicamentos receitados:"),
                      onChanged: (text) {
                        _userEdited = true;
                        _consultaEdicao.medicamentos = text;
                      },
                    ),
                    TextFormField(
                      controller: _valorController,
                      decoration: InputDecoration(labelText: "Valor:"),
                      onChanged: (text) {
                        _userEdited = true;
                        _consultaEdicao.valor = text;
                      },
                      keyboardType: TextInputType.number,
                    ),
                    Row(
                      children: <Widget>[
                        Text("Forma de Pagamento : ",
                            style: TextStyle(color: Colors.black)),
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
                              _consultaEdicao.formaDePagamento = text;
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
                    Navigator.pushNamed(context, 'ListagemDeConsultas',
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
