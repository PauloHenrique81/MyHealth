import 'package:flutter/material.dart';
import 'package:myhealth/class/Consulta.dart';
import 'package:myhealth/class/database.dart';
import 'package:myhealth/class/user.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

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

    if (picked != null && picked != _date) {
      setState(() {
        _dataController.text = picked.toString();
      });
    }
  }

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay picked =
        await showTimePicker(context: context, initialTime: _time);
    if (picked != null && picked != _time) {
      setState(() {
        _horaController.text = picked.toString();
      });
    }
  }

  final _formKey = GlobalKey<FormState>();

  DatabaseService conectionDB = new DatabaseService();

  final _nomeMedicoController = TextEditingController();
  final _nomeMedicoFocus = FocusNode();

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
      _valorController.text = _consultaEdicao.valor.toString();
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
        onPressed: () {
          if (_consultaEdicao.nomeDoMedico.isNotEmpty) {
            conectionDB.cadastraConsulta(
                widget.user.uid,
                _nomeMedicoController.text,
                _dataController.text,
                _horaController.text,
                _localController.text);
            Navigator.pushNamed(context, 'ListagemDeConsultas',
                arguments: widget.user);
          } else {
            FocusScope.of(context).requestFocus(_nomeMedicoFocus);
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
                TextField(
                  controller: _nomeMedicoController,
                  focusNode: _nomeMedicoFocus,
                  decoration: InputDecoration(labelText: "Nome do Médico:"),
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
                TextField(
                  controller: _dataController,
                  decoration: InputDecoration(labelText: "Data:"),
                  onChanged: (text) {
                    _userEdited = true;
                    _consultaEdicao.data = text;
                  },
                  onTap: () => _selectDate(context),
                  keyboardType: TextInputType.datetime,
                ),
                TextField(
                  controller: _horaController,
                  decoration: InputDecoration(labelText: "Horário:"),
                  onChanged: (text) {
                    _userEdited = true;
                    _consultaEdicao.horario = text;
                  },
                  onTap: () => _selectTime(context),
                  keyboardType: TextInputType.datetime,
                ),
                TextField(
                  controller: _localController,
                  decoration: InputDecoration(labelText: "Local:"),
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
                TextField(
                  controller: _diagnosticoController,
                  decoration: InputDecoration(labelText: "Diagnóstico dado:"),
                  onChanged: (text) {
                    _userEdited = true;
                    _consultaEdicao.diagnostico = text;
                  },
                ),
                TextField(
                  controller: _examesController,
                  decoration: InputDecoration(labelText: "Exames solicitados:"),
                  onChanged: (text) {
                    _userEdited = true;
                    _consultaEdicao.exames = text;
                  },
                ),
                TextField(
                  controller: _medicamentosController,
                  decoration:
                      InputDecoration(labelText: "Medicamentos receitados:"),
                  onChanged: (text) {
                    _userEdited = true;
                    _consultaEdicao.medicamentos = text;
                  },
                ),
                TextField(
                  controller: _formaDePagamentoController,
                  decoration: InputDecoration(labelText: "Forma de pagamento:"),
                  onChanged: (text) {
                    _userEdited = true;
                    _consultaEdicao.formaDePagamento = text;
                  },
                ),
                TextField(
                  controller: _valorController,
                  decoration: InputDecoration(labelText: "Valor:"),
                  onChanged: (text) {
                    _userEdited = true;
                    _consultaEdicao.valor = double.parse(text);
                  },
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          )),
    );
  }
}
