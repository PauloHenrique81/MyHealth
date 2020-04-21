class Receita {
  String idUser;
  String idReceita;
  String medico;
  String data;
  String descricao;

  Receita(
      {this.idUser, this.idReceita, this.medico, this.data, this.descricao});

  DateTime convertData() {
    var aux = this.data.split('-');

    var data =
        new DateTime(int.parse(aux[2]), int.parse(aux[1]), int.parse(aux[0]));
    return data;
  }
}
