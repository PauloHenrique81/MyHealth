class Paciente {
  String uid;
  String nome;
  String dataDeNascimento;
  String cpf;
  String email;
  String telefone;
  String cidade;
  String tipoSanguineo;
  String medicamentosAlergicos;
  String alimentosAlergicos;
  String intolerancia;
  String dataDeCadastro;
  String senha;

  Paciente(
      {this.uid,
      this.nome,
      this.dataDeNascimento,
      this.cpf,
      this.email,
      this.telefone,
      this.cidade,
      this.tipoSanguineo,
      this.medicamentosAlergicos,
      this.alimentosAlergicos,
      this.intolerancia,
      this.senha});
}
