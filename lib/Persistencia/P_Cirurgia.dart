import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myhealth/class/Cirurgia.dart';

class P_Cirurgia {
  final String uid;
  P_Cirurgia({this.uid});

  final CollectionReference cirurgiaCollection =
      Firestore.instance.collection("cirurgias");

  List<Cirurgia> cirurgiaListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return Cirurgia(
        idUser: doc.data['idUser'] ?? '',
        nomeDoMedico: doc.data['nomeDoMedico'] ?? '',
        especialidade: doc.data['especialidade'] ?? '',
        data: doc.data['data'] ?? '',
        horario: doc.data['horario'] ?? '',
        local: doc.data['local'] ?? '',
        tipoDeCirurgia: doc.data['tipoDeCirurgia'] ?? '',
        recomendacaoMedicaPosCirurgico:
            doc.data['recomendacaoMedicaPosCirurgico'] ?? '',
        medicacaoPosCirurgico: doc.data['medicacaoPosCirurgico'] ?? '',
        dataRetorno: doc.data['dataRetorno'] ?? '',
        formaDePagamento: doc.data['formaDePagamento'] ?? '',
        valor: doc.data['valor'] ?? '',
        status: doc.data['status'] ?? '',
      );
    }).toList();
  }

  Future listaDeCirurgias(String idUser) async {
    Cirurgia cirurgia = new Cirurgia();
    List<Cirurgia> cirurgias = new List<Cirurgia>();

    var snapshots = await cirurgiaCollection
        .where("idUser", isEqualTo: idUser)
        .getDocuments();
    snapshots.documents.forEach((d) {
      cirurgia = new Cirurgia(
          idUser: d.data['idUser'],
          idCirurgia: d.documentID,
          nomeDoMedico: d.data['nomeDoMedico'],
          especialidade: d.data['especialidade'] ?? '',
          data: d.data['data'],
          horario: d.data['horario'],
          local: d.data['local'],
          tipoDeCirurgia: d.data['tipoDeCirurgia'] ?? '',
          recomendacaoMedicaPosCirurgico:
              d.data['recomendacaoMedicaPosCirurgico'] ?? '',
          medicacaoPosCirurgico: d.data['medicacaoPosCirurgica'] ?? '',
          dataRetorno: d.data['dataRetorno'] ?? '',
          formaDePagamento: d.data['formaDePagamento'] ?? '',
          valor: d.data['valor'] ?? '',
          status: d.data['status'] ?? '');
      cirurgias.add(cirurgia);
    });

    return cirurgias;
  }

  Future cadastraCirurgia(
      String idUser,
      String nomeDoMedico,
      String especialidade,
      String tipoDeCirurgia,
      String data,
      String horario,
      String local,
      {String recomendacaoMedicaPosCirurgico,
      String medicacaoPosCirurgica,
      String dataRetorno,
      String formaDePagamento,
      double status,
      String valor}) async {
    try {
      var idCirurgia = await cirurgiaCollection.add({
        'idUser': idUser,
        'nomeDoMedico': nomeDoMedico,
        'tipoDeCirurgia': tipoDeCirurgia ?? '',
        'especialidade': especialidade ?? '',
        'data': data,
        'horario': horario,
        'local': local,
        'recomendacaoMedicaPosCirurgico': recomendacaoMedicaPosCirurgico ?? '',
        'medicacaoPosCirurgica': medicacaoPosCirurgica ?? '',
        'dataRetorno': dataRetorno ?? '',
        'formaDePagamento': formaDePagamento ?? '',
        'valor': valor ?? '',
        'status': status ?? ''
      });

      cirurgiaCollection
          .document(idCirurgia.documentID)
          .updateData({'idCirurgia': idCirurgia.documentID});
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  void excluirCirurgia(String idCirurgia, String idUser) async {
    try {
      var cirurgias = await cirurgiaCollection
          .where("idUser", isEqualTo: idUser)
          .where("idCirurgia", isEqualTo: idCirurgia)
          .getDocuments();

      cirurgias.documents.first.reference.delete();
    } catch (e) {
      print(e.toString());
    }
  }

  Future atualizarCirurgia(
      String idUser,
      String idCirurgia,
      String nomeDoMedico,
      String especialidade,
      String tipoDeCirurgia,
      String data,
      String horario,
      String local,
      {String recomendacaoMedicaPosCirurgico,
      String medicacaoPosCirurgica,
      String dataRetorno,
      String formaDePagamento,
      double status,
      String valor}) {
    try {
      cirurgiaCollection.document(idCirurgia).updateData({
        'idUser': idUser,
        'nomeDoMedico': nomeDoMedico,
        'tipoDeCirurgia': tipoDeCirurgia ?? '',
        'especialidade': especialidade ?? '',
        'data': data,
        'horario': horario,
        'local': local,
        'recomendacaoMedicaPosCirurgico': recomendacaoMedicaPosCirurgico ?? '',
        'medicacaoPosCirurgica': medicacaoPosCirurgica ?? '',
        'dataRetorno': dataRetorno ?? '',
        'formaDePagamento': formaDePagamento ?? '',
        'valor': valor ?? '',
        'status': status ?? ''
      });
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Stream<List<Cirurgia>> get allCirurgias {
    return cirurgiaCollection.snapshots().map(cirurgiaListFromSnapshot);
  }
}
