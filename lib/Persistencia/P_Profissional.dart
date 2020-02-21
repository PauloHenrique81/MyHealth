import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myhealth/class/Profissional.dart';

class P_Profissional {
  final String uid;
  P_Profissional({this.uid});

  final CollectionReference profissionalCollection =
      Firestore.instance.collection("profissionais");

  List<Profissional> profissionalListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return Profissional(
        idUser: doc.data['idUser'] ?? '',
        profissao: doc.data['profissao'] ?? '',
        especialidade: doc.data['especialidade'] ?? '',
        nome: doc.data['nome'] ?? '',
        identificacao: doc.data['identificacao'] ?? '',
        localDeAtendimento: doc.data['localDeAtendimento'] ?? '',
        status: doc.data['status'] ?? '',
      );
    }).toList();
  }

  Future listaDeProfissionais(String idUser) async {
    Profissional profissional = new Profissional();
    List<Profissional> profissionais = new List<Profissional>();

    var snapshots = await profissionalCollection
        .where("idUser", isEqualTo: idUser)
        .getDocuments();
    snapshots.documents.forEach((d) {
      profissional = new Profissional(
          idUser: d.data['idUser'],
          idProfissional: d.documentID,
          profissao: d.data['profissao'],
          especialidade: d.data['especialidade'] ?? '',
          nome: d.data['nome'],
          identificacao: d.data['identificacao'],
          localDeAtendimento: d.data['localDeAtendimento'],
          status: d.data['status'] ?? '');
      profissionais.add(profissional);
    });

    return profissionais;
  }

  Future cadastraProfissional(
      String idUser, String profissao, String nome, String localDeAtendimento,
      {String especialidade, String identificacao, String status}) {
    try {
      profissionalCollection.document().setData({
        'idUser': idUser,
        'profissao': profissao,
        'nome': nome,
        'localDeAtendimento': localDeAtendimento,
        'especialidade': especialidade ?? '',
        'identificacao': identificacao ?? '',
        'status': status ?? '',
      });
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future atualizarProfissional(String idUser, String idProfissional,
      String nome, String localDeAtendimento, String profissao,
      {String especialidade, String identificacao, String status}) {
    try {
      profissionalCollection.document(idProfissional).updateData({
        'idUser': idUser,
        'nome': nome,
        'profissao': profissao,
        'localDeAtendimento': localDeAtendimento,
        'especialidade': especialidade ?? '',
        'identificacao': identificacao ?? '',
        'status': status ?? ''
      });
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Stream<List<Profissional>> get allprofissionais {
    return profissionalCollection.snapshots().map(profissionalListFromSnapshot);
  }
}
