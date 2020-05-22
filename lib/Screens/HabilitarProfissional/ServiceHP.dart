import 'package:myhealth/Persistencia/P_Profissional.dart';
import 'package:myhealth/class/Profissional.dart';

class ServicesHP {
  static Future<List<Profissional>> getProfissionaisUsers() async {
    try {
      P_Profissional conectionDB = new P_Profissional();

      List<Profissional> list = new List<Profissional>();

      list = await conectionDB.listaDeProfissionaisUser();

      return list;
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
