import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myhealth/class/Vacina_x_User.dart';

class P_Vacina_x_User {
  final String uid;
  P_Vacina_x_User({this.uid});

  final CollectionReference vacinaCollection =
      Firestore.instance.collection("vacinas_x_user");

  List<VacinaUser> vacinaUserListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return VacinaUser(
          doc.data['codigoDaVacina'], doc.data['userID'], doc.data['data']);
    }).toList();
  }

  Future existeVacinaUser(String idUser) async {
    var snapshots = await vacinaCollection
        .where("userID", isEqualTo: idUser)
        .getDocuments();
    return snapshots.documents.isNotEmpty;
  }

  Future cadastraVacinaUser(String codigoDaVacina, String userID, String data) {
    vacinaCollection.document().setData(
        {'codigoDaVacina': codigoDaVacina, 'userID': userID, 'data': data});
  }

  Future listaDeVacinaUser(String userID) async {
    VacinaUser vacina_x_user;
    List<VacinaUser> vacinas_x_users = new List<VacinaUser>();

    var snapshots = await vacinaCollection
        .where("userID", isEqualTo: userID)
        .getDocuments();

    snapshots.documents.forEach((d) {
      vacina_x_user = new VacinaUser(
          d.data['codigoDaVacina'], d.data['userID'], d.data['data']);
      vacinas_x_users.add(vacina_x_user);
    });

    return vacinas_x_users;
  }

  Future atualizarVacinaUser(
      String codigoDaVacina, String userID, String data) {
    try {
      vacinaCollection
          .document(userID)
          .updateData({'codigoDaVacina': codigoDaVacina, 'data': data});
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Stream<List<VacinaUser>> get allvacinas {
    return vacinaCollection.snapshots().map(vacinaUserListFromSnapshot);
  }
}
