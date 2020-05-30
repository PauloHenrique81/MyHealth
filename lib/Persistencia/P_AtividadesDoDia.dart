import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myhealth/Service/Util.dart';
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

    final dataAtual = Util.getDataAtual();

  Future<List<Consulta>> getConsultas(String idUser) async {
  Consulta consulta = new Consulta();
  List<Consulta> listaDeconsulta = new List<Consulta>();
    
    var snapshots =
        await consultaCollection
        .where("idUser", isEqualTo: idUser)
        .where("data", isEqualTo:  dataAtual)
        .getDocuments();

    if(snapshots.documents.length > 0){
        snapshots.documents.forEach((d) {
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
                  listaDeconsulta.add(consulta);
        });
    return listaDeconsulta;
    }else{
      return new List<Consulta>();
    }
    
  }

    Future<List<Exame>> getExames(String idUser) async {
      
      Exame exame = new Exame();
      List<Exame> listaDeExames = new List<Exame>();
      var snapshots =
          await exameCollection.where("idUser", isEqualTo: idUser)
          .where("data", isEqualTo:  dataAtual)
          .getDocuments();

      if(snapshots.documents.length > 0){
        snapshots.documents.forEach((d) {       
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
            listaDeExames.add(exame);
        });
      return listaDeExames;
      }else{
        return new List<Exame>();
      }

    }
    
    Future<List<Cirurgia>> getCirurgias(String idUser) async {
      Cirurgia cirurgia = new Cirurgia();
      List<Cirurgia> listaDeCirurgias = new List<Cirurgia>();
      var snapshots =
          await cirurgiaCollection.where("idUser", isEqualTo: idUser)
          .where("data", isEqualTo: dataAtual )
          .getDocuments();

      if(snapshots.documents.length > 0){
         snapshots.documents.forEach((d) {    
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
            listaDeCirurgias.add(cirurgia);
         });
      return listaDeCirurgias;

      }else{
        return new List<Cirurgia>();
      }
      
      
  }

    Future<List<DoarSangue>> getDoacoes(String idUser) async {
      DoarSangue doacao = new DoarSangue();
      List<DoarSangue> listaDeDoacoes = List<DoarSangue>();

      var snapshots =
          await doacaoCollection.where("idUser", isEqualTo: idUser)
          .where("data", isEqualTo:  dataAtual)
          .getDocuments();

      if(snapshots.documents.length > 0){
           snapshots.documents.forEach((d) { 
            doacao = new DoarSangue(
                idUser: d.data['idUser'],
                idDoacao: d.documentID,
                data: d.data['data'],
                horario: d.data['horario'] ?? '',
                local: d.data['local'] ?? '');
                listaDeDoacoes.add(doacao);
           });
      return listaDeDoacoes;
      }  else{
        return new List<DoarSangue>();
      }
      
     
    }

}