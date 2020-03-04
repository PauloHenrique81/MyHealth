import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myhealth/Persistencia/P_Imagem.dart';
import 'package:myhealth/Persistencia/P_Receita.dart';
import 'package:myhealth/Service/ScreeanArguments.dart';
import 'package:myhealth/class/Imagem.dart';
import 'package:myhealth/class/Receita.dart';
import 'package:myhealth/class/user.dart';

/// Widget to capture and crop the image
class ImageCapture extends StatefulWidget {
  createState() => _ImageCaptureState();
  Imagem imagem;
  User user;

  ImageCapture({this.imagem, this.user});
}

class _ImageCaptureState extends State<ImageCapture> {
  /// Active image file
  File _imageFile;

  StorageUploadTask _uploadTask;

  P_Imagem bd = new P_Imagem();
  P_Receita receitaBD = new P_Receita();

  /// Select an image via gallery or camera
  Future<void> _pickImage(ImageSource source) async {
    File selected = await ImagePicker.pickImage(source: source);

    setState(() {
      _imageFile = selected;
    });
  }

  salvarDadosDaImagem() async {
    var url =
        await Uploader.storage.ref().child(Uploader.filePath).getDownloadURL();
    if (url != null)
      bd.cadastraImagem(widget.imagem.idUser, widget.imagem.modulo,
          widget.imagem.idItem, url);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            IconButton(
              icon: Icon(
                Icons.photo_camera,
                size: 30,
              ),
              onPressed: () => _pickImage(ImageSource.camera),
              color: Colors.blue,
            ),
            IconButton(
              icon: Icon(
                Icons.photo_library,
                size: 30,
              ),
              onPressed: () => _pickImage(ImageSource.gallery),
              color: Colors.pink,
            ),
            IconButton(
              icon: Icon(
                Icons.beenhere,
                color: Colors.green,
                size: 30,
              ),
              onPressed: () async {
                salvarDadosDaImagem();
                Navigator.pop(context);
              },
              color: Colors.pink,
            ),
          ],
        ),
      ),
      body: ListView(
        children: <Widget>[
          if (_imageFile != null) ...[
            Container(
                padding: EdgeInsets.all(32), child: Image.file(_imageFile)),
            Padding(
              padding: const EdgeInsets.all(32),
              child: Uploader(
                file: _imageFile,
                imagem: widget.imagem,
              ),
            )
          ]
        ],
      ),
    );
  }

  void _mostrarDetalhesDaReceita({Receita receita, User user}) {
    ScreeanArguments screeanArguments =
        new ScreeanArguments(user: user, receita: receita);
    Navigator.of(context)
        .pushReplacementNamed('EdicaoDeReceita', arguments: screeanArguments);
  }
}

class Uploader extends StatefulWidget {
  final File file;
  static var imgDetail;
  static String filePath;
  static final FirebaseStorage storage =
      FirebaseStorage(storageBucket: 'gs://flutter-78e41.appspot.com');

  Imagem imagem;
  Uploader({Key key, this.file, this.imagem}) : super(key: key);

  createState() => _UploaderState();
}

class _UploaderState extends State<Uploader> {
  StorageUploadTask _uploadTask;

  _startUpload() {
    Uploader.filePath = 'imagens/${DateTime.now()}.png';

    setState(() {
      Uploader.imgDetail = _uploadTask =
          Uploader.storage.ref().child(Uploader.filePath).putFile(widget.file);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_uploadTask != null) {
      return StreamBuilder<StorageTaskEvent>(
          stream: _uploadTask.events,
          builder: (context, snapshot) {
            var event = snapshot?.data?.snapshot;

            double progressPercent = event != null
                ? event.bytesTransferred / event.totalByteCount
                : 0;

            return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (_uploadTask.isComplete)
                    Text('🎉🎉🎉',
                        style: TextStyle(
                            color: Colors.greenAccent,
                            height: 2,
                            fontSize: 15)),
                  if (_uploadTask.isPaused)
                    FlatButton(
                      child: Icon(Icons.play_arrow, size: 50),
                      onPressed: _uploadTask.resume,
                    ),
                  if (_uploadTask.isInProgress)
                    FlatButton(
                      child: Icon(Icons.pause, size: 50),
                      onPressed: _uploadTask.pause,
                    ),
                  LinearProgressIndicator(value: progressPercent),
                  Text(
                    '${(progressPercent * 100).toStringAsFixed(2)} % ',
                    style: TextStyle(fontSize: 20),
                  ),
                ]);
          });
    } else {
      return FlatButton.icon(
          color: Colors.blue,
          label: Text('Salvar imagem'),
          icon: Icon(Icons.cloud_upload),
          onPressed: _startUpload);
    }
  }
}
