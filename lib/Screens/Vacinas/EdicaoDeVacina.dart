import 'package:flutter/material.dart';
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

  final _tipoController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _doseController = TextEditingController();
  final _statusController = TextEditingController();
  final _dataController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tipoDeVacina = widget.tipoDeVacina;

    _tipoController.text = _tipoDeVacina.tipo;
    _descricaoController.text = _tipoDeVacina.descricao;
    _doseController.text = _tipoDeVacina.doses;

    if (widget.vacinaUser == null) {
      _vacinaUserEdicao = VacinaUser("", "", "");
      novaVacinaUser = true;
      _statusController.text = "Não tomada";
    } else {
      _vacinaUserEdicao = widget.vacinaUser;

      _dataController.text = _vacinaUserEdicao.data;
      _statusController.text = "Tomada";
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
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (_formKey.currentState.validate()) {
            if (novaVacinaUser == true) {
              await conectionDB.cadastraVacinaUser(
                  _tipoDeVacina.codigo, widget.user.uid, _dataController.text);
            } else {
              await conectionDB.atualizarVacinaUser(
                  _tipoDeVacina.codigo, widget.user.uid, _dataController.text);
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
                  controller: _tipoController,
                  decoration: InputDecoration(labelText: "Tipo:"),
                  onChanged: (text) {
                    setState(() {
                      _tipoDeVacina.tipo = text;
                    });
                  },
                ),
                TextField(
                  controller: _descricaoController,
                  decoration: InputDecoration(labelText: "Descrição:"),
                  onChanged: (text) {
                    _tipoDeVacina.descricao = text;
                  },
                ),
                TextFormField(
                  controller: _doseController,
                  decoration: InputDecoration(labelText: "Dose:"),
                  onChanged: (text) {
                    _tipoDeVacina.doses = text;
                  },
                ),
                TextFormField(
                  controller: _statusController,
                  decoration: InputDecoration(labelText: "Status :"),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                  child: Text(
                    "Já tomou essa vacina ?",
                    style: TextStyle(fontSize: 22.0),
                  ),
                ),
                TextFormField(
                  controller: _dataController,
                  decoration: InputDecoration(labelText: "Data:"),
                  validator: (val) => val.isEmpty ? 'Digite a data' : null,
                  onChanged: (text) {
                    _userEdited = true;
                    _vacinaUserEdicao.data = text;
                  },
                  onTap: () => _selectDate(context),
                  keyboardType: TextInputType.datetime,
                ),
              ],
            ),
          )),
    );
  }
}
// Future<bool> _requestPop(BuildContext context) {
//   if (_userEdited) {
//     showDialog(
//         context: context,
//         builder: (context) {
//           return AlertDialog(
//             title: Text("Descartar alterações?"),
//             content: Text("Se sair as alterações serão perdidas."),
//             actions: <Widget>[
//               FlatButton(
//                 child: Text("Cancelar"),
//                 onPressed: () {
//                   Navigator.pop(context);
//                 },
//               ),
//               FlatButton(
//                 child: Text("Sim"),
//                 onPressed: () {
//                   Navigator.pushNamed(context, 'ListagemDeExames',
//                       arguments: widget.user);
//                 },
//               )
//             ],
//           );
//         });
//     return Future.value(false);
//   } else {
//     return Future.value(true);
//   }
// }
