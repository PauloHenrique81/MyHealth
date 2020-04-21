import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:myhealth/class/Imagem.dart';

class P_Imagem {
  final String uid;
  P_Imagem({this.uid});

  final CollectionReference imagemCollection =
      Firestore.instance.collection("imagens");
  final FirebaseStorage storage =
      FirebaseStorage(storageBucket: 'gs://flutter-78e41.appspot.com');

  List<Imagem> imagemListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return Imagem(
          idUser: doc.data['idUser'],
          modulo: doc.data['modulo'],
          idItem: doc.data['idItem'],
          url: doc.data['url'],
          path: doc.data['path']);
    }).toList();
  }

  Future listaDeImagens(String idUser, String idItem) async {
    Imagem imagem = new Imagem();
    List<Imagem> imagens = new List<Imagem>();

    var snapshots = await imagemCollection
        .where("idUser", isEqualTo: idUser)
        .where("idItem", isEqualTo: idItem)
        .getDocuments();
    snapshots.documents.forEach((d) {
      imagem = new Imagem(
          idUser: d.data['idUser'],
          idImagem: d.documentID,
          modulo: d.data['modulo'],
          idItem: d.data['idItem'],
          url: d.data['url'],
          path: d.data['path']);
      imagens.add(imagem);
    });

    return imagens;
  }

  void excluirImagem(String idUser, String idItem) async {
    try {
      var imagens = await imagemCollection
          .where("idUser", isEqualTo: idUser)
          .where("idItem", isEqualTo: idItem)
          .getDocuments();

      imagens.documents.forEach((d) {
        d.reference.delete();
        _excluirImagensStore(d.data['path']);
      });
    } catch (e) {
      print(e.toString());
    }
  }

  void _excluirImagensStore(String path) {
    try {
      storage.ref().child(path).delete();
    } catch (e) {
      print(e.toString());
    }
  }

  Future cadastraImagem(String idUser, String modulo, String idItem, String url,
      String path) async {
    try {
      var idImagem = await imagemCollection.add({
        'idUser': idUser,
        'modulo': modulo,
        'idItem': idItem,
        'url': url,
        'path': path
      });

      imagemCollection
          .document(idImagem.documentID)
          .updateData({'idImagem': idImagem.documentID});
      return idImagem;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Stream<List<Imagem>> get allImagens {
    return imagemCollection.snapshots().map(imagemListFromSnapshot);
  }
}
