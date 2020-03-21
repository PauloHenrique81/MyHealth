import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myhealth/Helper/Vacina_Help.dart';

class P_Vacina {
  final String uid;
  P_Vacina({this.uid});

  final CollectionReference vacinaCollection =
      Firestore.instance.collection("vacinas");

  List<TiposDeVacinas> vacinaListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return TiposDeVacinas(doc.data['codigo'], doc.data['tipo'],
          doc.data['descricao'], doc.data['doses'],
          status: doc.data['status'],
          uid: doc.data['uid'] ?? '',
          data: doc.data['data'] ?? '');
    }).toList();
  }

  Future existeVacina(String idUser) async {
    var snapshots =
        await vacinaCollection.where("uid", isEqualTo: idUser).getDocuments();
    return snapshots.documents.isNotEmpty;
  }

  Future cadastraVacina(
      String codigo, String tipo, String descricao, String doses,
      {String status, String uid, String data}) {
    vacinaCollection.document().setData({
      'codigo': codigo,
      'tipo': tipo,
      'descricao': descricao,
      'doses': doses,
      'status': status,
      'uid': uid,
      'data': data
    });
  }

  Future listaDePacientes() async {
    TiposDeVacinas vacina;
    List<TiposDeVacinas> vacinas = new List<TiposDeVacinas>();

    var snapshots = await vacinaCollection.getDocuments();
    snapshots.documents.forEach((d) {
      vacina = new TiposDeVacinas(d.data['codigo'] ?? '', d.data['tipo'] ?? '',
          d.data['descricao'] ?? '', d.data['doses'] ?? '',
          status: d.data['status'] ?? '',
          uid: d.data['uid'] ?? '',
          data: d.data['data'] ?? '');
      vacinas.add(vacina);
    });

    return vacinas;
  }

  Future getVacina(String idUser) async {
    TiposDeVacinas vacina;

    var snapshots =
        await vacinaCollection.where("uid", isEqualTo: uid).getDocuments();
    var d = snapshots.documents.first;
    vacina = new TiposDeVacinas(
        d.data['codigo'], d.data['tipo'], d.data['descricao'], d.data['doses'],
        status: d.data['status'] ?? '',
        uid: d.data['uid'] ?? '',
        data: d.data['data'] ?? '');
    return vacina;
  }

  Future atualizarVacina(
      String codigo, String tipo, String descricao, String doses,
      {String status, String uid, String data}) {
    try {
      vacinaCollection.document(uid).updateData({
        'codigo': codigo,
        'tipo': tipo,
        'descricao': descricao,
        'doses': doses,
        'status': status ?? '',
        'data': data
      });
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Stream<List<TiposDeVacinas>> get allvacinas {
    return vacinaCollection.snapshots().map(vacinaListFromSnapshot);
  }
}
