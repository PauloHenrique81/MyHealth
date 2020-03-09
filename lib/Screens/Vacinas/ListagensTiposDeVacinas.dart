import 'package:flutter/material.dart';
import 'package:myhealth/class/user.dart';


class ListagemTiposDeVacinas extends StatefulWidget {
  final User user;
  ListagemTiposDeVacinas({this.user});
  
  @override
  _ListagemTiposDeVacinasState createState() => _ListagemTiposDeVacinasState();
}

class _ListagemTiposDeVacinasState extends State<ListagemTiposDeVacinas> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
         appBar: AppBar(
          title: Text("Vacinas"),
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
        body: ListView.builder(padding: EdgeInsets.all(10.0),
          itemCount: contacts.length,
          itemBuilder: (context, index) {
            return _contactCard(context, index);
          }),)
    );
  }
}