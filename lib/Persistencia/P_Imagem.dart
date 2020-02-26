import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myhealth/class/Imagem.dart';

class P_Imagem {
  final String uid;
  P_Imagem({this.uid});

  final CollectionReference exameCollection =
      Firestore.instance.collection("imagens");

  List<Imagem> imagemListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return Imagem(
          idUser: doc.data['idUser'],
          modulo: doc.data['modulo'],
          idItem: doc.data['tipoExame'],
          url: doc.data['data']);
    }).toList();
  }

  Future listaDeImagens(String idUser) async {
    Imagem imagem = new Imagem();
    List<Imagem> imagens = new List<Imagem>();

    var snapshots =
        await exameCollection.where("idUser", isEqualTo: idUser).getDocuments();
    snapshots.documents.forEach((d) {
      imagem = new Imagem(
          idUser: d.data['idUser'],
          idImagem: d.documentID,
          modulo: d.data['nomeDoMedico'],
          idItem: d.data['tipoExame'],
          url: d.data['data']);
      imagens.add(imagem);
    });

    return imagens;
  }

  Future cadastraImagem(
      String idUser, String modulo, String idItem, String url) {
    try {
      var id;
      id = exameCollection.add(
          {'idUser': idUser, 'modulo': modulo, 'idItem': idItem, 'url': url});
      return id;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Stream<List<Imagem>> get allImagens {
    return exameCollection.snapshots().map(imagemListFromSnapshot);
  }
}
