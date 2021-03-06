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
            _novoProfissional(widget.user);
          },
          child: Icon(Icons.add),
          backgroundColor: Colors.deepPurple,
        ),
        body: FutureBuilder(
            future: buscaProfissionais(widget.user.uid),
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
                                                  "Assets/iconeProfissional.png"),
                                              fit: BoxFit.cover),
                                        ),
                                      ),
                                      Text(snapshot.data[index].profissao ?? "",
                                          style: TextStyle(
                                              fontSize: 20.0,
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      Text(snapshot.data[index].nome ?? "",
                                          style: TextStyle(
                                            fontSize: 18.0,
                                          )),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        onTap: () {
                          _mostrarDetalhesDoProfissional(
                              profissional: profissionais[index],
                              user: widget.user);
                        },
                      );
                    });
              }
            }));
  }

  Future buscaProfissionais(String idUser) async {
    profissionais = await bd.listaDeProfissionais(idUser);
    return profissionais;
  }

  void _mostrarDetalhesDoProfissional({Profissional profissional, User user}) {
    ScreeanArguments screeanArguments =
        new ScreeanArguments(user: user, profissional: profissional);
    Navigator.of(context)
        .pushNamed('EdicaoDeProfissional', arguments: screeanArguments);
  }

  void _novoProfissional(User user) {
    ScreeanArguments screeanArguments = new ScreeanArguments(user: user);
    Navigator.of(context)
        .pushNamed('NovoProfissional', arguments: screeanArguments);
  }
}
