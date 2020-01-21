import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:myhealth/class/Consulta.dart';
import 'package:myhealth/class/database.dart';

class EdicaoDeConsulta extends StatefulWidget {
  final Consulta consulta;
  EdicaoDeConsulta({this.consulta});

  @override
  _EdicaoDeConsultaState createState() => _EdicaoDeConsultaState();
}

class _EdicaoDeConsultaState extends State<EdicaoDeConsulta> {
  Consulta _consultaEdicao;
  bool _userEdited = false;
  bool _novaConsulta = false;

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
          conectionDB.cadastraConsulta(
              '112',
              _nomeMedicoController.text,
              _dataController.text,
              _horaController.text,
              _localController.text);
        },
        child: Icon(Icons.save),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _nomeMedicoController,
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
              keyboardType: TextInputType.datetime,
            ),
            TextField(
              controller: _horaController,
              decoration: InputDecoration(labelText: "Horário:"),
              onChanged: (text) {
                _userEdited = true;
                _consultaEdicao.horario = text;
              },
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
      ),
    );
  }
}
