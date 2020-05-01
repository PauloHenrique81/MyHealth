import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myhealth/class/Consulta.dart';

class P_ConsultasAgendadas {
  final String uid;
  P_ConsultasAgendadas({this.uid});

  final CollectionReference consultaCollection =
      Firestore.instance.collection("consultas");


  List<Consulta> consultaListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return Consulta(
        idUser: doc.data['idUser'] ?? '',
        nomeDoMedico: doc.data['nomeDoMedico'] ?? '',
        especialidade: doc.data['especialidade'] ?? '',
        codigoDoProfissional : doc.data['codigoDoProfissional'] ?? '',
        idConsulta: doc.data['idConsulta'] ?? '',
        data: doc.data['data'] ?? '',
        horario: doc.data['horario'] ?? '',
        local: doc.data['local'] ?? '',
        diagnostico: doc.data['diagnostico'] ?? '',
        exames: doc.data['exames'] ?? '',
        medicamentos: doc.data['medicamentos'] ?? '',
        formaDePagamento: doc.data['formaDePagamento'] ?? '',
        valor: doc.data['valor'] ?? '',
        status: doc.data['status'] ?? '',
      );
    }).toList();
  }

  Future listaDeConsultas(String codigoDoProfissional) async {
    Consulta consulta = new Consulta();
    List<Consulta> consultas = new List<Consulta>();

    var snapshots = await consultaCollection
        .where("codigoDoProfissional", isEqualTo: codigoDoProfissional)
        .getDocuments();
    snapshots.documents.forEach((d) {
      consulta = new Consulta(
          idUser: d.data['idUser'],
          idConsulta: d.documentID,
          data: d.data['data'],
          horario: d.data['horario'],
          local: d.data['local']);
      consultas.add(consulta);
    });

    return consultas;
  }

  Stream<List<Consulta>> get allConsultas {
    return consultaCollection.snapshots().map(consultaListFromSnapshot);
  }
}
