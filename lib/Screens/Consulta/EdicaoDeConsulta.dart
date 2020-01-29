import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myhealth/class/Consulta.dart';
import 'package:myhealth/class/database.dart';
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

  DatabaseService conectionDB = new DatabaseService();

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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text(_consultaEdicao.nomeDoMedico ?? "Nova Consulta"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (_formKey.currentState.validate()) {
            if (_novaConsulta == true) {
              await conectionDB.cadastraConsulta(
                  widget.user.uid,
                  _nomeMedicoController.text,
                  _dataController.text,
                  _horaController.text,
                  _localController.text);
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
                  valor: _valorController.text);
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
                  controller: _nomeMedicoController,
                  decoration: InputDecoration(labelText: "Nome do Médico:"),
                  validator: (val) =>
                      val.isEmpty ? 'Digite o nome do Médico' : null,
                  onChanged: (text) {
                    _userEdited = true;
                    setState(() {
                      _consultaEdicao.nomeDoMedico = text;
                    });
                  },
                ),
                TextField(
                  controller: _especialidadeController,
                  decoration:
                      InputDecoration(labelText: "Especialidade do Médico:"),
                  onChanged: (text) {
                    _userEdited = true;
                    _consultaEdicao.especialidade = text;
                  },
                ),
                TextFormField(
                  controller: _dataController,
                  decoration: InputDecoration(labelText: "Data:"),
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
                  decoration: InputDecoration(labelText: "Horário:"),
                  validator: (val) => val.isEmpty ? 'Digite o horário' : null,
                  onChanged: (text) {
                    _userEdited = true;
                    _consultaEdicao.horario = text;
                  },
                  onTap: () => _selectTime(context),
                  keyboardType: TextInputType.datetime,
                ),
                TextFormField(
                  controller: _localController,
                  decoration: InputDecoration(labelText: "Local:"),
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
                  decoration: InputDecoration(labelText: "Diagnóstico dado:"),
                  onChanged: (text) {
                    _userEdited = true;
                    _consultaEdicao.diagnostico = text;
                  },
                ),
                TextFormField(
                  controller: _examesController,
                  decoration: InputDecoration(labelText: "Exames solicitados:"),
                  onChanged: (text) {
                    _userEdited = true;
                    _consultaEdicao.exames = text;
                  },
                ),
                TextFormField(
                  controller: _medicamentosController,
                  decoration:
                      InputDecoration(labelText: "Medicamentos receitados:"),
                  onChanged: (text) {
                    _userEdited = true;
                    _consultaEdicao.medicamentos = text;
                  },
                ),
                TextFormField(
                  controller: _formaDePagamentoController,
                  decoration: InputDecoration(labelText: "Forma de pagamento:"),
                  onChanged: (text) {
                    _userEdited = true;
                    _consultaEdicao.formaDePagamento = text;
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
              ],
            ),
          )),
    );
  }
}
