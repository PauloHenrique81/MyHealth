import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myhealth/class/UserLocalModulo.dart';

class P_UserLocalModulo {
  final String uid;
  P_UserLocalModulo({this.uid});

  final CollectionReference userLocalModuloCollection =
      Firestore.instance.collection("userLocalModulo");

  List<UserLocalModulo> userLocalModuloListFromSnapshot(
      QuerySnapshot snapshot) {
    return snapshot.documents.map((d) {
      return UserLocalModulo(
          idUser: d.data['idUser'],
          modulo: d.data['modulo'],
          idItem: d.data['idItem'],
          latitude: d.data['latitude'],
          longitude: d.data['longitude'],
          nomeLocal: d.data['nomeLocal']);
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
        nomeLocal: d.data['nomeLocal'],
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

    if (snapshots.documents.length != 0) {
      var d = snapshots.documents.first;

      modulo = new UserLocalModulo(
        idUser: d.data['idUser'],
        modulo: d.data['modulo'],
        idItem: d.data['idItem'],
        latitude: d.data['latitude'],
        longitude: d.data['longitude'],
        nomeLocal: d.data['nomeLocal'],
        idUserLocalModulo: d.documentID,
      );

      return modulo;
    }

    return null;
  }

  Future cadastraUserLocalModulo(String idUser, String modulo, String idItem,
      latitude, longitude, String nomeLocal) async {
    try {
      var idUserLocalModulo = await userLocalModuloCollection.add({
        'idUser': idUser,
        'modulo': modulo,
        'idItem': idItem,
        'latitude': latitude,
        'longitude': longitude,
        'nomeLocal': nomeLocal
      });
      return idUserLocalModulo.documentID;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future atualizarUserLocalModulo(
      String iduserLocalModulo, latitude, longitude, String nomeLocal) {
    try {
      userLocalModuloCollection.document(iduserLocalModulo).updateData({
        'latitude': latitude,
        'longitude': longitude,
        'nomeLocal': nomeLocal
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
