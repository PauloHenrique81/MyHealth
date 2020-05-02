import 'package:flutter/material.dart';
import 'package:myhealth/Persistencia/P_Receita.dart';
import 'package:myhealth/Service/ScreeanArguments.dart';
import 'package:myhealth/Service/Util.dart';
import 'package:myhealth/class/Receita.dart';
import 'package:myhealth/class/user.dart';

import '../Loading.dart';

class ListagemDeReceitas extends StatefulWidget {
  final User user;
  ListagemDeReceitas({this.user});

  @override
  _ListagemDeReceitasState createState() => _ListagemDeReceitasState();
}

class _ListagemDeReceitasState extends State<ListagemDeReceitas> {
  P_Receita bd = new P_Receita();
  List<Receita> receitas = new List<Receita>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Receitas"),
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
            _novaReceita(widget.user);
          },
          child: Icon(Icons.add),
          backgroundColor: Colors.deepPurple,
        ),
        body: FutureBuilder(
            future: buscaReceitas(widget.user.uid),
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
                                                  "Assets/iconeReceita.png"),
                                              fit: BoxFit.cover),
                                        ),
                                      ),
                                      Text(snapshot.data[index].medico ?? "",
                                          style: TextStyle(
                                              fontSize: 20.0,
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      Text(snapshot.data[index].data ?? "",
                                          style: TextStyle(
                                            fontSize: 14.0,
                                          )),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        onTap: () {
                          _mostrarDetalhesDaReceita(
                              receita: receitas[index], user: widget.user);
                        },
                      );
                    });
              }
            }));
  }

  Future buscaReceitas(String idUser) async {
    receitas = await bd.listaDeReceitas(idUser);
    return _ordenarLista(receitas, receitas.length);
  }

  void _mostrarDetalhesDaReceita({Receita receita, User user}) {
    ScreeanArguments screeanArguments =
        new ScreeanArguments(user: user, receita: receita);
    Navigator.of(context)
        .pushNamed('EdicaoDeReceita', arguments: screeanArguments);
  }

  void _novaReceita(User user) {
    ScreeanArguments screeanArguments = new ScreeanArguments(user: user);
    Navigator.of(context).pushNamed('NovaReceita', arguments: screeanArguments);
  }

  List<Receita> _ordenarLista(List<Receita> lista, int n) {
    int i, j;
    Receita key;

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
