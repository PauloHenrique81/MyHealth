import 'package:flutter/material.dart';
import 'package:myhealth/Persistencia/P_Exame.dart';
import 'package:myhealth/Service/ScreeanArguments.dart';
import 'package:myhealth/Service/Util.dart';
import 'package:myhealth/class/Exame.dart';
import 'package:myhealth/class/user.dart';

import '../Loading.dart';

class ListagemDeExames extends StatefulWidget {
  final User user;
  ListagemDeExames({this.user});

  @override
  _ListagemDeExamesState createState() => _ListagemDeExamesState();
}

class _ListagemDeExamesState extends State<ListagemDeExames> {
  P_Exame bd = new P_Exame();
  List<Exame> exames = new List<Exame>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Exames"),
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
                  Navigator.pushNamedAndRemoveUntil(
                      context, 'HomePage', (Route<dynamic> route) => false,
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
                                      Container(
                                        width: 40.0,
                                        height: 40.0,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                              image: AssetImage(
                                                  "Assets/iconeExame.png"),
                                              fit: BoxFit.cover),
                                        ),
                                      ),
                                      Text(snapshot.data[index].tipoExame ?? "",
                                          style: TextStyle(
                                              fontSize: 20.0,
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      Text(
                                          snapshot.data[index].data + "    " ??
                                              "",
                                          style: TextStyle(
                                            fontSize: 14.0,
                                          )),
                                      Text(snapshot.data[index].horario ?? "",
                                          style: TextStyle(fontSize: 14.0)),
                                      Container(
                                        alignment: Alignment.center,
                                        width: 10.0,
                                        height: 10.0,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.rectangle,
                                            color: Util.verificaData(snapshot
                                                        .data[index].data) <=
                                                    0
                                                ? Colors.blue
                                                : Colors.grey),
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
                              exame: exames[index], user: widget.user);
                        },
                      );
                    });
              }
            }));
  }

  Future buscaCirurgias(String idUser) async {
    exames = await bd.listaDeExames(idUser);
    return _ordenarLista(exames, exames.length);
  }

  void _mostrarDetalhesDaConsulta({Exame exame, User user}) {
    ScreeanArguments screeanArguments =
        new ScreeanArguments(user: user, exame: exame);
    Navigator.of(context)
        .pushNamed('EdicaoDeExame', arguments: screeanArguments);
  }

  void _novaConsulta(User user) {
    ScreeanArguments screeanArguments = new ScreeanArguments(user: user);
    Navigator.of(context).pushNamed('NovoExame', arguments: screeanArguments);
  }

  List<Exame> _ordenarLista(List<Exame> lista, int n) {
    int i, j;
    Exame key;

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
