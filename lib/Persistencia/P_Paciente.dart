import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myhealth/class/Paciente.dart';

class P_Paciente {
  final String uid;
  P_Paciente({this.uid});

  final CollectionReference pacienteCollection =
      Firestore.instance.collection("pacientes");

  List<Paciente> pacienteListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return Paciente(
        uid: doc.data['uid'] ?? '',
        nome: doc.data['nome'] ?? '',
        documentID: doc.documentID,
        dataDeNascimento: doc.data['dataDeNascimento'] ?? '',
        cpf: doc.data['cpf'] ?? '',
        email: doc.data['email'] ?? '',
        telefone: doc.data['telefone'] ?? '',
        cidade: doc.data['cidade'] ?? '',
        tipoSanguineo: doc.data['tipoSanguineo'] ?? '',
        medicamentosAlergicos: doc.data['medicamentosAlergicos'] ?? '',
        alimentosAlergicos: doc.data['alimentosAlergicos'] ?? '',
        intolerancia: doc.data['intolerancia'] ?? '',
        imagemUrl: doc.data['imagemUrl'] ?? '',
        senha: doc.data['senha'] ?? '',
      );
    }).toList();
  }

  Future existePaciente(String idUser) async {
    var snapshots =
        await pacienteCollection.where("uid", isEqualTo: idUser).getDocuments();
    return snapshots.documents.isNotEmpty;
  }

  Future cadastraPaciente(String uid, String nome, String email,
      {String imagemUrl,
      String dataDeNascimento,
      String cpf,
      String telefone,
      String cidade,
      String tipoSanguineo,
      String medicamentosAlergicos,
      String alimentosAlergicos,
      String intolerancia}) {
    pacienteCollection.document().setData({
      'uid': uid,
      'nome': nome,
      'email': email,
      'cpf': cpf,
      'dataDeNascimento': dataDeNascimento,
      'telefone': telefone,
      'cidade': cidade,
      'tipoSanguineo': tipoSanguineo,
      'medicamentosAlergicos': medicamentosAlergicos,
      'alimentosAlergicos': alimentosAlergicos,
      'intolerancia': intolerancia,
      'dataDeCadastro': DateTime.now().toString(),
    });
  }

  Future listaDePacientes() async {
    Paciente paciente = new Paciente();
    List<Paciente> pacientes = new List<Paciente>();

    var snapshots = await pacienteCollection.getDocuments();
    snapshots.documents.forEach((d) {
      paciente = new Paciente(
          uid: d.data['uid'] ?? '',
          documentID: d.documentID,
          nome: d.data['nome'] ?? '',
          dataDeNascimento: d.data['dataDeNascimento'] ?? '',
          cpf: d.data['cpf'] ?? '',
          email: d.data['email'] ?? '',
          telefone: d.data['telefone'] ?? '',
          cidade: d.data['cidade'] ?? '',
          tipoSanguineo: d.data['tipoSanguineo'] ?? '',
          medicamentosAlergicos: d.data['medicamentosAlergicos'] ?? '',
          alimentosAlergicos: d.data['alimentosAlergicos'] ?? '',
          intolerancia: d.data['intolerancia'] ?? '',
          imagemUrl: d.data['imagemUrl'] ?? '',
          senha: d.data['senha'] ?? '');
      pacientes.add(paciente);
    });

    return pacientes;
  }

  Future<Paciente> getPaciente(String idUser) async {
    Paciente paciente = new Paciente();

    var snapshots =
        await pacienteCollection.where("uid", isEqualTo: idUser).getDocuments();
    var d = snapshots.documents.first;
    paciente = new Paciente(
        uid: d.data['uid'] ?? '',
        documentID: d.documentID,
        nome: d.data['nome'] ?? '',
        dataDeNascimento: d.data['dataDeNascimento'] ?? '',
        cpf: d.data['cpf'] ?? '',
        email: d.data['email'] ?? '',
        telefone: d.data['telefone'] ?? '',
        cidade: d.data['cidade'] ?? '',
        tipoSanguineo: d.data['tipoSanguineo'] ?? '',
        medicamentosAlergicos: d.data['medicamentosAlergicos'] ?? '',
        alimentosAlergicos: d.data['alimentosAlergicos'] ?? '',
        intolerancia: d.data['intolerancia'] ?? '',
        imagemUrl: d.data['imagemUrl'] ?? '',
        senha: d.data['senha'] ?? '');
    return paciente;
  }

  Future atualizarPaciente(String documentID, String nome, String cpf,
      {String dataDeNascimento,
      String email,
      String telefone,
      String cidade,
      String tipoSanguineo,
      String medicamentosAlergicos,
      String alimentosAlergicos,
      String intolerancia,
      String imagemUrl}) {
    try {
      pacienteCollection.document(documentID).updateData({
        'nome': nome ?? '',
        'cpf': cpf ?? '',
        'dataDeNascimento': dataDeNascimento ?? '',
        'email': email ?? '',
        'telefone': telefone ?? '',
        'cidade': cidade ?? '',
        'tipoSanguineo': tipoSanguineo ?? '',
        'medicamentosAlergicos': medicamentosAlergicos ?? '',
        'alimentosAlergicos': alimentosAlergicos ?? '',
        'imagemUrl': imagemUrl ?? '',
        'intolerancia': intolerancia ?? ''
      });
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Stream<List<Paciente>> get allpacientes {
    return pacienteCollection.snapshots().map(pacienteListFromSnapshot);
  }
}
