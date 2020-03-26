import 'package:flutter/material.dart';
import 'package:myhealth/Helper/Vacina_Help.dart';
import 'package:myhealth/Persistencia/P_Vacina_x_User.dart';
import 'package:myhealth/Service/ScreeanArguments.dart';
import 'package:myhealth/class/Vacina_x_User.dart';
import 'package:myhealth/class/user.dart';

class ListagemTiposDeVacinas extends StatefulWidget {
  final User user;
  ListagemTiposDeVacinas({this.user});

  @override
  _ListagemTiposDeVacinasState createState() => _ListagemTiposDeVacinasState();
}

class _ListagemTiposDeVacinasState extends State<ListagemTiposDeVacinas> {
  List<VacinaUser> listVacinaUser;

  P_Vacina_x_User bd = new P_Vacina_x_User();

  @override
  void initState() {
    super.initState();
    buscaVacinaUser();
  }

  void buscaVacinaUser() async {
    listVacinaUser = await bd.listaDeVacinaUser(widget.user.uid);
  }

  Vacina_Help vacinas = Vacina_Help();
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
      body: ListView.builder(
          padding: EdgeInsets.all(10.0),
          itemCount: 5,
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
                width: 80.0,
                height: 80.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: AssetImage(vacinas.vacinas[index].img),
                      fit: BoxFit.cover),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      vacinas.vacinas[index].nome ?? "",
                      style: TextStyle(
                          fontSize: 22.0, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      vacinas.vacinas[index].periodo ?? "",
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      onTap: () {
        if (vacinas.vacinas[index].nome == "Criança") {
          _mostrarDetalhesCrianca(vacina: vacinas.crianca, user: widget.user);
        } else {
          if (vacinas.vacinas[index].nome == "Adolescente") {
            _mostrarDetalheAdolescente(
                vacina: vacinas.adolescente, user: widget.user);
          } else {
            if (vacinas.vacinas[index].nome == "Adulto") {
              _mostrarDetalheAdulto(vacina: vacinas.adulto, user: widget.user);
            } else {
              if (vacinas.vacinas[index].nome == "Idoso") {
                _mostrarDetalheIdoso(vacina: vacinas.idoso, user: widget.user);
              } else {
                if (vacinas.vacinas[index].nome == "Gestante") {
                  _mostrarDetalheGestante(
                      vacina: vacinas.gestante, user: widget.user);
                }
              }
            }
          }
        }
      },
    );
  }

  void _mostrarDetalhesCrianca({Vacina vacina, User user}) {
    ScreeanArguments screeanArguments = new ScreeanArguments(
        user: user, vacina: vacina, listVacinaUser: listVacinaUser);
    Navigator.of(context)
        .pushNamed('ListagemVacinasCrianca', arguments: screeanArguments);
  }

  void _mostrarDetalheAdolescente({Vacina vacina, User user}) {
    ScreeanArguments screeanArguments = new ScreeanArguments(
        user: user, vacina: vacina, listVacinaUser: listVacinaUser);
    Navigator.of(context)
        .pushNamed('ListagemVacinasAdolescente', arguments: screeanArguments);
  }

  void _mostrarDetalheAdulto({Vacina vacina, User user}) {
    ScreeanArguments screeanArguments = new ScreeanArguments(
        user: user, vacina: vacina, listVacinaUser: listVacinaUser);
    Navigator.of(context)
        .pushNamed('ListagemVacinasAdulto', arguments: screeanArguments);
  }

  void _mostrarDetalheIdoso({Vacina vacina, User user}) {
    ScreeanArguments screeanArguments = new ScreeanArguments(
        user: user, vacina: vacina, listVacinaUser: listVacinaUser);
    Navigator.of(context)
        .pushNamed('ListagemVacinasIdoso', arguments: screeanArguments);
  }

  void _mostrarDetalheGestante({Vacina vacina, User user}) {
    ScreeanArguments screeanArguments = new ScreeanArguments(
        user: user, vacina: vacina, listVacinaUser: listVacinaUser);
    Navigator.of(context)
        .pushNamed('ListagemVacinasGestante', arguments: screeanArguments);
  }
}
