class Exame {
  String idUser;
  String idExame;
  String nomeDoMedico;
  String tipoExame;
  String data;
  String horario;
  String local;
  String dataResultado;
  String formaDePagamento;
  String valor;
  String status;

  Exame(
      {this.idUser,
      this.idExame,
      this.nomeDoMedico,
      this.tipoExame,
      this.data,
      this.horario,
      this.local,
      this.dataResultado,
      this.formaDePagamento,
      this.valor,
      this.status});

  DateTime convertData() {
    var aux = this.data.split('-');

    var data =
        new DateTime(int.parse(aux[2]), int.parse(aux[1]), int.parse(aux[0]));
    return data;
  }
}
