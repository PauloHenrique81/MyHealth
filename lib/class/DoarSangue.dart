class DoarSangue {
  String idUser;
  String idDoacao;
  String data;
  String horario;
  String local;

  DoarSangue(
      {this.idUser,
      this.idDoacao,
      this.data,
      this.horario,
      this.local});

  DateTime convertData() {
    var aux = this.data.split('-');

    var data =
        new DateTime(int.parse(aux[2]), int.parse(aux[1]), int.parse(aux[0]));
    return data;
  }
}
