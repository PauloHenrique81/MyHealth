import 'package:flutter/material.dart';
import 'package:myhealth/Persistencia/P_DoarSangue.dart';
import 'package:myhealth/Service/ScreeanArguments.dart';
import 'package:myhealth/Service/Util.dart';
import 'package:myhealth/class/DoarSangue.dart';
import 'package:myhealth/class/user.dart';

import '../Loading.dart';

class ListagemDeDoacoes extends StatefulWidget {
  final User user;
  ListagemDeDoacoes({this.user});

  @override
  _ListagemDeDoacoesState createState() => _ListagemDeDoacoesState();
}

class _ListagemDeDoacoesState extends State<ListagemDeDoacoes> {
  P_DoarSangue bd = new P_DoarSangue();
  List<DoarSangue> doacoes = new List<DoarSangue>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Doações de sangue"),
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
            _novaDoacao(widget.user);
          },
          child: Icon(Icons.add),
          backgroundColor: Colors.deepPurple,
        ),
        body: FutureBuilder(
            future: buscaDoacoes(widget.user.uid),
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
                                                  "Assets/doar-sangue.jpg"),
                                              fit: BoxFit.cover),
                                        ),
                                      ),
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
                              doacao: doacoes[index], user: widget.user);
                        },
                      );
                    });
              }
            }));
  }

  Future buscaDoacoes(String idUser) async {
    doacoes = await bd.listaDeDoacoes(idUser);
    return _ordenarLista(doacoes, doacoes.length);
  }

  void _mostrarDetalhesDaConsulta({DoarSangue doacao, User user}) {
    ScreeanArguments screeanArguments =
        new ScreeanArguments(user: user, doacao: doacao);
    Navigator.of(context)
        .pushNamed('EdicaoDeDoacao', arguments: screeanArguments);
  }

  void _novaDoacao(User user) {
    ScreeanArguments screeanArguments = new ScreeanArguments(user: user);
    Navigator.of(context).pushNamed('NovaDoacao', arguments: screeanArguments);
  }

  List<DoarSangue> _ordenarLista(List<DoarSangue> lista, int n) {
    int i, j;
    DoarSangue key;

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
