import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myhealth/class/Consulta.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  final CollectionReference consultaCollection =
      Firestore.instance.collection("consultas");

  // RETORNA UMA LISTA DE CONSULTAS
  List<Consulta> _consultaListFromSnapshot(QuerySnapshot snapshot) {
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


  void _cadastraConsulta(String idUser, String nomeDoMedico, String data, String horario, String local, {String especialidade} ){
    consultaCollection.document().setData((){
        'idUser': idUser ,
        'nomeDoMedico'
        'especialidade'
        'data'
        'horario'
        'local'
        'diagnostico'
        'exames'
        'medicamentos'
        'formaDePagamento'
        'valor'
        'status'
    });
  }



  Stream<List<Consulta>> get consultas {
    return consultaCollection.snapshots().map(_consultaListFromSnapshot);
  }
}
