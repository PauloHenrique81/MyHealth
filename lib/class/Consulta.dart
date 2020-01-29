class Consulta {
  String idUser;
  String idConsulta;
  String nomeDoMedico;
  String especialidade;
  String data;
  String horario;
  String local;
  String diagnostico;
  String exames;
  String medicamentos;
  String formaDePagamento;
  String valor;
  String status;

  Consulta(
      {this.idUser,
      this.idConsulta,
      this.nomeDoMedico,
      this.especialidade,
      this.data,
      this.horario,
      this.local,
      this.diagnostico,
      this.exames,
      this.medicamentos,
      this.formaDePagamento,
      this.valor,
      this.status});
}
