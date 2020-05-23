import 'package:flutter/material.dart';
import 'package:myhealth/Persistencia/P_HabilitarProfissional.dart';
import 'package:myhealth/Persistencia/P_Paciente.dart';
import 'package:myhealth/Screens/Loading.dart';
import 'package:myhealth/class/Paciente.dart';
import 'package:myhealth/class/user.dart';

class ListagemDePacientes extends StatefulWidget {
  final User user;
  ListagemDePacientes({this.user});

  @override
  _ListagemDePacientesState createState() => _ListagemDePacientesState();
}

class _ListagemDePacientesState extends State<ListagemDePacientes> {
  P_Paciente connectionPaciente = new P_Paciente();
  P_HabilitarProfissional connectionPH = new P_HabilitarProfissional();

  List<Paciente> pacientes = new List<Paciente>();
  List<String> pacientesHabilitado = new List<String>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Pacientes"),
          backgroundColor: Colors.blue,
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.refresh,
                color: Colors.white,
              ),
              onPressed: () {
                setState(() {
                  pacientes.clear();
                });
              },
            )
          ],
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pushReplacementNamed(
                      context, 'HomePageProfissional',
                      arguments: widget.user);
                },
              );
            },
          ),
        ),
        backgroundColor: Colors.white,
        body: FutureBuilder(
            future: buscaPacientes(widget.user.uid),
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
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Text(snapshot.data[index].nome ?? "",
                                          style: TextStyle(
                                              fontSize: 22.0,
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 10.0),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                          "CPF : " + snapshot.data[index].cpf ??
                                              "",
                                          style: TextStyle(fontSize: 18.0)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        onTap: () {
                          _mostrarDetalhes(uid: widget.user.uid);
                        },
                      );
                    });
              }
            }));
  }

  void _mostrarDetalhes({String uid}) {
    Navigator.of(context)
        .pushNamed('InformacoesDoPaciente', arguments: uid);
  }

  Future buscaPacientes(String idUser) async {
    pacientes.clear();
    var pacientesAux = await connectionPaciente.listaDePacientes();
    pacientesHabilitado =
        await connectionPH.listaDePacientesHabilitados(widget.user.uid);

    if (pacientesAux != null && pacientesHabilitado != null) {
      for (int i = 0; i < pacientesAux.length; i++) {
        for (int j = 0; j < pacientesHabilitado.length; j++) {
          if (pacientesAux[i].uid == pacientesHabilitado[j]) {
            pacientes.add(pacientesAux[i]);
          }
        }
      }
    } else {
      pacientesAux = null;
    }
    return pacientes;
  }
}
