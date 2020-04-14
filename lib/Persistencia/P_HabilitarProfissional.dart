import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myhealth/class/HabilitarProfissional.dart';

class P_HabilitarProfissional {
  final String uid;
  P_HabilitarProfissional({this.uid});

  final CollectionReference profissionalCollection =
      Firestore.instance.collection("habilitarProfissional");

  List<HabilitarProfissional> profissionalListFromSnapshot(
      QuerySnapshot snapshot) {
    return snapshot.documents.map((d) {
      return HabilitarProfissional(
          paciente: d.data['paciente'],
          profissional: d.data['profissional'],
          estaHabilitado: d.data['estaHabilitado']);
    }).toList();
  }

  cadastraHabilitarProfissional(
      String paciente, String profissional, String estaHabilitado) {
    try {
      profissionalCollection.document().setData({
        'paciente': paciente,
        'profissional': profissional,
        'estaHabilitado': estaHabilitado
      });
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future getHabilitarProfissional(String paciente, String profi) async {
    HabilitarProfissional habilitarProfissional = new HabilitarProfissional();

    var snapshots = await profissionalCollection
        .where("paciente", isEqualTo: paciente)
        .where("profissional", isEqualTo: profi)
        .getDocuments();
    if (snapshots.documents.length != 0) {
      var d = snapshots.documents.first;

      habilitarProfissional = new HabilitarProfissional(
          idDocumento: d.documentID,
          paciente: d.data['paciente'],
          profissional: d.data['profissional'],
          estaHabilitado: d.data['estaHabilitado']);
      return habilitarProfissional;
    }

    return null;
  }

  atualizarProfissional(String idDocumento, String estaHabilitado) {
    try {
      profissionalCollection.document(idDocumento).updateData({
        'estaHabilitado': estaHabilitado,
      });
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<List<String>> listaDePacientesHabilitados(String profissional) async {
    List<String> profissionaisHabilitados = new List<String>();

    var snapshots = await profissionalCollection
        .where("profissional", isEqualTo: profissional)
        .where("estaHabilitado", isEqualTo: "Sim")
        .getDocuments();

    if (snapshots.documents.length != 0) {
      snapshots.documents.forEach((d) {
        profissionaisHabilitados.add(d.data['paciente']);
      });
    } else {
      return null;
    }

    return profissionaisHabilitados;
  }

  // Future listaDeProfissionais(String idUser) async {
  //   Profissional profissional = new Profissional();
  //   List<Profissional> profissionais = new List<Profissional>();

  //   var snapshots = await profissionalCollection
  //       .where("idUser", isEqualTo: idUser)
  //       .getDocuments();
  //   snapshots.documents.forEach((d) {
  //     profissional = new Profissional(
  //         idUser: d.data['idUser'],
  //         idProfissional: d.documentID,
  //         profissao: d.data['profissao'],
  //         especialidade: d.data['especialidade'] ?? '',
  //         nome: d.data['nome'],
  //         cpf: d.data['cpf'] ?? '',
  //         dataDeNascimento: d.data['dataDeNascimento'] ?? '',
  //         sexo: d.data['sexo'] ?? '',
  //         email: d.data['email'] ?? '',
  //         identificacao: d.data['identificacao'],
  //         localDeAtendimento: d.data['localDeAtendimento'],
  //         telefone: d.data['telefone'],
  //         imagemUrl: d.data['imagemUrl'] ?? '',
  //         status: d.data['status'] ?? '',
  //         tipoUser: d.data['tipoUser'] ?? '');
  //     profissionais.add(profissional);
  //   });

  //   return profissionais;
  // }

  // Future existeProfissional(String idUser) async {
  //   var snapshots = await profissionalCollection
  //       .where("idUser", isEqualTo: idUser)
  //       .getDocuments();
  //   return snapshots.documents.isNotEmpty;
  // }

  // Stream<List<Profissional>> get allprofissionais {
  //   return profissionalCollection.snapshots().map(profissionalListFromSnapshot);
  // }
}
