class Cirurgia {
  String idUser;
  String idCirurgia;
  String nomeDoMedico;
  String especialidade;
  String data;
  String horario;
  String local;
  String tipoDeCirurgia;
  String formaDePagamento;
  String recomendacaoMedicaPosCirurgico;
  String medicacaoPosCirurgico;
  String dataRetorno;
  String valor;
  String status;

  Cirurgia(
      {this.idUser,
      this.idCirurgia,
      this.nomeDoMedico,
      this.especialidade,
      this.data,
      this.horario,
      this.local,
      this.tipoDeCirurgia,
      this.recomendacaoMedicaPosCirurgico,
      this.medicacaoPosCirurgico,
      this.formaDePagamento,
      this.dataRetorno,
      this.valor,
      this.status});

  DateTime convertData() {
    var aux = this.data.split('-');

    var data =
        new DateTime(int.parse(aux[2]), int.parse(aux[1]), int.parse(aux[0]));
    return data;
  }
}
