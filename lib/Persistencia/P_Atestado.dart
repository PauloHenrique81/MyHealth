import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myhealth/class/Atestado.dart';

class P_Atestado {
  final String uid;
  P_Atestado({this.uid});

  final CollectionReference atestadoCollection =
      Firestore.instance.collection("atestado");

  List<Atestado> atestadoListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return Atestado(
          idUser: doc.data['idUser'] ?? '',
          medico: doc.data['medico'] ?? '',
          data: doc.data['data'],
          quantidadeDeDias: doc.data['quantidadeDeDias'],
          motivo: doc.data['motivo']);
    }).toList();
  }

  Future listaDeAtestados(String idUser) async {
    Atestado atestado = new Atestado();
    List<Atestado> atestados = new List<Atestado>();

    var snapshots = await atestadoCollection
        .where("idUser", isEqualTo: idUser)
        .getDocuments();
    snapshots.documents.forEach((d) {
      atestado = new Atestado(
          idUser: d.data['idUser'],
          idAtestado: d.documentID,
          medico: d.data['medico'],
          data: d.data['data'],
          quantidadeDeDias: d.data['quantidadeDeDias'] ?? '',
          motivo: d.data['motivo'] ?? '');
      atestados.add(atestado);
    });

    return atestados;
  }

  Future getAtestado(String idAtestado) async {
    Atestado atestado = new Atestado();

    var snapshots = await atestadoCollection.document(idAtestado).get();
    var d = snapshots;

    atestado = new Atestado(
        idUser: d.data['idUser'] ?? '',
        idAtestado: d.data['idAtestado'] ?? '',
        medico: d.data['medico'] ?? '',
        data: d.data['data'] ?? '',
        quantidadeDeDias: d.data['quantidadeDeDias'] ?? '',
        motivo: d.data['motivo'] ?? '');

    return atestado;
  }

  Future cadastraAtestado(String idUser, String medico, String data,
      String quantidadeDeDias, String motivo) async {
    try {
      var idAtestado = await atestadoCollection.add({
        'idUser': idUser,
        'medico': medico,
        'data': data,
        'quantidadeDeDias': quantidadeDeDias,
        'motivo': motivo
      });

      return idAtestado.documentID;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future atualizarAtestado(String idUser, String idAtestado, String medico,
      String data, String quantidadeDeDias, String motivo) {
    try {
      atestadoCollection.document(idAtestado).updateData({
        'idUser': idUser,
        'medico': medico,
        'data': data,
        'quantidadeDeDias': quantidadeDeDias,
        'motivo': motivo
      });
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Stream<List<Atestado>> get allCirurgias {
    return atestadoCollection.snapshots().map(atestadoListFromSnapshot);
  }
}
