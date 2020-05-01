

class PacienteConsulta {

  String nome;
  String cpf;
  String data;
  String hora;
  String local;

  PacienteConsulta({this.nome, this.cpf, this.data, this.hora, this.local});

   DateTime convertData() {
    var aux = this.data.split('-');

    var data =
        new DateTime(int.parse(aux[2]), int.parse(aux[1]), int.parse(aux[0]));
    return data;
  }
}