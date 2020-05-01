import 'package:flutter/material.dart';
import 'package:myhealth/Persistencia/P_Paciente.dart';
import 'package:myhealth/Persistencia/P_Profissional.dart';
import 'package:myhealth/Screens/Loading.dart';
import 'package:myhealth/Service/Util.dart';
import 'package:myhealth/UserProfissional/Model/PacienteConsulta.dart';
import 'package:myhealth/UserProfissional/Persistencia/P_ConsultasAgendadas.dart';
import 'package:myhealth/class/Consulta.dart';
import 'package:myhealth/class/Paciente.dart';
import 'package:myhealth/class/Profissional.dart';
import 'package:myhealth/class/user.dart';

class ListagemDeConsultasP extends StatefulWidget {
  final User user;
  ListagemDeConsultasP({this.user});

  @override
  _ListagemDeConsultasPState createState() => _ListagemDeConsultasPState();
}

class _ListagemDeConsultasPState extends State<ListagemDeConsultasP> {

  P_Paciente connectionPaciente = new P_Paciente();
  P_ConsultasAgendadas connectionConsultas = new P_ConsultasAgendadas();
  P_Profissional connectionProfissional = new P_Profissional();

  


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Consultas"),
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
                            child: Container(
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                          snapshot.data[index].nome ??
                                              "",
                                          style: TextStyle(
                                              fontSize: 22.0,
                                              fontWeight: FontWeight.bold)),
                                
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                          snapshot.data[index].cpf ??
                                              "",
                                          style: TextStyle(fontSize: 18.0)), 
                                      Text(snapshot.data[index].local ?? "",
                                          style: TextStyle(fontSize: 18.0)),
                                                                               ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      Text(snapshot.data[index].data ?? "",
                                          style: TextStyle(fontSize: 18.0)),
                                      Text("    ",
                                          style: TextStyle(fontSize: 18.0)),
                                      Text(snapshot.data[index].hora ?? "",
                                          style: TextStyle(fontSize: 18.0)),
                                      Container(
                                        alignment: Alignment.center,
                                        width: 10.0,
                                        height: 10.0,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.rectangle,
                                            color: Util.verificaData(snapshot
                                                        .data[index].data) <=
                                                    0
                                                ? Colors.green
                                                : Colors.red),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        onTap: () {
                        },
                      );
                    });
              }
            }));
  }

  Future<List<PacienteConsulta>> buscaConsultas() async {
    Profissional profissional = await connectionProfissional.getProfissionalUser(widget.user.uid);
    if(profissional.identificacao == ''){
      return null;
    }else{
      List<Consulta> consultas = await  connectionConsultas.listaDeConsultas(profissional.identificacao);
      PacienteConsulta consultaP;
      List<PacienteConsulta> consultasA = new List<PacienteConsulta>();
      Paciente paciente;

      for (var item in consultas) {
        
        paciente = await buscaPacientes(item.idUser);

        consultaP =  PacienteConsulta(
          nome: paciente.nome,
          cpf: paciente.cpf,
          data: item.data,
          hora: item.horario,
          local: item.local 
        );

        consultasA.add(consultaP);
      }

      if(consultasA.length == 0){
        return null;
      }else{
        return _ordenarLista(consultasA, consultasA.length);
      }
      
    }

  }


  Future<Paciente>  buscaPacientes(String idUser)async {

      var paciente = connectionPaciente.getPaciente(idUser);

      return paciente;

  }

  List<PacienteConsulta> _ordenarLista(List<PacienteConsulta> lista, int n) {
  int i, j;
  PacienteConsulta key;

  for (i = 1; i < n; i++) {
    key = lista[i];
    j = i - 1;
    while (j >= 0 && lista[j].convertData().compareTo(key.convertData()) < 0) {
      lista[j + 1] = lista[j];
      j = j - 1;
    }
    lista[j + 1] = key;
  }

  return lista;
}

}
