import 'package:myhealth/class/Cirurgia.dart';
import 'package:myhealth/class/Consulta.dart';
import 'package:myhealth/class/Exame.dart';
import 'package:myhealth/class/Imagem.dart';
import 'package:myhealth/class/Profissional.dart';
import 'package:myhealth/class/Receita.dart';
import 'package:myhealth/class/user.dart';

class ScreeanArguments {
  User user;
  Consulta consulta;
  Cirurgia cirurgia;
  Exame exame;
  Profissional profissional;
  Receita receita;
  Imagem imagem;

  ScreeanArguments(
      {this.user,
      this.consulta,
      this.cirurgia,
      this.exame,
      this.profissional,
      this.receita,
      this.imagem});
}
