

import 'package:firebase_storage/firebase_storage.dart';

class P_Images {


  String modulo; 
  String usuario; 
  String idItem;
  P_Images(this.modulo, this.usuario, this.idItem);
  
  final FirebaseStorage _storage =
      FirebaseStorage(storageBucket: 'gs://myhealth-2560e.appspot.com');


  // Future<List<String>> getAllImagesFromAFolder() {

  //    final StorageReference storageRef =
  //       _storage.ref().child('Gallery').child('Images');
  //   storageRef.listAll().then((result) {
  //     print("result is $result");

  //     _uploadTask = _storage.ref().child('filePath').
  //   });
  //}
}