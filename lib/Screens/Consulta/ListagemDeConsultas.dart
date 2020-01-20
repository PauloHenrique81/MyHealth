import 'package:flutter/material.dart';
import 'package:myhealth/class/Consulta.dart';

class ListagemDeConsultas extends StatefulWidget {
  @override
  _ListagemDeConsultasState createState() => _ListagemDeConsultasState();
}

class _ListagemDeConsultasState extends State<ListagemDeConsultas> {
  List<Consulta> consultas = List();
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
    );
  }

  Widget _consultaCard(BuildContext context, int index) {
    return GestureDetector(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Row(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Text(consultas[index].nomeDoMedico ?? "",
                      style: TextStyle(
                          fontSize: 22.0, fontWeight: FontWeight.bold)),
                  Text(consultas[index].especialidade ?? "",
                      style: TextStyle(fontSize: 18.0)),
                  Text(consultas[index].local ?? "",
                      style: TextStyle(fontSize: 18.0)),
                  Text(consultas[index].data ?? "",
                      style: TextStyle(fontSize: 18.0)),
                  Text(consultas[index].horario ?? "",
                      style: TextStyle(fontSize: 18.0))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
