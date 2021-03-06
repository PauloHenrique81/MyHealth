import 'package:myhealth/Helper/Vacina_Help.dart';
import 'package:myhealth/class/Atestado.dart';
import 'package:myhealth/class/Cirurgia.dart';
import 'package:myhealth/class/Consulta.dart';
import 'package:myhealth/class/DoarSangue.dart';
import 'package:myhealth/class/Exame.dart';
import 'package:myhealth/class/Imagem.dart';
import 'package:myhealth/class/Profissional.dart';
import 'package:myhealth/class/Receita.dart';
import 'package:myhealth/class/SolicitarConsulta.dart';
import 'package:myhealth/class/UserLocalModulo.dart';
import 'package:myhealth/class/Vacina_x_User.dart';
import 'package:myhealth/class/user.dart';

class ScreeanArguments {
  User user;
  Consulta consulta;
  Cirurgia cirurgia;
  Exame exame;
  Profissional profissional;
  Receita receita;
  Imagem imagem;
  Vacina vacina;
  TiposDeVacinas tipoDeVacina;
  VacinaUser vacinaUser;
  List<VacinaUser> listVacinaUser;
  String string1;
  String string2;
  bool booleam;
  Atestado atestado;
  UserLocalModulo userLocalModulo;
  DoarSangue doacao;
  SolicitarConsulta solicitarConsulta;

  ScreeanArguments({
    this.user,
    this.consulta,
    this.cirurgia,
    this.exame,
    this.profissional,
    this.receita,
    this.imagem,
    this.vacina,
    this.tipoDeVacina,
    this.vacinaUser,
    this.listVacinaUser,
    this.string1,
    this.string2,
    this.booleam,
    this.atestado,
    this.userLocalModulo,
    this.doacao,
    this.solicitarConsulta
  });
}
