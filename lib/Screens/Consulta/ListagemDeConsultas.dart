import 'package:flutter/material.dart';
import 'package:myhealth/Persistencia/P_Consulta.dart';
import 'package:myhealth/Screens/Loading.dart';
import 'package:myhealth/Service/ScreeanArguments.dart';
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
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(snapshot.data[index].nomeDoMedico ?? "",
                                               style: TextStyle(
                                               fontSize: 22.0,
                                               fontWeight: FontWeight.bold)),
                                        Text(snapshot.data[index].especialidade ?? "", style: TextStyle(fontSize: 18.0)),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:  MainAxisAlignment.start,
                                      children: <Widget>[
                                         Text(snapshot.data[index].local ?? "",style: TextStyle(fontSize: 18.0)),
                                      ],
                                    ),
                                    Row(
                                        mainAxisAlignment:  MainAxisAlignment.end,
                                        children: <Widget>[
                                          Text(snapshot.data[index].data ?? "", style: TextStyle(fontSize: 18.0)),
                                          Text("    ", style: TextStyle(fontSize: 18.0)),
                                          Text(snapshot.data[index].horario ?? "",style: TextStyle(fontSize: 18.0))
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
    return consultas;
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
