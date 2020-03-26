import 'package:flutter/material.dart';
import 'package:myhealth/Helper/Vacina_Help.dart';
import 'package:myhealth/Service/ScreeanArguments.dart';
import 'package:myhealth/class/Vacina_x_User.dart';
import 'package:myhealth/class/user.dart';

class ListagemVacinasCrianca extends StatefulWidget {
  final User user;
  Vacina vacinas = Vacina();
  List<VacinaUser> listVacinaUser;
  ListagemVacinasCrianca({this.user, this.vacinas, this.listVacinaUser});

  @override
  _ListagemVacinasCriancaState createState() => _ListagemVacinasCriancaState();
}

class _ListagemVacinasCriancaState extends State<ListagemVacinasCrianca> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Vacinas para Crianças"),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pushReplacementNamed(
                    context, 'ListagemTiposDeVacinas',
                    arguments: widget.user);
              },
            );
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: ListView.builder(
          padding: EdgeInsets.all(10.0),
          itemCount: widget.vacinas.listaVacinas.length,
          itemBuilder: (context, index) {
            return _modelCard(context, index);
          }),
    );
  }

  Widget _modelCard(BuildContext context, int index) {
    return GestureDetector(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Row(
            children: <Widget>[
              Container(
                width: 40.0,
                height: 40.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: AssetImage("Assets/vacina.jpg"),
                      fit: BoxFit.cover),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(widget.vacinas.listaVacinas[index].tipo ?? "",
                        style: TextStyle(
                            fontSize: 15.0, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left),
                    Container(
                      alignment: Alignment.center,
                      width: 20.0,
                      height: 20.0,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: widget.vacinas.listaVacinas[index].status
                              ? Colors.green
                              : Colors.red),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      onTap: () {
        //_showOptions(context, index);
      },
    );
  }

  // void _mostrarDetalhesDo({Profissional profissional, User user}) {
  //   ScreeanArguments screeanArguments =
  //       new ScreeanArguments(user: user, profissional: profissional);
  //   Navigator.of(context)
  //       .pushNamed('EdicaoDeProfissional', arguments: screeanArguments);
  // }
}
