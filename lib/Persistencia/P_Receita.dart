import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myhealth/class/Receita.dart';

class P_Receita {
  final String uid;
  P_Receita({this.uid});

  final CollectionReference receitaCollection =
      Firestore.instance.collection("receitas");

  List<Receita> receitaListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return Receita(
          idUser: doc.data['idUser'] ?? '',
          medico: doc.data['medico'] ?? '',
          data: doc.data['data'],
          descricao: doc.data['descricao'] ?? '');
    }).toList();
  }

  Future listaDeReceitas(String idUser) async {
    Receita receita = new Receita();
    List<Receita> receitas = new List<Receita>();

    var snapshots = await receitaCollection
        .where("idUser", isEqualTo: idUser)
        .getDocuments();
    snapshots.documents.forEach((d) {
      receita = new Receita(
          idUser: d.data['idUser'],
          idReceita: d.documentID,
          medico: d.data['medico'],
          data: d.data['data'],
          descricao: d.data['descricao'] ?? '');
      receitas.add(receita);
    });

    return receitas;
  }

  Future getReceita(String idReceita) async {
    Receita receita = new Receita();

    var snapshots = await receitaCollection.document(idReceita).get();
    var d = snapshots;

    receita = new Receita(
        idUser: d.data['idUser'] ?? '',
        idReceita: d.data['idReceita'] ?? '',
        medico: d.data['medico'] ?? '',
        data: d.data['data'] ?? '',
        descricao: d.data['descricao'] ?? '');

    return receita;
  }

  Future cadastraReceita(String idUser, String medico, String data,
      {String descricao}) async {
    try {
      var idReceita = await receitaCollection.add({
        'idUser': idUser,
        'medico': medico,
        'descricao': descricao ?? '',
        'data': data
      });

      receitaCollection
          .document(idReceita.documentID)
          .updateData({'idReceita': idReceita.documentID});

      return idReceita.documentID;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  void excluirReceita(String idReceita, String idUser) async {
    try {
      var consultas = await receitaCollection
          .where("idUser", isEqualTo: idUser)
          .where("idReceita", isEqualTo: idReceita)
          .getDocuments();

      consultas.documents.first.reference.delete();
    } catch (e) {
      print(e.toString());
    }
  }

  Future atualizarReceita(
      String idUser, String idReceita, String medico, String data,
      {String descricao}) {
    try {
      receitaCollection.document(idReceita).updateData({
        'idUser': idUser,
        'medico': medico,
        'descricao': descricao ?? '',
        'data': data
      });
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Stream<List<Receita>> get allReceitas {
    return receitaCollection.snapshots().map(receitaListFromSnapshot);
  }
}
