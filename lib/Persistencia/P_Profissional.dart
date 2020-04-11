import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myhealth/class/Profissional.dart';

class P_Profissional {
  final String uid;
  P_Profissional({this.uid});

  final CollectionReference profissionalCollection =
      Firestore.instance.collection("profissionais");

  List<Profissional> profissionalListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((d) {
      return Profissional(
          idUser: d.data['idUser'] ?? '',
          profissao: d.data['profissao'] ?? '',
          especialidade: d.data['especialidade'] ?? '',
          nome: d.data['nome'] ?? '',
          cpf: d.data['cpf'] ?? '',
          dataDeNascimento: d.data['dataDeNascimento'] ?? '',
          sexo: d.data['sexo'] ?? '',
          email: d.data['email'] ?? '',
          identificacao: d.data['identificacao'] ?? '',
          localDeAtendimento: d.data['localDeAtendimento'] ?? '',
          imagemUrl: d.data['imagemUrl'] ?? '',
          status: d.data['status'] ?? '',
          tipoUser: d.data['status'] ?? 'nao');
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
          cpf: d.data['cpf'] ?? '',
          dataDeNascimento: d.data['dataDeNascimento'] ?? '',
          sexo: d.data['sexo'] ?? '',
          email: d.data['email'] ?? '',
          identificacao: d.data['identificacao'],
          localDeAtendimento: d.data['localDeAtendimento'],
          telefone: d.data['telefone'],
          imagemUrl: d.data['imagemUrl'] ?? '',
          status: d.data['status'] ?? '',
          tipoUser: d.data['tipoUser'] ?? '');
      profissionais.add(profissional);
    });

    return profissionais;
  }

  Future cadastraProfissional(
      String idUser, String profissao, String nome, String localDeAtendimento,
      {String especialidade,
      String identificacao,
      String telefone,
      String status,
      String cpf,
      String dataDeNascimento,
      String sexo,
      String email,
      String tipoUser,
      String imagemUrl}) {
    try {
      profissionalCollection.document().setData({
        'idUser': idUser,
        'profissao': profissao,
        'nome': nome,
        'cpf': cpf,
        'dataDeNascimento': dataDeNascimento,
        'sexo': sexo,
        'email': email,
        'localDeAtendimento': localDeAtendimento,
        'especialidade': especialidade ?? '',
        'identificacao': identificacao ?? '',
        'telefone': telefone ?? '',
        'status': status ?? '',
        'tipoUser': tipoUser,
        'imagemUrl': imagemUrl ?? ''
      });
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future atualizarProfissional(String idUser, String idProfissional,
      String nome, String localDeAtendimento, String profissao,
      {String especialidade,
      String identificacao,
      String telefone,
      String status,
      String cpf,
      String dataDeNascimento,
      String sexo,
      String email,
      String tipoUser,
      String imagemUrl}) {
    try {
      profissionalCollection.document(idProfissional).updateData({
        'idUser': idUser,
        'nome': nome,
        'cpf': cpf,
        'dataDeNascimento': dataDeNascimento,
        'sexo': sexo,
        'email': email,
        'profissao': profissao,
        'localDeAtendimento': localDeAtendimento,
        'especialidade': especialidade ?? '',
        'identificacao': identificacao ?? '',
        'telefone': telefone ?? '',
        'status': status ?? '',
        'tipoUser': tipoUser,
        'imagemUrl': imagemUrl
      });
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future listaDeProfissionaisUser(String idUser) async {
    Profissional profissional = new Profissional();
    List<Profissional> profissionais = new List<Profissional>();

    var snapshots = await profissionalCollection
        .where("tipoUser", isEqualTo: "Sim")
        .getDocuments();
    if (snapshots.documents.length != 0) {
      snapshots.documents.forEach((d) {
        profissional = new Profissional(
            idUser: d.data['idUser'],
            idProfissional: d.documentID,
            profissao: d.data['profissao'],
            especialidade: d.data['especialidade'] ?? '',
            nome: d.data['nome'],
            cpf: d.data['cpf'] ?? '',
            dataDeNascimento: d.data['dataDeNascimento'] ?? '',
            sexo: d.data['sexo'] ?? '',
            email: d.data['email'] ?? '',
            identificacao: d.data['identificacao'],
            localDeAtendimento: d.data['localDeAtendimento'],
            telefone: d.data['telefone'],
            imagemUrl: d.data['imagemUrl'] ?? '',
            status: d.data['status'] ?? '',
            tipoUser: d.data['tipoUser'] ?? '');

        profissionais.add(profissional);
      });
      return profissionais;
    }
  }

  Future getProfissionalUser(String idUser) async {
    Profissional profissional = new Profissional();

    var snapshots = await profissionalCollection
        .where("idUser", isEqualTo: idUser)
        .where("tipoUser", isEqualTo: "Sim")
        .getDocuments();
    var d = snapshots.documents.first;
    profissional = new Profissional(
        idUser: d.data['idUser'],
        idProfissional: d.documentID,
        profissao: d.data['profissao'],
        especialidade: d.data['especialidade'] ?? '',
        nome: d.data['nome'],
        cpf: d.data['cpf'] ?? '',
        dataDeNascimento: d.data['dataDeNascimento'] ?? '',
        sexo: d.data['sexo'] ?? '',
        email: d.data['email'] ?? '',
        identificacao: d.data['identificacao'],
        localDeAtendimento: d.data['localDeAtendimento'],
        telefone: d.data['telefone'],
        imagemUrl: d.data['imagemUrl'] ?? '',
        status: d.data['status'] ?? '',
        tipoUser: d.data['tipoUser'] ?? '');
    return profissional;
  }

  Future existeProfissional(String idUser) async {
    var snapshots = await profissionalCollection
        .where("idUser", isEqualTo: idUser)
        .getDocuments();
    return snapshots.documents.isNotEmpty;
  }

  Stream<List<Profissional>> get allprofissionais {
    return profissionalCollection.snapshots().map(profissionalListFromSnapshot);
  }
}
