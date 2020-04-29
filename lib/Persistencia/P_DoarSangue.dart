import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myhealth/class/DoarSangue.dart';
class P_DoarSangue {
  final String uid;
  P_DoarSangue({this.uid});

  final CollectionReference doacaoCollection =
      Firestore.instance.collection("doarSangue");

  List<DoarSangue> doacaoListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((d) {
      return DoarSangue(
          idUser: d.data['idUser'] ?? '',
          data: d.data['data'] ?? '',
          horario: d.data['horario'],
          local: d.data['local'] ?? '');
    }).toList();
  }

  Future listaDeDoacoes(String idUser) async {
    DoarSangue doacao = new DoarSangue();
    List<DoarSangue> doacoes = new List<DoarSangue>();

    var snapshots = await doacaoCollection
        .where("idUser", isEqualTo: idUser)
        .getDocuments();
    snapshots.documents.forEach((d) {
      doacao = new DoarSangue(
          idUser: d.data['idUser'],
          idDoacao: d.documentID,
          data: d.data['data'],
          horario: d.data['horario'] ?? '',
          local: d.data['local'] ?? '');
      doacoes.add(doacao);
    });

    return doacoes;
  }

  Future getDoacao(String idDoacao) async {
    DoarSangue doacao = new DoarSangue();

    var snapshots = await doacaoCollection.document(idDoacao).get();
    var d = snapshots;

    doacao = new DoarSangue(
        idUser: d.data['idUser'] ?? '',
        idDoacao: d.data['idDoacao'] ?? '',
        data: d.data['data'] ?? '',
        horario: d.data['horario'] ?? '',
        local: d.data['local'] ?? '');

    return doacao;
  }

  void excluirDoacao(String idDoacao, String idUser) async {
    try {
      var doacoes = await doacaoCollection
          .where("idUser", isEqualTo: idUser)
          .where("idDoacao", isEqualTo: idDoacao)
          .getDocuments();

      doacoes.documents.first.reference.delete();
    } catch (e) {
      print(e.toString());
    }
  }

  Future cadastraDoacao(String idUser, String data, String horario,
      String local) async {
    try {
      var idDoacao = await doacaoCollection.add({
        'idUser': idUser,
        'data': data,
        'horario': horario,
        'local': local
      });

      doacaoCollection
          .document(idDoacao.documentID)
          .updateData({'idDoacao': idDoacao.documentID});

      return idDoacao.documentID;

    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future atualizarDocao(String idUser, String idDoacao, String data,
      String horario, String local) {
    try {
      doacaoCollection.document(idDoacao).updateData({
        'idUser': idUser,
        'data': data,
        'horario': horario,
        'local': local
      });
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Stream<List<DoarSangue>> get allDoacoes {
    return doacaoCollection.snapshots().map(doacaoListFromSnapshot);
  }
}
