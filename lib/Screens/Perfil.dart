import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myhealth/Persistencia/P_Paciente.dart';
import 'package:myhealth/class/Paciente.dart';

class Perfil extends StatefulWidget {
  final String uid;
  Perfil({this.uid});

  @override
  _PerfilState createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {
  Paciente _paciente;
  P_Paciente conectionDB = new P_Paciente();

  DateTime _date = new DateTime.now();
  var _userEdited = false;

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: _date,
        firstDate: new DateTime(2020),
        lastDate: new DateTime(2023));

    if (picked != null) {
      setState(() {
        _dataDeNascimentoController.text =
            new DateFormat("dd-MM-yyyy").format(picked);
      });
    }
  }

  String formatTimeOfDay(TimeOfDay tod) {
    final now = new DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    final format = DateFormat.jm();
    return format.format(dt);
  }

  buscaPaciente(String uid) async {
    var teste = await conectionDB.listaDePacientes(uid);
    return teste;
  }

  final _formKey = GlobalKey<FormState>();

  final _nomeController = TextEditingController();
  final _dataDeNascimentoController = TextEditingController();
  final _cpfController = TextEditingController();
  final _emailController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _cidadeController = TextEditingController();
  final _tipoSanguineoController = TextEditingController();
  final _medicamentosAlergicosController = TextEditingController();
  final _alimentosAlergicosController = TextEditingController();
  final _intoleranciaController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // var aux = buscaPaciente(widget.uid);
    // _paciente = aux[0];

    _nomeController.text = _paciente.nome;
    _dataDeNascimentoController.text = _paciente.dataDeNascimento;
    _cpfController.text = _paciente.cpf;
    _emailController.text = _paciente.email;
    _telefoneController.text = _paciente.telefone;
    _cidadeController.text = _paciente.cidade;
    _tipoSanguineoController.text = _paciente.tipoSanguineo;
    _medicamentosAlergicosController.text = _paciente.medicamentosAlergicos;
    _alimentosAlergicosController.text = _paciente.alimentosAlergicos;
    _intoleranciaController.text = _paciente.intolerancia;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () => _requestPop(context),
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.deepPurple,
            title: Text("Perfil"),
            centerTitle: true,
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              if (_formKey.currentState.validate()) {
                await conectionDB.atualizarPaciente(
                    widget.uid, _nomeController.text, _cpfController.text,
                    dataDeNascimento: _dataDeNascimentoController.text,
                    email: _emailController.text,
                    telefone: _telefoneController.text,
                    cidade: _cidadeController.text,
                    tipoSanguineo: _tipoSanguineoController.text,
                    medicamentosAlergicos:
                        _medicamentosAlergicosController.text,
                    alimentosAlergicos: _alimentosAlergicosController.text,
                    intolerancia: _intoleranciaController.text);

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
                      controller: _nomeController,
                      decoration: InputDecoration(labelText: "Nome:"),
                      validator: (val) =>
                          val.isEmpty ? 'Digite seu nome' : null,
                      onChanged: (text) {
                        setState(() {
                          _userEdited = true;
                          _paciente.nome = text;
                        });
                      },
                    ),
                    TextField(
                      controller: _cpfController,
                      decoration: InputDecoration(labelText: "CPF:"),
                      onChanged: (text) {
                        _userEdited = true;
                        _paciente.cpf = text;
                      },
                    ),
                    TextFormField(
                      controller: _dataDeNascimentoController,
                      decoration:
                          InputDecoration(labelText: "Data de nascimento:"),
                      validator: (val) => val.isEmpty ? 'Digite a data' : null,
                      onChanged: (text) {
                        _userEdited = true;
                        _paciente.dataDeNascimento = text;
                      },
                      onTap: () => _selectDate(context),
                      keyboardType: TextInputType.datetime,
                    ),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(labelText: "email:"),
                      onChanged: (text) {
                        _userEdited = true;
                        _paciente.email = text;
                      },
                    ),
                    TextFormField(
                      controller: _telefoneController,
                      decoration: InputDecoration(labelText: "Telefone:"),
                      onChanged: (text) {
                        _userEdited = true;
                        _paciente.telefone = text;
                      },
                    ),
                    TextFormField(
                      controller: _cidadeController,
                      decoration: InputDecoration(labelText: "Cidade:"),
                      onChanged: (text) {
                        _userEdited = true;
                        _paciente.cidade = text;
                      },
                    ),
                    TextFormField(
                      controller: _tipoSanguineoController,
                      decoration: InputDecoration(labelText: "Tipo sanquineo:"),
                      onChanged: (text) {
                        _userEdited = true;
                        _paciente.tipoSanguineo = text;
                      },
                    ),
                    TextFormField(
                      controller: _medicamentosAlergicosController,
                      decoration:
                          InputDecoration(labelText: "Medicamentos Alérgicos:"),
                      onChanged: (text) {
                        _userEdited = true;
                        _paciente.medicamentosAlergicos = text;
                      },
                    ),
                    TextFormField(
                      controller: _alimentosAlergicosController,
                      decoration:
                          InputDecoration(labelText: "Alimentos Alérgicos:"),
                      onChanged: (text) {
                        _userEdited = true;
                        _paciente.alimentosAlergicos = text;
                      },
                      keyboardType: TextInputType.number,
                    ),
                    TextFormField(
                      controller: _intoleranciaController,
                      decoration: InputDecoration(labelText: "Intolerância:"),
                      onChanged: (text) {
                        _userEdited = true;
                        _paciente.intolerancia = text;
                      },
                      keyboardType: TextInputType.number,
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
                    Navigator.pushReplacementNamed(context, 'HomePage');
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