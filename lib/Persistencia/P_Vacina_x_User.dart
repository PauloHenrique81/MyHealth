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

  Future cadastraVacinaUser(String codigoDaVacina, String userID, String data,
      {String local}) {
    vacinaCollection.document().setData({
      'codigoDaVacina': codigoDaVacina,
      'userID': userID,
      'data': data,
      'local': local ?? ''
    });
  }

  Future listaDeVacinaUser(String userID) async {
    VacinaUser vacina_x_user;
    List<VacinaUser> vacinas_x_users = new List<VacinaUser>();

    var snapshots = await vacinaCollection
        .where("userID", isEqualTo: userID)
        .getDocuments();

    snapshots.documents.forEach((d) {
      vacina_x_user = new VacinaUser(
          d.data['codigoDaVacina'], d.data['userID'], d.data['data'],
          local: d.data['local']);
      vacinas_x_users.add(vacina_x_user);
    });

    return vacinas_x_users;
  }

  void atualizarVacinaUser(String codigoDaVacina, String userID, String data,
      {String local}) {
    try {
      vacinaCollection.document(userID).updateData({
        'codigoDaVacina': codigoDaVacina,
        'data': data,
        'local': local ?? ''
      });
    } catch (e) {
      print(e.toString());
    }
  }

  void excluirVacinaUser(String codigoDaVacina, String userID) {
    try {
      vacinaCollection
          .where("userID", isEqualTo: userID)
          .where("codigoDaVacina", isEqualTo: codigoDaVacina)
          .getDocuments()
          .then((val) {
        for (var item in val.documents) {
          item.reference.delete();
        }
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Stream<List<VacinaUser>> get allvacinas {
    return vacinaCollection.snapshots().map(vacinaUserListFromSnapshot);
  }
}
