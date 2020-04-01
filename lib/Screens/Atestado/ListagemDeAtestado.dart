import 'package:flutter/material.dart';
import 'package:myhealth/Persistencia/P_Atestado.dart';
import 'package:myhealth/Persistencia/P_Receita.dart';
import 'package:myhealth/Service/ScreeanArguments.dart';
import 'package:myhealth/class/Atestado.dart';
import 'package:myhealth/class/Receita.dart';
import 'package:myhealth/class/user.dart';

import '../Loading.dart';

class ListagemDeAtestados extends StatefulWidget {
  final User user;
  ListagemDeAtestados({this.user});

  @override
  _ListagemDeAtestadosState createState() => _ListagemDeAtestadosState();
}

class _ListagemDeAtestadosState extends State<ListagemDeAtestados> {
  P_Atestado bd = new P_Atestado();
  List<Atestado> atestados = new List<Atestado>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Atestados"),
          backgroundColor: Colors.deepPurple,
          centerTitle: true,
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
        backgroundColor: Colors.white,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _novoAtestado(widget.user);
          },
          child: Icon(Icons.add),
          backgroundColor: Colors.deepPurple,
        ),
        body: FutureBuilder(
            future: buscaAtestado(widget.user.uid),
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
                                      Text(snapshot.data[index].medico ?? "",
                                          style: TextStyle(
                                              fontSize: 22.0,
                                              fontWeight: FontWeight.bold)),
                                      Text(snapshot.data[index].data ?? "",
                                          style: TextStyle(fontSize: 18.0)),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Text(snapshot.data[index].motivo ?? "",
                                          style: TextStyle(fontSize: 18.0)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        onTap: () {
                          _mostrarDetalhesDaAtestado(
                              atestado: atestados[index], user: widget.user);
                        },
                      );
                    });
              }
            }));
  }

  Future buscaAtestado(String idUser) async {
    atestados = await bd.listaDeAtestados(idUser);
    return atestados;
  }

  void _mostrarDetalhesDaAtestado({Atestado atestado, User user}) {
    ScreeanArguments screeanArguments =
        new ScreeanArguments(user: user, atestado: atestado);
    Navigator.of(context)
        .pushNamed('EdicaoDeAtestado', arguments: screeanArguments);
  }

  void _novoAtestado(User user) {
    ScreeanArguments screeanArguments = new ScreeanArguments(user: user);
    Navigator.of(context)
        .pushNamed('NovoAtestado', arguments: screeanArguments);
  }
}
