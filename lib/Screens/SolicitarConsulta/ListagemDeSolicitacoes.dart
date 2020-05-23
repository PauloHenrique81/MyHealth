import 'package:flutter/material.dart';
import 'package:myhealth/Persistencia/P_SolicitarConsulta.dart';
import 'package:myhealth/Service/ScreeanArguments.dart';
import 'package:myhealth/class/SolicitarConsulta.dart';
import 'package:myhealth/class/user.dart';
import '../Loading.dart';

class ListagemDeSolicitacoes extends StatefulWidget {
  final User user;
  ListagemDeSolicitacoes({this.user});

  @override
  _ListagemDeSolicitacoesState createState() => _ListagemDeSolicitacoesState();
}

class _ListagemDeSolicitacoesState extends State<ListagemDeSolicitacoes> {
  P_SolicitarConsulta bd = new P_SolicitarConsulta();
  List<SolicitarConsulta> solicitacoes = new List<SolicitarConsulta>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Solicitações de Consulta"),
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
            _novaSolicitacao(widget.user);
          },
          child: Icon(Icons.add),
          backgroundColor: Colors.deepPurple,
        ),
        body: FutureBuilder(
            future: buscaSolicitacoes(widget.user.uid),
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
                                                  "Assets/solicitarConsulta.png"),
                                              fit: BoxFit.cover),
                                        ),
                                      ),
                                      Text(
                                          snapshot.data[index]
                                                  .nomeDoProfissional ??
                                              "",
                                          style: TextStyle(
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      Text(snapshot.data[index].data ?? "",
                                          style: TextStyle(
                                            fontSize: 16.0,
                                          )),
                                      Text(snapshot.data[index].horario ?? "",
                                          style: TextStyle(
                                            fontSize: 16.0,
                                          )),
                                    ],
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    height: 10.0,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.rectangle,
                                        color: _colorStatus(snapshot.data[index].status),
                                      ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        onTap: () {
                          _mostrarDetalhesDaSolicitacao(
                              solicitacao: solicitacoes[index],
                              user: widget.user);
                        },
                      );
                    });
              }
            }));
  }

  Future buscaSolicitacoes(String idUser) async {
    solicitacoes = await bd.listaDeSolicitacoesPaciente(idUser);
    return solicitacoes;
  }

  MaterialColor _colorStatus(String status){
    switch (status) {
      case "analise" : {
          return Colors.yellow;
      }
      break;
      case "aprovado" : {
          return Colors.green;
      }
      break;
      case "reprovado" : {
          return Colors.red;
      }
      break;
      default : return Colors.white;
    }
  }

  void _mostrarDetalhesDaSolicitacao(
      {SolicitarConsulta solicitacao, User user}) {
    ScreeanArguments screeanArguments =
        new ScreeanArguments(user: user, solicitarConsulta: solicitacao);
    Navigator.of(context)
        .pushNamed('EdicaoDeSolicitacao', arguments: screeanArguments);
  }

  void _novaSolicitacao(User user) {
    ScreeanArguments screeanArguments =
        new ScreeanArguments(user: user, booleam: true);
    Navigator.of(context)
        .pushNamed('HabilitarProfissionalSC', arguments: screeanArguments);
  }
}
