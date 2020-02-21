import 'package:myhealth/class/Cirurgia.dart';
import 'package:myhealth/class/Consulta.dart';
import 'package:myhealth/class/Exame.dart';
import 'package:myhealth/class/Profissional.dart';
import 'package:myhealth/class/user.dart';

class ScreeanArguments {
  User user;
  Consulta consulta;
  Cirurgia cirurgia;
  Exame exame;
  Profissional profissional;

  ScreeanArguments(
      {this.user, this.consulta, this.cirurgia, this.exame, this.profissional});
}
