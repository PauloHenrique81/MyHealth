import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myhealth/class/UserLocalModulo.dart';

class P_UserLocalModulo {
  final String uid;
  P_UserLocalModulo({this.uid});

  final CollectionReference userLocalModuloCollection =
      Firestore.instance.collection("userLocalModulo");

  List<UserLocalModulo> userLocalModuloListFromSnapshot(
      QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return UserLocalModulo(
          idUser: doc.data['idUser'],
          modulo: doc.data['modulo'],
          idItem: doc.data['idItem'],
          latitude: doc.data['latitude'],
          longitude: doc.data['longitude']);
    }).toList();
  }

  Future listaDeUserLocalModulo(String idUser) async {
    UserLocalModulo modulo = new UserLocalModulo();
    List<UserLocalModulo> modulos = new List<UserLocalModulo>();

    var snapshots = await userLocalModuloCollection
        .where("idUser", isEqualTo: idUser)
        .getDocuments();
    snapshots.documents.forEach((d) {
      modulo = new UserLocalModulo(
        idUser: d.data['idUser'],
        modulo: d.data['modulo'],
        idItem: d.data['idItem'],
        latitude: d.data['latitude'],
        longitude: d.data['longitude'],
        idUserLocalModulo: d.documentID,
      );
      modulos.add(modulo);
    });

    return modulos;
  }

  Future getUserLocalModulo(String userId, String idItem) async {
    UserLocalModulo modulo = new UserLocalModulo();

    var snapshots = await userLocalModuloCollection
        .where("idUser", isEqualTo: userId)
        .where("idItem", isEqualTo: idItem)
        .getDocuments();
    var d = snapshots.documents.first;

    modulo = new UserLocalModulo(
        idUser: d.data['idUser'],
        modulo: d.data['modulo'],
        idItem: d.data['idItem'],
        latitude: d.data['latitude'],
        longitude: d.data['longitude']);

    return modulo;
  }

  Future cadastraUserLocalModulo(
      String idUser, String modulo, String idItem, latitude, longitude) async {
    try {
      var idUserLocalModulo = await userLocalModuloCollection.add({
        'idUser': idUser,
        'modulo': modulo,
        'idItem': idItem,
        'latitude': latitude,
        'longitude': longitude
      });

      return idUserLocalModulo.documentID;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future atualizarUserLocalModulo(String idUser, String iduserLocalModulo,
      String modulo, String idItem, latitude, longitude) {
    try {
      userLocalModuloCollection.document(iduserLocalModulo).updateData({
        'idUser': idUser,
        'modulo': modulo,
        'idItem': idItem,
        'latitude': latitude,
        'longitude': longitude
      });
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Stream<List<UserLocalModulo>> get allUserLocalModulo {
    return userLocalModuloCollection
        .snapshots()
        .map(userLocalModuloListFromSnapshot);
  }
}
