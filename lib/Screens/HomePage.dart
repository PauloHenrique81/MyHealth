import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:myhealth/Persistencia/P_AtividadesDoDia.dart';
import 'package:myhealth/Service/auth.dart';
import 'package:myhealth/class/AtividadeDoDia.dart';
import 'package:myhealth/class/Cirurgia.dart';
import 'package:myhealth/class/Consulta.dart';
import 'package:myhealth/class/DoarSangue.dart';
import 'package:myhealth/class/Exame.dart';
import 'package:myhealth/class/user.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:myhealth/route_genarator.dart';

import 'Loading.dart';

class HomePage extends StatelessWidget {
  User user;
  HomePage({this.user});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: new ThemeData(
          primarySwatch: Colors.deepPurple,
          primaryColor: defaultTargetPlatform == TargetPlatform.iOS
              ? Colors.grey[50]
              : null),
      home: new _HomePage(
        user: user,
      ),
      onGenerateRoute: RouteGenarator.genareteRoute,
      debugShowCheckedModeBanner: false,
    );
  }
}

class _HomePage extends StatelessWidget {
  final User user;

  _HomePage({this.user});
  final AuthService _auth = AuthService();

  P_AtividadeDoDia connectionDB = new P_AtividadeDoDia();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _naoDeixaUsuarioVoltar,
            child: Scaffold(
                appBar: new AppBar(
                  title: new Text("Minha Saúde"),
                  actions: <Widget>[
                    IconButton(
                      icon: Icon(FontAwesomeIcons.signOutAlt, size: 20.0),
                      color: Colors.white,
                      onPressed: () async {
                        await _auth.signOut();
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            'PreLogin', (Route<dynamic> route) => false);
                      },
                    ),
                  ],
                  elevation:
                      defaultTargetPlatform == TargetPlatform.android ? 5.0 : 0.0,
                ),
                drawer: new Drawer(
                  child: new ListView(
                    children: <Widget>[
                      new UserAccountsDrawerHeader(
                        accountName: new Text(user.userName ?? "Paciente"),
                        accountEmail: new Text(user.userEmail),
                        currentAccountPicture: new CircleAvatar(
                          backgroundImage: NetworkImage(user.photoUrl ?? ""),
                        ),
                      ),
                      new ListTile(
                        title: new Text("Perfil"),
                        trailing: new Icon(Icons.person_outline),
                        onTap: () =>
                            Navigator.pushNamed(context, 'Perfil', arguments: user),
                      ),
                      new ListTile(
                        title: new Text("Atestados"),
                        trailing: new Icon(Icons.receipt),
                        onTap: () => Navigator.pushNamed(
                            context, 'ListagemDeAtestados',
                            arguments: user),
                      ),
                      new ListTile(
                        title: new Text("Cirurgias"),
                        trailing: new Icon(Icons.receipt),
                        onTap: () => Navigator.pushNamed(
                            context, 'ListagemDeCirurgias',
                            arguments: user),
                      ),
                      new ListTile(
                        title: new Text("Consultas"),
                        trailing: new Icon(Icons.receipt),
                        onTap: () => Navigator.pushNamed(
                            context, 'ListagemDeConsultas',
                            arguments: user),
                      ),
                      new ListTile(
                        title: new Text("Doações de Sangue"),
                        trailing: new Icon(Icons.receipt),
                        onTap: () => Navigator.pushNamed(context, 'ListagemDeDoacoes',
                            arguments: user),
                      ),
                      new ListTile(
                        title: new Text("Exames"),
                        trailing: new Icon(Icons.receipt),
                        onTap: () => Navigator.pushNamed(context, 'ListagemDeExames',
                            arguments: user),
                      ),
                      new ListTile(
                        title: new Text("Habilitar Profissional"),
                        trailing: new Icon(Icons.receipt),
                        onTap: () => Navigator.pushNamed(
                            context, 'HabilitarProfissional',
                            arguments: user),
                      ),
                      new ListTile(
                        title: new Text("Profissionais"),
                        trailing: new Icon(Icons.receipt),
                        onTap: () => Navigator.pushNamed(
                            context, 'ListagemDeProfissionais',
                            arguments: user),
                      ),
                      new ListTile(
                        title: new Text("Receitas"),
                        trailing: new Icon(Icons.receipt),
                        onTap: () => Navigator.pushNamed(
                            context, 'ListagemDeReceitas',
                            arguments: user),
                      ),
                      new ListTile(
                        title: new Text("Solicitar Consulta"),
                        trailing: new Icon(Icons.receipt),
                        onTap: () => Navigator.pushNamed(
                            context, 'ListagemDeSolicitacoes',
                            arguments: user),
                      ),
                      new ListTile(
                        title: new Text("Vacinas"),
                        trailing: new Icon(Icons.receipt),
                        onTap: () => Navigator.pushNamed(
                            context, 'ListagemTiposDeVacinas',
                            arguments: user),
                      ),
                      new ListTile(
                        title: new Text("Fechar"),
                        trailing: new Icon(Icons.close),
                        onTap: () => Navigator.of(context).pop(),
                      )
                    ],
                  ),
                ),
                body: FutureBuilder(
                    future: buscaAtividades(),
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
                                                          "Assets/iconeAtividade.png"),
                                                      fit: BoxFit.cover),
                                                ),
                                              ),
                                              Text(snapshot.data[index].modulo ?? "",
                                                  style: TextStyle(
                                                      fontSize: 20.0,
                                                      fontWeight: FontWeight.bold)),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: <Widget>[
                                              Text(
                                                  snapshot.data[index].data +
                                                          "    " ??
                                                      "",
                                                  style: TextStyle(fontSize: 14.0)),
                                              Text(snapshot.data[index].hora ?? "",
                                                  style: TextStyle(
                                                    fontSize: 14.0,
                                                  )),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            });
                      }
                    })),
          );
        }
      
        Future buscaAtividades() async {
          Consulta consulta = await connectionDB.getConsulta(user.uid);
          Cirurgia cirurgia = await connectionDB.getCirurgia(user.uid);
          Exame exame = await connectionDB.getExame(user.uid);
          DoarSangue doacao = await connectionDB.getDoacao(user.uid);
      
          List<AtividadeDoDia> atividades = new List<AtividadeDoDia>();
          AtividadeDoDia atividade;
      
          if (consulta != null) {
            atividade = new AtividadeDoDia(
                modulo: "Consulta",
                idItem: consulta.idConsulta,
                data: consulta.data,
                hora: consulta.horario,
                local: consulta.local);
      
            atividades.add(atividade);
          }
          if (cirurgia != null) {
            atividade = new AtividadeDoDia(
                modulo: "Cirurgia",
                idItem: cirurgia.idCirurgia,
                data: cirurgia.data,
                hora: cirurgia.horario,
                local: cirurgia.local);
      
            atividades.add(atividade);
          }
          if (exame != null) {
            atividade = new AtividadeDoDia(
                modulo: "Exame",
                idItem: exame.idExame,
                data: exame.data,
                hora: exame.horario,
                local: exame.local);
      
            atividades.add(atividade);
          }
          if (doacao != null) {
            atividade = new AtividadeDoDia(
                modulo: "Doação de Sangue",
                idItem: doacao.idDoacao,
                data: doacao.data,
                hora: doacao.horario,
                local: doacao.local);
      
            atividades.add(atividade);
          }
      
          return atividades;
        }
      
        Future<bool> _naoDeixaUsuarioVoltar() async {
         return false;
        }
}
