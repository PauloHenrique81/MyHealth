import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:intl/intl.dart';
import 'package:myhealth/Helper/Vacina_Help.dart';
import 'package:myhealth/Persistencia/P_Vacina_x_User.dart';
import 'package:myhealth/class/Vacina_x_User.dart';
import 'package:myhealth/class/user.dart';

class EdicaoDeVacina extends StatefulWidget {
  VacinaUser vacinaUser;
  final TiposDeVacinas tipoDeVacina;
  final User user;

  EdicaoDeVacina({this.user, this.tipoDeVacina, this.vacinaUser});

  @override
  _EdicaoDeVacinaState createState() => _EdicaoDeVacinaState();
}

class _EdicaoDeVacinaState extends State<EdicaoDeVacina> {
  VacinaUser _vacinaUserEdicao;
  TiposDeVacinas _tipoDeVacina;
  bool _userEdited = false;
  bool novaVacinaUser = false;
  bool status = false;
  String statusText = "";

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

  P_Vacina_x_User conectionDB = new P_Vacina_x_User();
  final _localController = TextEditingController();
  final _dataController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tipoDeVacina = widget.tipoDeVacina;

    if (widget.vacinaUser == null) {
      _vacinaUserEdicao = VacinaUser("", "", "");
      novaVacinaUser = true;
      statusText = "Você ainda não tomou essa vacina :/";
    } else {
      _vacinaUserEdicao = widget.vacinaUser;

      _dataController.text = _vacinaUserEdicao.data;
      _localController.text = _vacinaUserEdicao.local;
      statusText = "Você já tomou essa vacina :)";
      status = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepPurple,
          title: Text(_tipoDeVacina.tipo),
          centerTitle: true,
        ),
        floatingActionButton: SpeedDial(
            animatedIcon: AnimatedIcons.menu_close,
            overlayColor: Colors.black87,
            animatedIconTheme: IconThemeData.fallback(),
            children: [
              SpeedDialChild(
                  child: Icon(Icons.cancel),
                  backgroundColor: Colors.red,
                  label: "Excluir",
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text("Excluir dados ?"),
                            content: Text(
                                "Se excluir, o status da Vacina voltara a ser 'Não tomada'"),
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
                                  conectionDB.excluirVacinaUser(
                                      _tipoDeVacina.codigo, _tipoDeVacina.uid);
                                  Navigator.pushReplacementNamed(
                                      context, 'ListagemTiposDeVacinas',
                                      arguments: widget.user);
                                },
                              )
                            ],
                          );
                        });
                  }),
              SpeedDialChild(
                child: Icon(Icons.save),
                backgroundColor: Colors.deepPurple,
                label: "Salvar",
                onTap: () async {
                  if (_dataController.text != "") {
                    if (novaVacinaUser == true) {
                      await conectionDB.cadastraVacinaUser(_tipoDeVacina.codigo,
                          widget.user.uid, _dataController.text,
                          local: _localController.text);
                    } else {
                      conectionDB.atualizarVacinaUser(_tipoDeVacina.codigo,
                          widget.user.uid, _dataController.text,
                          local: _localController.text);
                    }
                    Navigator.pop(context);
                  } else {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text("Aviso"),
                            content: Text(
                                "Não é possivel salvar com o campo Data vazio!"),
                            actions: <Widget>[
                              FlatButton(
                                child: Text("Voltar"),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              )
                            ],
                          );
                        });
                  }
                },
              ),
            ]),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                height: 10.0,
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: status ? Colors.green : Colors.red),
              ),
              Text(
                "Descrição:",
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              Card(
                child: Container(
                  padding: EdgeInsets.fromLTRB(3.0, 10.0, 3.0, 10.0),
                  child: Text(
                    _tipoDeVacina.descricao,
                    textAlign: TextAlign.justify,
                    style: TextStyle(fontSize: 18.0),
                  ),
                ),
              ),
              Text(
                "Dose:",
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              Card(
                child: Container(
                  padding: EdgeInsets.fromLTRB(3.0, 10.0, 3.0, 3.0),
                  child: Text(
                    _tipoDeVacina.doses,
                    textAlign: TextAlign.justify,
                    style: TextStyle(fontSize: 18.0),
                  ),
                ),
              ),
              Text(
                "Status:",
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              Card(
                child: Container(
                  padding: EdgeInsets.fromLTRB(3.0, 10.0, 3.0, 10.0),
                  child: Text(
                    statusText,
                    textAlign: TextAlign.justify,
                    style: TextStyle(fontSize: 18.0),
                  ),
                ),
              ),
              Card(
                  child: Column(children: <Widget>[
                Padding(padding: EdgeInsets.all(3.0)),
                Text(
                  "Outras informações:",
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                TextFormField(
                  controller: _dataController,
                  decoration: InputDecoration(labelText: " Dia em que tomou:"),
                  onChanged: (text) {
                    _userEdited = true;
                    _vacinaUserEdicao.data = text;
                  },
                  onTap: () => _selectDate(context),
                  keyboardType: TextInputType.datetime,
                ),
                TextFormField(
                  controller: _localController,
                  decoration: InputDecoration(labelText: " Local :"),
                ),
              ])),
            ],
          ),
        ));
  }
}
