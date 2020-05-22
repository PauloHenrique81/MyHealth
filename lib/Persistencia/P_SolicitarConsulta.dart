import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myhealth/class/SolicitarConsulta.dart';

class P_SolicitarConsulta {
  final String uid;
  P_SolicitarConsulta({this.uid});

  final CollectionReference solicitarConsultaCollection =
      Firestore.instance.collection("solicitarConsulta");

  List<SolicitarConsulta> solicitarConsultaListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((d) {
      return SolicitarConsulta(
          nomeDoMedico: d.data['nomeDoMedico'] ?? '',
          codigoMedico: d.data['codigoMedico'] ?? '',
          nomePaciente: d.data['nomePaciente'] ?? '',
          codigoPaciente: d.data['codigoPaciente'] ?? '',
          cpfPaciente: d.data['cpfPaciente'] ?? '',
          telefone: d.data['telefone'] ?? '',
          data: d.data['data'] ?? '',
          horario: d.data['horario'] ?? '',
          local: d.data['local'] ?? '',
          status: d.data['status'] ?? ''
          );
    }).toList();
  }

  Future listaDeSolicitacoesPaciente(String idUser) async {
    SolicitarConsulta solicitacao = new SolicitarConsulta();
    List<SolicitarConsulta> solicitacoes = new List<SolicitarConsulta>();

    var snapshots = await solicitarConsultaCollection
        .where("codigoPaciente", isEqualTo: idUser)
        .getDocuments();
    snapshots.documents.forEach((d) {
      solicitacao = new SolicitarConsulta(
          idSolicitacao: d.documentID,
          nomeDoMedico: d.data['nomeDoMedico'] ?? '',
          codigoMedico: d.data['codigoMedico'] ?? '',
          nomePaciente: d.data['nomePaciente'] ?? '',
          codigoPaciente: d.data['codigoPaciente'] ?? '',
          cpfPaciente: d.data['cpfPaciente'] ?? '',
          telefone: d.data['telefone'] ?? '',
          data: d.data['data'] ?? '',
          horario: d.data['horario'] ?? '',
          local: d.data['local'] ?? '',
          status: d.data['status'] ?? '');
      solicitacoes.add(solicitacao);
    });

    return solicitacoes;
  }

    Future listaDeSolicitacoesProfissional(String idUser) async {
    SolicitarConsulta solicitacao = new SolicitarConsulta();
    List<SolicitarConsulta> solicitacoes = new List<SolicitarConsulta>();

    var snapshots = await solicitarConsultaCollection
        .where("codigoPaciente", isEqualTo: idUser)
        .getDocuments();
    snapshots.documents.forEach((d) {
      solicitacao = new SolicitarConsulta(
          idSolicitacao: d.documentID,
          nomeDoMedico: d.data['nomeDoMedico'] ?? '',
          codigoMedico: d.data['codigoMedico'] ?? '',
          nomePaciente: d.data['nomePaciente'] ?? '',
          codigoPaciente: d.data['codigoPaciente'] ?? '',
          cpfPaciente: d.data['cpfPaciente'] ?? '',
          telefone: d.data['telefone'] ?? '',
          data: d.data['data'] ?? '',
          horario: d.data['horario'] ?? '',
          local: d.data['local'] ?? '',
          status: d.data['status'] ?? '');
      solicitacoes.add(solicitacao);
    });

    return solicitacoes;
  }

  Future cadastraSolicitacao(
      String nomeDoMedico, String nomePaciente,String codigoMedico, String codigoPaciente, String cpfPaciente,
       String telefone, String data,String horario, String local, String status) async {
    try {
      var idSolicitacao = await solicitarConsultaCollection.add({
        'nomeDoMedico': nomeDoMedico,
        'codigoMedico': codigoMedico,
        'nomePaciente': nomePaciente,
        'codigoPaciente': codigoPaciente,
        'cpfPaciente': cpfPaciente,
        'telefone': telefone,
        'data': data,
        'horario': horario,
        'local': local,
        'status': status ?? ''
      });

      solicitarConsultaCollection
          .document(idSolicitacao.documentID)
          .updateData({'idSolicitacao': idSolicitacao.documentID});
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  void excluirSolicitacao(String idSolicitacao) async {
    try {
      var solicitacaoes = await solicitarConsultaCollection
          .where("idSolicitacao", isEqualTo: idSolicitacao)
          .getDocuments();

      solicitacaoes.documents.first.reference.delete();
    } catch (e) {
      print(e.toString());
    }
  }

  Future atualizarSolicitacao(String codigoPaciente, String idSolicitacao,
      String nomeDoMedico, String codigoMedico, String nomePaciente,
      {String cpfPaciente,
      String telefone,
      String data,
      String horario,
      String local,
      String status}) {
    try {
      solicitarConsultaCollection.document(idSolicitacao).updateData({
        'nomeDoMedico': nomeDoMedico,
        'codigoMedico': codigoMedico,
        'nomePaciente': nomePaciente,
        'codigoPaciente': codigoPaciente,
        'cpfPaciente': cpfPaciente,
        'telefone': telefone,
        'data': data,
        'horario': horario,
        'local': local,
        'status': status ?? ''
      });
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Stream<List<SolicitarConsulta>> get allSolicitacoes {
    return solicitarConsultaCollection.snapshots().map(solicitarConsultaListFromSnapshot);
  }
}
