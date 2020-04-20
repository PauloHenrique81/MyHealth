import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myhealth/class/Consulta.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  final CollectionReference consultaCollection =
      Firestore.instance.collection("consultas");

  // RETORNA UMA LISTA DE CONSULTAS
  List<Consulta> consultaListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return Consulta(
        idUser: doc.data['idUser'] ?? '',
        nomeDoMedico: doc.data['nomeDoMedico'] ?? '',
        especialidade: doc.data['especialidade'] ?? '',
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

  Future listaDeConsultas(String idUser) async {
    Consulta consulta = new Consulta();
    List<Consulta> consultas = new List<Consulta>();

    var snapshots = await consultaCollection
        .where("idUser", isEqualTo: idUser)
        .getDocuments();
    snapshots.documents.forEach((d) {
      consulta = new Consulta(
          idUser: d.data['idUser'],
          idConsulta: d.documentID,
          nomeDoMedico: d.data['nomeDoMedico'],
          especialidade: d.data['especialidade'] ?? '',
          data: d.data['data'],
          horario: d.data['horario'],
          local: d.data['local'],
          diagnostico: d.data['diagnostico'] ?? '',
          exames: d.data['exames'] ?? '',
          medicamentos: d.data['medicamentos'] ?? '',
          formaDePagamento: d.data['formaDePagamento'] ?? '',
          valor: d.data['valor'] ?? '',
          status: d.data['status'] ?? '');
      consultas.add(consulta);
    });

    return consultas;
  }

  void excluirConsulta(String idConsulta, String idUser) async {
    try {
      var consultas = await consultaCollection
          .where("idUser", isEqualTo: idUser)
          .where("idConsulta", isEqualTo: idConsulta)
          .getDocuments();

      consultas.documents.first.reference.delete();
    } catch (e) {
      print(e.toString());
    }
  }

  Future cadastraConsulta(String idUser, String nomeDoMedico, String data,
      String horario, String local,
      {String especialidade,
      String diagnostico,
      String exames,
      String medicamentos,
      String formaDePagamento,
      double valor,
      String status}) async {
    try {
      var idConsulta = await consultaCollection.add({
        'idUser': idUser,
        'nomeDoMedico': nomeDoMedico,
        'especialidade': especialidade ?? '',
        'data': data,
        'horario': horario,
        'local': local,
        'diagnostico': diagnostico ?? '',
        'exames': exames ?? '',
        'medicamentos': medicamentos ?? '',
        'formaDePagamento': formaDePagamento ?? '',
        'valor': valor ?? '',
        'status': status ?? ''
      });

      consultaCollection
          .document(idConsulta.documentID)
          .updateData({'idConsulta': idConsulta.documentID});
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future atualizarConsulta(String idUser, String idConsulta,
      String nomeDoMedico, String data, String horario, String local,
      {String especialidade,
      String diagnostico,
      String exames,
      String medicamentos,
      String formaDePagamento,
      String valor,
      String status}) {
    try {
      consultaCollection.document(idConsulta).updateData({
        'idUser': idUser,
        'nomeDoMedico': nomeDoMedico,
        'especialidade': especialidade ?? '',
        'data': data,
        'horario': horario,
        'local': local,
        'diagnostico': diagnostico ?? '',
        'exames': exames ?? '',
        'medicamentos': medicamentos ?? '',
        'formaDePagamento': formaDePagamento ?? '',
        'valor': valor ?? '',
        'status': status ?? ''
      });
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Stream<List<Consulta>> get allConsultas {
    return consultaCollection.snapshots().map(consultaListFromSnapshot);
  }
}
