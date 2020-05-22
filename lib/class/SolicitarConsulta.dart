class SolicitarConsulta {
  String idSolicitacao;
  String nomeDoMedico;
  String codigoMedico;
  String nomePaciente;
  String codigoPaciente;
  String cpfPaciente;
  String telefone;
  String data;
  String horario;
  String local;
  String status;

  SolicitarConsulta(
        {
          this.idSolicitacao,
          this.nomeDoMedico,
          this.codigoMedico,
          this.nomePaciente,
          this.codigoPaciente,
          this.cpfPaciente,
          this.telefone,
          this.data,
          this.horario,
          this.local,
          this.status
        });

  DateTime convertData() {
    var aux = this.data.split('-');

    var data =
        new DateTime(int.parse(aux[2]), int.parse(aux[1]), int.parse(aux[0]));
    return data;
  }
}
