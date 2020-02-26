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

  Future cadastraReceita(String idUser, String medico, String data,
      {String descricao}) {
    try {
      var idReceita = receitaCollection.add({
        'idUser': idUser,
        'medico': medico,
        'descricao': descricao ?? '',
        'data': data
      });

      return idReceita;
    } catch (e) {
      print(e.toString());
      return null;
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

  Stream<List<Receita>> get allCirurgias {
    return receitaCollection.snapshots().map(receitaListFromSnapshot);
  }
}
