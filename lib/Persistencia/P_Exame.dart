import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myhealth/class/Exame.dart';

class P_Exame {
  final CollectionReference exameCollection =
      Firestore.instance.collection("exames");

  List<Exame> exameListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return Exame(
        idUser: doc.data['idUser'] ?? '',
        nomeDoMedico: doc.data['nomeDoMedico'] ?? '',
        tipoExame: doc.data['tipoExame'] ?? '',
        data: doc.data['data'] ?? '',
        horario: doc.data['horario'] ?? '',
        local: doc.data['local'] ?? '',
        dataResultado: doc.data['dataResultado'] ?? '',
        formaDePagamento: doc.data['formaDePagamento'] ?? '',
        valor: doc.data['valor'] ?? '',
        status: doc.data['status'] ?? '',
      );
    }).toList();
  }

  Future listaDeExames(String idUser) async {
    Exame exame = new Exame();
    List<Exame> exames = new List<Exame>();

    var snapshots =
        await exameCollection.where("idUser", isEqualTo: idUser).getDocuments();
    snapshots.documents.forEach((d) {
      exame = new Exame(
          idUser: d.data['idUser'],
          idExame: d.documentID,
          nomeDoMedico: d.data['nomeDoMedico'],
          tipoExame: d.data['tipoExame'] ?? '',
          data: d.data['data'],
          horario: d.data['horario'],
          local: d.data['local'],
          dataResultado: d.data['dataResultado'] ?? '',
          formaDePagamento: d.data['formaDePagamento'] ?? '',
          valor: d.data['valor'] ?? '',
          status: d.data['status'] ?? '');
      exames.add(exame);
    });

    return exames;
  }

  Future cadastraExame(String idUser, String nomeDoMedico, String tipoExame,
      String data, String horario, String local,
      {String dataResultado,
      String formaDePagamento,
      double status,
      String valor}) async {
    try {
      var idExame = await exameCollection.add({
        'idUser': idUser,
        'nomeDoMedico': nomeDoMedico,
        'tipoExame': tipoExame ?? '',
        'data': data,
        'horario': horario,
        'local': local,
        'dataResultado': dataResultado ?? '',
        'formaDePagamento': formaDePagamento ?? '',
        'valor': valor ?? '',
        'status': status ?? ''
      });

      exameCollection
          .document(idExame.documentID)
          .updateData({'idExame': idExame.documentID});
      return idExame.documentID;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  void excluirExame(String idExame, String idUser) async {
    try {
      var exames = await exameCollection
          .where("idUser", isEqualTo: idUser)
          .where("idExame", isEqualTo: idExame)
          .getDocuments();

      exames.documents.first.reference.delete();
    } catch (e) {
      print(e.toString());
    }
  }

  Future atualizarExame(String idUser, String idExame, String nomeDoMedico,
      String tipoExame, String data, String horario, String local,
      {String dataResultado,
      String formaDePagamento,
      double status,
      String valor}) {
    try {
      exameCollection.document(idExame).updateData({
        'idUser': idUser,
        'nomeDoMedico': nomeDoMedico,
        'tipoDeCirurgia': tipoExame ?? '',
        'data': data,
        'horario': horario,
        'local': local,
        'recomendacaoMedicaPosCirurgico': dataResultado ?? '',
        'formaDePagamento': formaDePagamento ?? '',
        'valor': valor ?? '',
        'status': status ?? ''
      });
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Stream<List<Exame>> get allCirurgias {
    return exameCollection.snapshots().map(exameListFromSnapshot);
  }
}
