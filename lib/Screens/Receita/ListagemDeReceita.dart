import 'package:flutter/material.dart';
import 'package:myhealth/Persistencia/P_Receita.dart';
import 'package:myhealth/Service/ScreeanArguments.dart';
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
                                      Text(snapshot.data[index].descricao ?? "",
                                          style: TextStyle(fontSize: 18.0)),
                                    ],
                                  ),
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
    return receitas;
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
}
