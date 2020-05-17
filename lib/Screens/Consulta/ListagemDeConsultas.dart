import 'package:flutter/material.dart';
import 'package:myhealth/Persistencia/P_Consulta.dart';
import 'package:myhealth/Screens/Loading.dart';
import 'package:myhealth/Service/ScreeanArguments.dart';
import 'package:myhealth/Service/Util.dart';
import 'package:myhealth/class/Consulta.dart';
import 'package:myhealth/class/user.dart';

class ListagemDeConsultas extends StatefulWidget {
  final User user;
  ListagemDeConsultas({this.user});

  @override
  _ListagemDeConsultasState createState() => _ListagemDeConsultasState();
}

class _ListagemDeConsultasState extends State<ListagemDeConsultas> {
  DatabaseService bd = new DatabaseService();
  List<Consulta> consultas = new List<Consulta>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Consultas"),
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
            future: buscaConsultas(widget.user.uid),
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
                                                  "Assets/iconeConsulta.png"),
                                              fit: BoxFit.cover),
                                        ),
                                      ),
                                      Text(
                                          snapshot.data[index].nomeDoMedico ??
                                              "",
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
                              consulta: consultas[index], user: widget.user);
                        },
                      );
                    });
              }
            }));
  }

  Future buscaConsultas(String idUser) async {
    consultas = await bd.listaDeConsultas(idUser);
    return _ordenarLista(consultas, consultas.length);
  }

  void _mostrarDetalhesDaConsulta({Consulta consulta, User user}) {
    ScreeanArguments screeanArguments =
        new ScreeanArguments(user: user, consulta: consulta);
    Navigator.of(context)
        .pushNamed('EdicaoDeConsulta', arguments: screeanArguments);
  }

  void _novaConsulta(User user) {
    ScreeanArguments screeanArguments = new ScreeanArguments(user: user);
    Navigator.of(context)
        .pushNamed('NovaConsulta', arguments: screeanArguments);
  }
}

List<Consulta> _ordenarLista(List<Consulta> lista, int n) {
  int i, j;
  Consulta key;

  for (i = 1; i < n; i++) {
    key = lista[i];
    j = i - 1;
    while (j >= 0 && lista[j].convertData().compareTo(key.convertData()) < 0) {
      lista[j + 1] = lista[j];
      j = j - 1;
    }
    lista[j + 1] = key;
  }

  return lista;
}
