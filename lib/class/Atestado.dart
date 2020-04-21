class Atestado {
  String idUser;
  String idAtestado;
  String medico;
  String data;
  String quantidadeDeDias;
  String motivo;

  Atestado(
      {this.idUser,
      this.idAtestado,
      this.medico,
      this.data,
      this.quantidadeDeDias,
      this.motivo});

  DateTime convertData() {
    var aux = this.data.split('-');

    var data =
        new DateTime(int.parse(aux[2]), int.parse(aux[1]), int.parse(aux[0]));
    return data;
  }
}
