import 'package:flutter/material.dart';
import 'package:myhealth/Persistencia/P_Cirurgia.dart';
import 'package:myhealth/Service/ScreeanArguments.dart';
import 'package:myhealth/Service/Util.dart';
import 'package:myhealth/class/Cirurgia.dart';
import 'package:myhealth/class/user.dart';

import '../Loading.dart';

class ListagemDeCirurgias extends StatefulWidget {
  final User user;
  ListagemDeCirurgias({this.user});

  @override
  _ListagemDeCirurgiasState createState() => _ListagemDeCirurgiasState();
}

class _ListagemDeCirurgiasState extends State<ListagemDeCirurgias> {
  P_Cirurgia bd = new P_Cirurgia();
  List<Cirurgia> cirurgias = new List<Cirurgia>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Cirurgias"),
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
                                      Text(
                                          snapshot.data[index].tipoDeCirurgia ??
                                              "",
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
                                          style: TextStyle(fontSize: 18.0)),
                                      Container(
                                        alignment: Alignment.center,
                                        width: 10.0,
                                        height: 10.0,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.rectangle,
                                            color: Util.verificaData(snapshot
                                                        .data[index].data) <=
                                                    0
                                                ? Colors.green
                                                : Colors.red),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        onTap: () {
                          _mostrarDetalhesDaConsulta(
                              cirurgia: cirurgias[index], user: widget.user);
                        },
                      );
                    });
              }
            }));
  }

  Future buscaCirurgias(String idUser) async {
    cirurgias = await bd.listaDeCirurgias(idUser);
    return _ordenarLista(cirurgias, cirurgias.length);
  }

  void _mostrarDetalhesDaConsulta({Cirurgia cirurgia, User user}) {
    ScreeanArguments screeanArguments =
        new ScreeanArguments(user: user, cirurgia: cirurgia);
    Navigator.of(context)
        .pushNamed('EdicaoDeCirurgia', arguments: screeanArguments);
  }

  void _novaConsulta(User user) {
    ScreeanArguments screeanArguments = new ScreeanArguments(user: user);
    Navigator.of(context)
        .pushNamed('NovaCirurgia', arguments: screeanArguments);
  }

  List<Cirurgia> _ordenarLista(List<Cirurgia> lista, int n) {
    int i, j;
    Cirurgia key;

    for (i = 1; i < n; i++) {
      key = lista[i];
      j = i - 1;
      while (
          j >= 0 && lista[j].convertData().compareTo(key.convertData()) < 0) {
        lista[j + 1] = lista[j];
        j = j - 1;
      }
      lista[j + 1] = key;
    }

    return lista;
  }
}
