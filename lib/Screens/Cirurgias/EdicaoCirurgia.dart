import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myhealth/Persistencia/P_Cirurgia.dart';
import 'package:myhealth/class/Cirurgia.dart';
import 'package:myhealth/class/user.dart';

class EdicaoDeCirurgia extends StatefulWidget {
  final Cirurgia consulta;
  final User user;
  EdicaoDeCirurgia({this.user, this.consulta});

  @override
  _EdicaoDeCirurgiaState createState() => _EdicaoDeCirurgiaState();
}

class _EdicaoDeCirurgiaState extends State<EdicaoDeCirurgia> {
  Cirurgia _cirurgiaEdicao;
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

  P_Cirurgia conectionDB = new P_Cirurgia();

  final _nomeMedicoController = TextEditingController();
  final _especialidadeController = TextEditingController();
  final _tipoDeCirurgiaController = TextEditingController();
  final _dataController = TextEditingController();
  final _horaController = TextEditingController();
  final _localController = TextEditingController();
  final _recomendacaoMedicaPosCirurgicoController = TextEditingController();
  final _medicacaoPosCirurgicoController = TextEditingController();
  final _medicamentosController = TextEditingController();
  final _formaDePagamentoController = TextEditingController();
  final _valorController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.consulta == null) {
      _cirurgiaEdicao = Cirurgia();
      _novaConsulta = true;
    } else {
      _cirurgiaEdicao = widget.consulta;

      _nomeMedicoController.text = _cirurgiaEdicao.nomeDoMedico;
      _especialidadeController.text = _cirurgiaEdicao.especialidade;
      _tipoDeCirurgiaController.text = _cirurgiaEdicao.tipoDeCirurgia;
      _dataController.text = _cirurgiaEdicao.data;
      _horaController.text = _cirurgiaEdicao.horario;
      _localController.text = _cirurgiaEdicao.local;
      
      _recomendacaoMedicaPosCirurgicoController.text = _cirurgiaEdicao.recomendacaoMedicaPosCirurgico;
      _medicacaoPosCirurgicoController.text = _cirurgiaEdicao.medicacaoPosCirurgico;
      _medicamentosController.text = _cirurgiaEdicao.medicacaoPosCirurgico;
      _medicamentosController.text = _cirurgiaEdicao.dataRetorno;
      _formaDePagamentoController.text = _cirurgiaEdicao.formaDePagamento;
      _valorController.text = _cirurgiaEdicao.valor;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () => _requestPop(context),
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.deepPurple,
            title: Text(_cirurgiaEdicao.tipoDeCirurgia ?? "Nova Cirurgia"),
            centerTitle: true,
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              if (_formKey.currentState.validate()) {
                if (_novaConsulta == true) {
                  await conectionDB.cadastraCirurgia(
                      widget.user.uid,
                      _nomeMedicoController.text,
                      _especialidadeController.text,
                      _tipoDeCirurgiaController.text,
                      _dataController.text,
                      _horaController.text,
                      _localController.text,);
                } else {
                  await conectionDB.atualizarConsulta(
                      widget.user.uid,
                      _cirurgiaEdicao.idCirurgia,
                      _nomeMedicoController.text,
                      _especialidadeController.text,
                      _tipoDeCirurgiaController.text,
                      _dataController.text,
                      _horaController.text,
                      _localController.text,
                      recomendacaoMedicaPosCirurgico: _diagnosticoController.text,
                      medicacaoPosCirurgica: _examesController.text,
                      dataRetorno: _medicamentosController.text,
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
                          _cirurgiaEdicao.nomeDoMedico = text;
                        });
                      },
                    ),
                    TextField(
                      controller: _especialidadeController,
                      decoration: InputDecoration(
                          labelText: "Especialidade do Médico:"),
                      onChanged: (text) {
                        _userEdited = true;
                        _cirurgiaEdicao.especialidade = text;
                      },
                    ),
                    TextField(
                      controller: _tipoDeCirurgiaController,
                      decoration: InputDecoration(
                          labelText: "Tipo de cirurgia:"),
                      onChanged: (text) {
                        _userEdited = true;
                        _cirurgiaEdicao.tipoDeCirurgia = text;
                      },
                    ),
                    TextFormField(
                      controller: _dataController,
                      decoration: InputDecoration(labelText: "Data:"),
                      validator: (val) => val.isEmpty ? 'Digite a data' : null,
                      onChanged: (text) {
                        _userEdited = true;
                        _cirurgiaEdicao.data = text;
                      },
                      onTap: () => _selectDate(context),
                      keyboardType: TextInputType.datetime,
                    ),
                    TextFormField(
                      controller: _horaController,
                      decoration: InputDecoration(labelText: "Horário:"),
                      validator: (val) =>
                          val.isEmpty ? 'Digite o horário' : null,
                      onChanged: (text) {
                        _userEdited = true;
                        _cirurgiaEdicao.horario = text;
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
                        _cirurgiaEdicao.local = text;
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
                      controller: _formaDePagamentoController,
                      decoration:
                          InputDecoration(labelText: "Forma de pagamento:"),
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
                     Navigator.pushNamed(context, 'ListagemDeConsultas', arguments: widget.user);
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