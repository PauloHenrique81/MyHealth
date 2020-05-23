import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:intl/intl.dart';
import 'package:myhealth/Persistencia/P_Consulta.dart';
import 'package:myhealth/Persistencia/P_SolicitarConsulta.dart';
import 'package:myhealth/class/SolicitarConsulta.dart';
import 'package:myhealth/class/user.dart';

class ValidarSolicitacao extends StatefulWidget {
  final SolicitarConsulta solicitacao;
  final User user;
  ValidarSolicitacao({this.user, this.solicitacao});

  @override
  _ValidarSolicitacaoState createState() => _ValidarSolicitacaoState();
}

class _ValidarSolicitacaoState extends State<ValidarSolicitacao> {
  SolicitarConsulta _solicitacaoEdicao;
  bool _userEdited = false;
  bool _novaSolicitacao = false;

  final _formKey = GlobalKey<FormState>();

  P_SolicitarConsulta conectionDB = new P_SolicitarConsulta();

  DatabaseService consultaDB = new DatabaseService();

  final _nomePacienteController = TextEditingController();
  final _cpfPacienteController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _dataController = TextEditingController();
  final _horarioController = TextEditingController();
  final _localController = TextEditingController();

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
        _horarioController.text = formatTimeOfDay(picked);
      });
    }
  }

  String formatTimeOfDay(TimeOfDay tod) {
    final now = new DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    final format = DateFormat.jm();
    return format.format(dt);
  }

  @override
  void initState() {
    super.initState();

    if (widget.solicitacao == null) {
      _solicitacaoEdicao = SolicitarConsulta();
      _novaSolicitacao = true;
    } else {
      _solicitacaoEdicao = widget.solicitacao;

      _nomePacienteController.text = _solicitacaoEdicao.nomePaciente;
      _cpfPacienteController.text = _solicitacaoEdicao.cpfPaciente;
      _telefoneController.text = _solicitacaoEdicao.telefone;
      _dataController.text = _solicitacaoEdicao.data;
      _horarioController.text = _solicitacaoEdicao.horario;
      _localController.text = _solicitacaoEdicao.local;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () => _requestPop(context),
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blue,
            title: Text("Solicitar consulta"),
            centerTitle: true,
          ),
          floatingActionButton: SpeedDial(
            animatedIcon: AnimatedIcons.menu_close,
            overlayColor: Colors.black87,
            animatedIconTheme: IconThemeData.fallback(),
            children: [
              SpeedDialChild(
                child: Icon(Icons.check),
                backgroundColor: Colors.green,
                label: "Aceitar",
                onTap: () async {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text("Atualizar status ?"),
                          content: Text(
                              "O paciente recebera uma atualização do status da solicitação e sera agendado uma consulta para essa data."),
                          actions: <Widget>[
                            FlatButton(
                              child: Text("Cancelar"),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                            FlatButton(
                              child: Text("Sim"),
                              onPressed: () async {
                                if (_formKey.currentState.validate()) {
                                  conectionDB.atualizarStatusSolicitacao(
                                      _solicitacaoEdicao.idSolicitacao,
                                      "aprovado",
                                      data: _dataController.text,
                                      horario: _horarioController.text,
                                      local: _localController.text);
                                  
                                  consultaDB.cadastraConsulta(_solicitacaoEdicao.codigoPaciente, 
                                                                _solicitacaoEdicao.nomeDoProfissional,
                                                                _dataController.text,
                                                                _horarioController.text,
                                                                _localController.text,
                                                                codigoDoProfissional:_solicitacaoEdicao.identificacaoProfissional);

                                  Navigator.pushReplacementNamed(
                                      context, 'SolicitacoesDeConsulta',
                                      arguments: widget.user);
                                }
                              },
                            )
                          ],
                        );
                      });
                },
              ),
              SpeedDialChild(
                child: Icon(Icons.remove),
                backgroundColor: Colors.red,
                label: "Recusar",
                onTap: () async {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text("Atualizar status ?"),
                          content: Text(
                              "O paciente recebera uma atualização do status da solicitação de consulta"),
                          actions: <Widget>[
                            FlatButton(
                              child: Text("Cancelar"),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                            FlatButton(
                              child: Text("Sim"),
                              onPressed: () async {
                                if (_formKey.currentState.validate()) {
                                  conectionDB.atualizarStatusSolicitacao(
                                      _solicitacaoEdicao.idSolicitacao,
                                      "reprovado",
                                      data: _dataController.text,
                                      horario: _horarioController.text,
                                      local: _localController.text);

                                  Navigator.pushReplacementNamed(
                                      context, 'SolicitacoesDeConsulta',
                                      arguments: widget.user);
                                }
                              },
                            )
                          ],
                        );
                      });
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
                      keyboardType: TextInputType.text,
                      controller: _nomePacienteController,
                      decoration: InputDecoration(labelText: "Nome: *"),
                      enabled: false,
                      validator: (val) =>
                          val.isEmpty ? 'Digite seu nome' : null,
                      onChanged: (text) {
                        _userEdited = true;
                        _solicitacaoEdicao.nomePaciente = text;
                      },
                    ),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      controller: _cpfPacienteController,
                      decoration: InputDecoration(labelText: "CPF: *"),
                      validator: (val) => val.isEmpty ? 'Digite seu CPF' : null,
                      enabled: false,
                      onChanged: (text) {
                        _userEdited = true;
                        _solicitacaoEdicao.cpfPaciente = text;
                      },
                    ),
                    TextFormField(
                        keyboardType: TextInputType.phone,
                        controller: _telefoneController,
                        enabled: false,
                        decoration: InputDecoration(labelText: "Telefone: *"),
                        validator: (val) => val.isEmpty
                            ? 'Digite seu numero de telefone'
                            : null,
                        onChanged: (text) {
                          _userEdited = true;
                          _solicitacaoEdicao.telefone = text;
                        }),
                    TextFormField(
                      controller: _dataController,
                      decoration: InputDecoration(labelText: "Data: *"),
                      validator: (val) => val.isEmpty ? 'Digite a data' : null,
                      onChanged: (text) {
                        _userEdited = true;
                        _solicitacaoEdicao.data = text;
                      },
                      onTap: () => _selectDate(context),
                      keyboardType: TextInputType.datetime,
                    ),
                    TextFormField(
                      controller: _horarioController,
                      decoration: InputDecoration(labelText: "Horário: *"),
                      validator: (val) =>
                          val.isEmpty ? 'Digite o horário' : null,
                      onChanged: (text) {
                        _userEdited = true;
                        _solicitacaoEdicao.horario = text;
                      },
                      onTap: () => _selectTime(context),
                      keyboardType: TextInputType.datetime,
                    ),
                    TextFormField(
                        keyboardType: TextInputType.text,
                        controller: _localController,
                        decoration: InputDecoration(labelText: "Local: *"),
                        validator: (val) =>
                            val.isEmpty ? 'Digite nome do local' : null,
                        onChanged: (text) {
                          _userEdited = true;
                          _solicitacaoEdicao.local = text;
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
                    Navigator.pushReplacementNamed(context, 'SolicitacoesDeConsulta',
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

class MaskedTextInputFormatterShifter {}
