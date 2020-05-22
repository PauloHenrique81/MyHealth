import 'package:flutter/material.dart';
import 'package:myhealth/Screens/HabilitarProfissional/ServiceHP.dart';
import 'package:myhealth/Service/ScreeanArguments.dart';
import 'dart:async';

import 'package:myhealth/class/Profissional.dart';
import 'package:myhealth/class/user.dart';

class HabilitarProfissionalListagem extends StatefulWidget {
  User user;
  bool moduloSolicitarConsulta = false;
  HabilitarProfissionalListagem({this.user, this.moduloSolicitarConsulta}) : super();

  final String title = "Lista de Profissionais";

  @override
  HabilitarProfissionalListagemState createState() =>
      HabilitarProfissionalListagemState();
}

class Debouncer {
  final int milliseconds;
  VoidCallback action;
  Timer _timer;

  Debouncer({this.milliseconds});

  run(VoidCallback action) {
    if (null != _timer) {
      _timer.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}

class HabilitarProfissionalListagemState
    extends State<HabilitarProfissionalListagem> {
  //
  final _debouncer = Debouncer(milliseconds: 500);
  List<Profissional> users = List();
  List<Profissional> filteredUsers = List();

  @override
  void initState() {
    super.initState();
    ServicesHP.getProfissionaisUsers().then((usersProf) {
      setState(() {
        users = usersProf;
        filteredUsers = users;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.refresh,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {});
            },
          )
        ],
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pushReplacementNamed(context, 'HomePage',
                    arguments: widget.user);
              },
            );
          },
        ),
      ),
      body: Column(
        children: <Widget>[
          TextField(
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(15.0),
              hintText: 'Filtrar por Código do Profissional ou Nome',
            ),
            onChanged: (string) {
              _debouncer.run(() {
                setState(() {
                  filteredUsers = users
                      .where((u) => (u.identificacao
                              .toLowerCase()
                              .contains(string.toLowerCase()) ||
                          u.nome.toLowerCase().contains(string.toLowerCase())))
                      .toList();
                });
              });
            },
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(10.0),
              itemCount: filteredUsers == null ? 0 : filteredUsers.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  child: Card(
                    child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            filteredUsers[index].nome,
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                filteredUsers[index].profissao,
                                style: TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                filteredUsers[index].identificacao,
                                style: TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  onTap: () {
                    _mostrarDetalhes(
                        profissional: filteredUsers[index], user: widget.user);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _mostrarDetalhes({Profissional profissional, User user}) {

    if(widget.moduloSolicitarConsulta){
      ScreeanArguments screeanArguments =
        new ScreeanArguments(user: user, profissional: profissional);
    Navigator.of(context)
        .pushNamed('HabilitarProfissionalEdicao', arguments: screeanArguments);
    }else{
      ScreeanArguments screeanArguments =
        new ScreeanArguments(user: user, profissional: profissional);
      Navigator.of(context)
        .pushNamed('SolicitarConsultaEdicao', arguments: screeanArguments);
    }
    
  }
}
