import 'dart:async';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:webcodetricks/model/firestore_service.dart';
import 'package:webcodetricks/model/image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:webcodetricks/screen/home_page_image.dart';
import 'package:webcodetricks/screen/home_screen.dart';

class AddImage extends StatefulWidget {
  final Image image;
  String usuarioF;

  AddImage({Key key, this.image, this.usuarioF}) : super(key: key);

  @override
  _AddImageState createState() => _AddImageState();
}

class _AddImageState extends State<AddImage> {
  File _image;
  bool _loading;
  double _progressValue;
  final StorageReference storageRef = FirebaseStorage.instance.ref();

  Future<String> uploadImage(imageFile) async {
    StorageUploadTask uploadTask = storageRef
        .child(DateTime.now().millisecondsSinceEpoch.toString())
        .putFile(imageFile);
    StorageTaskSnapshot storageSnap = await uploadTask.onComplete;
    String downloadURL = await storageSnap.ref.getDownloadURL();
    return downloadURL;
  }

  Future getImageFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile?.path == null) return;

    final image = File(pickedFile.path);

    setState(() {
      _image = image;
    });
  }

  Future getImageFromCamera() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    if (pickedFile?.path == null) return;

    final image = File(pickedFile.path);

    setState(() {
      _image = image;
    });
  }

  @override
  void initState() {
    super.initState();
    _loading = false;
    _progressValue = 0.0;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    FloatingActionButton(
                      heroTag: "btn1",
                      onPressed: getImageFromCamera,
                      tooltip: 'Capturar Imagem',
                      child: Icon(Icons.add_a_photo),
                    ),
                    FloatingActionButton(
                      heroTag: "btn2",
                      onPressed: getImageFromGallery,
                      tooltip: 'Capturar Imagem',
                      child: Icon(Icons.wallpaper),
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey[200],
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(7),
                  boxShadow: [
                    new BoxShadow(
                      color: Colors.grey,
                      offset: new Offset(0.0, 0.0),
                    ),
                  ],
                ),
                width: MediaQuery.of(context).size.width,
                height: 200.0,
                child: Center(
                  child: _image != null
                      ? Image.file(_image)
                      : Text(
                          "Nenhuma imagem selecionada",
                          textAlign: TextAlign.center,
                        ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: _loading
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            CircularProgressIndicator(
                              value: _progressValue,
                            ),
                            Text('${(_progressValue * 100).round()}%'),
                          ],
                        )
                      : Text(""),
                ),
              ),
              Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 50.0,
                        width: 150.0,
                        child: RaisedButton(
                            color: Theme.of(context).primaryColor,
                            textColor: Colors.white,
                            child: Text(
                              "Salvar",
                              style: TextStyle(fontSize: 25.0),
                            ),
                            onPressed: () async {
                              try {
                                setState(() {
                                  _loading = !_loading;

                                  _updateProgress();
                                });

                                String myUrl;
                                myUrl = await uploadImage(_image);
                                Images images = Images(
                                    url: myUrl,
                                    pos: 1,
                                    x: 1,
                                    y: 1,
                                    usuario: widget.usuarioF);
                                await FirestoreService().addImage(images);

                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (context) => HomePageImage(
                                            usuarioAutor: widget.usuarioF)));
                              } catch (e) {
                                print(e);
                              }
                            }),
                      ),
                    ]),
              ),
            ]),
      ),
    );
  }

  void _updateProgress() {
    const oneSec = const Duration(seconds: 1);
    new Timer.periodic(oneSec, (Timer t) {
      setState(() {
        _progressValue += 0.2;
        // we "finish" downloading here
        if (_progressValue.toStringAsFixed(1) == '1.0') {
          _loading = false;
          t.cancel();
          _progressValue:
          0.0;
          return;
        }
      });
    });
  }
}
