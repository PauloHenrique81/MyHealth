import 'package:flutter/material.dart';
import 'package:myhealth/Screens/Loading.dart';
import 'package:myhealth/class/Consulta.dart';
import 'package:myhealth/class/database.dart';
import 'package:provider/provider.dart';

class ListagemDeConsultas extends StatefulWidget {
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
          onPressed: () {},
          child: Icon(Icons.add),
          backgroundColor: Colors.deepPurple,
        ),
        body: FutureBuilder(
            future: buscaConsultas(),
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
                            child: Row(
                              children: <Widget>[
                                Column(
                                  children: <Widget>[
                                    Text(
                                        snapshot.data[index].nomeDoMedico ?? "",
                                        style: TextStyle(
                                            fontSize: 22.0,
                                            fontWeight: FontWeight.bold)),
                                    Text(
                                        snapshot.data[index].especialidade ??
                                            "",
                                        style: TextStyle(fontSize: 18.0)),
                                    Text(snapshot.data[index].local ?? "",
                                        style: TextStyle(fontSize: 18.0)),
                                    Text(snapshot.data[index].data ?? "",
                                        style: TextStyle(fontSize: 18.0)),
                                    Text(snapshot.data[index].horario ?? "",
                                        style: TextStyle(fontSize: 18.0))
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        // onTap: () {
                        //   _mostrarDetalhesDaConsulta(consulta: consulta);
                        // },
                      );
                    });
              }
            }));
  }

  Future buscaConsultas() async {
    consultas = await bd.listaDeConsultas();
    return consultas;
  }

  void _mostrarDetalhesDaConsulta({Consulta consulta}) {
    Navigator.of(context).pushNamed('EdicaoDeConsulta', arguments: consulta);
  }
}

// class ListConsultas extends StatefulWidget {
//   final consultas;
//   ListConsultas({this.consultas});
//   @override
//   _ListConsultasState createState() => _ListConsultasState();
// }

// class _ListConsultasState extends State<ListConsultas> {
//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//       padding: EdgeInsets.all(10.0),
//       itemCount: widget.consultas.length,
//       itemBuilder: (context, index) {
//         return CardConsulta(
//           consulta: widget.consultas[index],
//         );
//       },
//     );
//   }
// }

// class CardConsulta extends StatelessWidget {
//   final Consulta consulta;
//   CardConsulta({this.consulta});

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       child: Card(
//         child: Padding(
//           padding: EdgeInsets.all(10.0),
//           child: Row(
//             children: <Widget>[
//               Column(
//                 children: <Widget>[
//                   Text(consulta.nomeDoMedico ?? "",
//                       style: TextStyle(
//                           fontSize: 22.0, fontWeight: FontWeight.bold)),
//                   Text(consulta.especialidade ?? "",
//                       style: TextStyle(fontSize: 18.0)),
//                   Text(consulta.local ?? "", style: TextStyle(fontSize: 18.0)),
//                   Text(consulta.data ?? "", style: TextStyle(fontSize: 18.0)),
//                   Text(consulta.horario ?? "", style: TextStyle(fontSize: 18.0))
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//       // onTap: () {
//       //   _mostrarDetalhesDaConsulta(consulta: consulta);
//       // },
//     );
//   }
// }
