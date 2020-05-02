import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myhealth/class/Cirurgia.dart';
import 'package:myhealth/class/Consulta.dart';
import 'package:myhealth/class/DoarSangue.dart';
import 'package:myhealth/class/Exame.dart';

class P_AtividadeDoDia{

    final CollectionReference consultaCollection =
      Firestore.instance.collection("consultas");

    final CollectionReference exameCollection =
      Firestore.instance.collection("exames");

    final CollectionReference cirurgiaCollection =
      Firestore.instance.collection("cirurgias");

    final CollectionReference doacaoCollection =
      Firestore.instance.collection("doarSangue");

     String dataHoje;

    P_AtividadeDoDia(){
      dataHoje = _montaDataDeHoje();
    }

  
    String _montaDataDeHoje(){
      String dia = DateTime.now().day.toString();
      String mes = DateTime.now().month.toString();
      String ano = DateTime.now().year.toString();
      String data;
      if(dia.length == 1){
        data = '0' + dia;
      }else{
        data = dia;
      }

      if(mes.length == 1){
        data += '-' + '0' + mes + '-';
      }else{
        data += '-' + mes + '-';
      }

      data += ano;

      return data;


    }

    Future<Consulta> getConsulta(String idUser) async {
  Consulta consulta = new Consulta();

    var snapshots =
        await consultaCollection
        .where("idUser", isEqualTo: idUser)
        .where("data", isEqualTo:  dataHoje)
        .getDocuments();

    if(snapshots.documents.length > 0){
      var d = snapshots.documents.first;
    consulta = new Consulta(
    idUser: d.data['idUser'],
            idConsulta: d.documentID,
            nomeDoMedico: d.data['nomeDoMedico'],
            especialidade: d.data['especialidade'] ?? '',
            codigoDoProfissional : d.data['codigoDoProfissional'] ?? '',
            data: d.data['data'],
            horario: d.data['horario'],
            local: d.data['local'],
            diagnostico: d.data['diagnostico'] ?? '',
            exames: d.data['exames'] ?? '',
            medicamentos: d.data['medicamentos'] ?? '',
            formaDePagamento: d.data['formaDePagamento'] ?? '',
            valor: d.data['valor'] ?? '',
            status: d.data['status'] ?? '');
    return consulta;
    }else{
      return null;
    }
    
  }

    Future<Exame> getExame(String idUser) async {
      Exame exame = new Exame();

      var snapshots =
          await exameCollection.where("idUser", isEqualTo: idUser)
          .where("data", isEqualTo:  dataHoje)
          .getDocuments();

      if(snapshots.documents.length > 0){
              var d = snapshots.documents.first;
      exame = new Exame(
            idUser: d.data['idUser'],
            idExame: d.documentID,
            nomeDoMedico: d.data['nomeDoMedico'],
            tipoExame: d.data['tipoExame'] ?? '',
            data: d.data['data'],
            horario: d.data['horario'],
            local: d.data['local'],
            dataResultado: d.data['dataResultado'] ?? '',
            formaDePagamento: d.data['formaDePagamento'] ?? '',
            valor: d.data['valor'] ?? '',
            status: d.data['status'] ?? '');
      return exame;
      }else{
        return null;
      }

    }
    
    Future<Cirurgia> getCirurgia(String idUser) async {
      Cirurgia cirurgia = new Cirurgia();

      var snapshots =
          await cirurgiaCollection.where("idUser", isEqualTo: idUser)
          .where("data", isEqualTo:  dataHoje)
          .getDocuments();

      if(snapshots.documents.length > 0){
        var d = snapshots.documents.first;
      cirurgia = new Cirurgia(
            idUser: d.data['idUser'],
          idCirurgia: d.documentID,
          nomeDoMedico: d.data['nomeDoMedico'],
          especialidade: d.data['especialidade'] ?? '',
          data: d.data['data'],
          horario: d.data['horario'],
          local: d.data['local'],
          tipoDeCirurgia: d.data['tipoDeCirurgia'] ?? '',
          recomendacaoMedicaPosCirurgico:
              d.data['recomendacaoMedicaPosCirurgico'] ?? '',
          medicacaoPosCirurgico: d.data['medicacaoPosCirurgica'] ?? '',
          dataRetorno: d.data['dataRetorno'] ?? '',
          formaDePagamento: d.data['formaDePagamento'] ?? '',
          valor: d.data['valor'] ?? '',
          status: d.data['status'] ?? '');
      return cirurgia;
      }else{
        return null;
      }
      
      
  }

    Future<DoarSangue> getDoacao(String idUser) async {
      DoarSangue doacao = new DoarSangue();

      var snapshots =
          await doacaoCollection.where("idUser", isEqualTo: idUser)
          .where("data", isEqualTo:  dataHoje)
          .getDocuments();

      if(snapshots.documents.length > 0){
         var d = snapshots.documents.first;
      doacao = new DoarSangue(
          idUser: d.data['idUser'],
          idDoacao: d.documentID,
          data: d.data['data'],
          horario: d.data['horario'] ?? '',
          local: d.data['local'] ?? '');
      return doacao;
      }  else{
        return null;
      }
      
     
    }

}