import 'package:flutter/material.dart';
import 'package:myhealth/Persistencia/P_Profissional.dart';
import 'package:myhealth/Service/ScreeanArguments.dart';
import 'package:myhealth/class/Profissional.dart';
import 'package:myhealth/class/user.dart';

import '../Loading.dart';

class ListagemDeProfissionais extends StatefulWidget {
  final User user;
  ListagemDeProfissionais({this.user});

  @override
  _ListagemDeProfissionaisState createState() =>
      _ListagemDeProfissionaisState();
}

class _ListagemDeProfissionaisState extends State<ListagemDeProfissionais> {
  P_Profissional bd = new P_Profissional();
  List<Profissional> profissionais = new List<Profissional>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Profissionais"),
          backgroundColor: Colors.deepPurple,
          centerTitle: true,
        ),
        backgroundColor: Colors.white,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _novaConsulta(widget.user);
          },
          child: Icon(Icons.add),
          backgroundColor: Colors.deepPurple,
        ),
        body: FutureBuilder(
            future: buscaCirurgias(widget.user.uid),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.data == null) {
                return Container(
                  child: Center(
                    child: LoadingAnimation(),
                  ),
                );
              } else {
                return ListView.builder(
                    padding: EdgeInsets.all(10.0),
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        child: Card(
                          child: Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Container(
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(snapshot.data[index].tipoExame ?? "",
                                          style: TextStyle(
                                              fontSize: 22.0,
                                              fontWeight: FontWeight.bold)),
                                      Text(
                                          snapshot.data[index].nomeDoMedico ??
                                              "",
                                          style: TextStyle(fontSize: 18.0)),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Text(snapshot.data[index].local ?? "",
                                          style: TextStyle(fontSize: 18.0)),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      Text(snapshot.data[index].data ?? "",
                                          style: TextStyle(fontSize: 18.0)),
                                      Text("    ",
                                          style: TextStyle(fontSize: 18.0)),
                                      Text(snapshot.data[index].horario ?? "",
                                          style: TextStyle(fontSize: 18.0))
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        onTap: () {
                          _mostrarDetalhesDaConsulta(
                              profissional: profissionais[index],
                              user: widget.user);
                        },
                      );
                    });
              }
            }));
  }

  Future buscaCirurgias(String idUser) async {
    profissionais = await bd.listaDeProfissionais(idUser);
    return profissionais;
  }

  void _mostrarDetalhesDaConsulta({Profissional profissional, User user}) {
    ScreeanArguments screeanArguments =
        new ScreeanArguments(user: user, profissional: profissional);
    Navigator.of(context)
        .pushNamed('EdicaoDeProfissional', arguments: screeanArguments);
  }

  void _novaConsulta(User user) {
    ScreeanArguments screeanArguments = new ScreeanArguments(user: user);
    Navigator.of(context)
        .pushNamed('NovoProfissioanl', arguments: screeanArguments);
  }
}
