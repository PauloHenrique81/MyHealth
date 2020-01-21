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
        data: doc.data['data'] ?? '',
        horario: doc.data['horario'] ?? '',
        local: doc.data['local'] ?? '',
        diagnostico: doc.data['diagnostico'] ?? '',
        exames: doc.data['exames'] ?? '',
        medicamentos: doc.data['medicamentos'] ?? '',
        formaDePagamento: doc.data['formaDePagamento'] ?? '',
        valor: doc.data['valor'] ?? 0,
        status: doc.data['status'] ?? 0,
      );
    }).toList();
  }

  Future listaDeConsultas() async {
    Consulta consulta = new Consulta();
    List<Consulta> consultas = new List<Consulta>();

    var snapshots = await consultaCollection.getDocuments();
    snapshots.documents.forEach((d) {
      consulta = new Consulta(
          idUser: d.data['idUser'],
          nomeDoMedico: d.data['nomeDoMedico'],
          especialidade: d.data['especialidade'] ?? '',
          data: d.data['data'],
          horario: d.data['horario'],
          local: d.data['local'],
          diagnostico: d.data['diagnostico'] ?? '',
          exames: d.data['exames'] ?? '',
          medicamentos: d.data['medicamentos'] ?? '',
          formaDePagamento: d.data['formaDePagamento'] ?? '',
          //valor: d.data['valor'] ?? 0.0,
          status: d.data['status'] ?? '');
      consultas.add(consulta);
    });

    return consultas;
  }

  Future cadastraConsulta(String idUser, String nomeDoMedico, String data,
      String horario, String local,
      {String especialidade,
      String diagnostico,
      String exames,
      String medicamentos,
      String formaDePagamento,
      double valor,
      String status}) {
    try {
      consultaCollection.document().setData({
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
        'valor': valor ?? (0).toDouble(),
        'status': status ?? ''
      });
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Stream<List<Consulta>> get allConsultas {
    print(consultaCollection.snapshots().map(consultaListFromSnapshot));
    return consultaCollection.snapshots().map(consultaListFromSnapshot);
  }
}
