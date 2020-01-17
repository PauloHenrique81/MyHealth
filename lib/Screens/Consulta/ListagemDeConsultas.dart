import 'package:flutter/material.dart';

class ListagemDeConsultas extends StatefulWidget {
  @override
  _ListagemDeConsultasState createState() => _ListagemDeConsultasState();
}

class _ListagemDeConsultasState extends State<ListagemDeConsultas> {
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
}
