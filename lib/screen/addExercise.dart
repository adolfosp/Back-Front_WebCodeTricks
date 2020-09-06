import 'dart:async';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/material.dart';
import 'package:webcodetricks/model/exercise.dart';
import 'package:webcodetricks/model/firestore_service.dart';
import 'package:webcodetricks/screen/home_screen.dart';
import 'package:image_picker/image_picker.dart';

class AddExercise extends StatefulWidget {
  final Exercise exercise;

  AddExercise({Key key, this.exercise}) : super(key: key);

  @override
  _AddExerciseState createState() => _AddExerciseState();
}

class _AddExerciseState extends State<AddExercise> {
  File _image;

  final StorageReference storageRef = FirebaseStorage.instance.ref();

  Future<String> uploadImage(imageFile) async {
    StorageUploadTask uploadTask = storageRef
        .child(DateTime.now().millisecondsSinceEpoch.toString())
        .putFile(imageFile);
    StorageTaskSnapshot storageSnap = await uploadTask.onComplete;
    String downloadURL = await storageSnap.ref.getDownloadURL();
    return downloadURL;
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

  Future getImageFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile?.path == null) return;

    final image = File(pickedFile.path);

    setState(() {
      _image = image;
    });
  }

  GlobalKey<FormState> _key = GlobalKey<FormState>();

  TextEditingController textController = TextEditingController();

  TextEditingController _tituloController;
  TextEditingController _perguntaController;
  TextEditingController _respostaController;
  TextEditingController _autorController;

  FocusNode _perguntaNode;
  FocusNode _respostaNode;
  FocusNode _autorNode;
  bool _loading;
  double _progressValue;

  @override
  void initState() {
    super.initState();
    _loading = false;
    _progressValue = 0.0;

    _tituloController = TextEditingController(
        text: isEditExercise ? widget.exercise.titulo : '');
    _perguntaController = TextEditingController(
        text: isEditExercise ? widget.exercise.pergunta : '');
    _respostaController = TextEditingController(
        text: isEditExercise ? widget.exercise.resposta : '');
    _autorController = TextEditingController(
        text: isEditExercise ? widget.exercise.autor : '');
    _perguntaNode = FocusNode();
    _respostaNode = FocusNode();
    _autorNode = FocusNode();
  }

  get isEditExercise => widget.exercise != null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title:
            Text(widget.exercise != null ? 'Update Exercise' : 'Add Exercise'),
        actions: <Widget>[
          // action button
          IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => HomeScreen()));
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _key,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                maxLines: 2,
                textInputAction: TextInputAction.next,
                onEditingComplete: () {
                  FocusScope.of(context).requestFocus(_perguntaNode);
                },
                controller: _tituloController,
                validator: (value1) {
                  if (value1 == null || value1.isEmpty) {
                    return "Título obrigatório";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: "Título do Exercício",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              TextFormField(
                maxLines: 5,
                textInputAction: TextInputAction.next,
                onEditingComplete: () {
                  FocusScope.of(context).requestFocus(_respostaNode);
                },
                focusNode: _perguntaNode,
                controller: _perguntaController,
                validator: (value2) {
                  if (value2 == null || value2.isEmpty) {
                    return "Pergunta obrigatório";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: "Pergunta",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              TextFormField(
                maxLines: 5,
                textInputAction: TextInputAction.next,
                onEditingComplete: () {
                  FocusScope.of(context).requestFocus(_autorNode);
                },
                focusNode: _respostaNode,
                controller: _respostaController,
                validator: (value3) {
                  if (value3 == null || value3.isEmpty) {
                    return "Resposta obrigatório";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: "Resposta",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              TextFormField(
                textInputAction: TextInputAction.next,
                onEditingComplete: () {
                  FocusScope.of(context).requestFocus();
                },
                focusNode: _autorNode,
                controller: _autorController,
                validator: (value4) {
                  if (value4 == null || value4.isEmpty) {
                    return "Autor obrigatório";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: "Autor da pergunta",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(
                height: 10.0,
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
                  child: _image == null
                      ? Text("Nenhuma imagem selecionada")
                      : Image.file(_image),
                ),
              ),
              const SizedBox(
                height: 30.0,
              ),
              Row(
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
              const SizedBox(
                height: 20.0,
              ),
              Center(
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
                            widget.exercise != null ? "Alterar" : "Salvar",
                            style: TextStyle(fontSize: 25.0),
                          ),
                          onPressed: () async {
                            if (_key.currentState.validate()) {
                              setState(() {
                                _loading = !_loading;

                                _updateProgress();
                              });

                              try {
                                if (isEditExercise) {
                                  Exercise exercise = Exercise(
                                      titulo: _tituloController.text,
                                      pergunta: _perguntaController.text,
                                      resposta: _respostaController.text,
                                      autor: _autorController.text,
                                      id: widget.exercise.id);

                                  await FirestoreService()
                                      .updateExercise(exercise);
                                } else {
                                  String myUrl = await uploadImage(_image);

                                  Exercise exercise = Exercise(
                                    titulo: _tituloController.text,
                                    pergunta: _perguntaController.text,
                                    resposta: _respostaController.text,
                                    autor: _autorController.text,
                                    url: myUrl,
                                  );
                                  await FirestoreService()
                                      .addExercise(exercise);
                                }

                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (context) => HomeScreen()));
                              } catch (e) {
                                print(e);
                              }
                            }
                          },
                        ),
                      ),
                    ]),
              ),
            ],
          ),
        ),
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
