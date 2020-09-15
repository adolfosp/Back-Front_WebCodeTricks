import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webcodetricks/model/firestore_service.dart';
import 'package:webcodetricks/model/exercise.dart';
import 'package:webcodetricks/screen/addExercise.dart';
import 'package:webcodetricks/screen/exercise_details.dart';

var resultado = "";
TextEditingController _textController = TextEditingController();

class HomePageExercise extends StatefulWidget {
  HomePageExercise({Key key,}) : super(key: key);
  



  @override
  _HomePageExerciseState createState() => _HomePageExerciseState();
}

@override
void initState() {
  _textController.text = resultado;
}

class _HomePageExerciseState extends State<HomePageExercise> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: <Widget>[
        Column(
                  children: <Widget>[Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
                textCapitalization: TextCapitalization.sentences,
                controller: _textController,
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                    hintText: "Pesquisar por TAG",
                    hintStyle: TextStyle(color: Colors.black),
                    icon: Icon(
                      Icons.search,
                      color: Colors.black,
                    ),
                    border: InputBorder.none),
                onChanged: (value) {
                  FirestoreService().getExerciseWhere(value);
                  setState(() {
                    resultado = value;
                  });
                }),
          ),
          ]
        ),
        Expanded(
          child: StreamBuilder(
              stream: FirestoreService().getExerciseWhere(resultado),
              builder: (BuildContext context,
                  AsyncSnapshot<List<Exercise>> snapshot) {
                if (snapshot.hasError || !snapshot.hasData)
                  return CircularProgressIndicator();
                return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      Exercise exercise = snapshot.data[index];

                      return Container(
                        child: Card(
                         
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: ListTile(
                          
                            leading: Image(
                                image: AssetImage(
                                    'images/' + exercise.tag + '.png')),
                            contentPadding: EdgeInsets.all(20),
                            title: Text(
                              exercise.titulo,
                              style: GoogleFonts.robotoCondensed(fontSize: 20),
                              textAlign: TextAlign.center,
                            ),
                            subtitle: Text("Autor: " + exercise.autor),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                    color: Colors.red,
                                    icon: Icon(Icons.delete),
                                    onPressed: () =>
                                        _deleteExercise(context, exercise.id)),
                                IconButton(
                                    color: Colors.blue,
                                    icon: Icon(Icons.edit),
                                    onPressed: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              AddExercise(exercise: exercise),
                                        ))),
                              ],
                            ),
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    ExerciseDetailsPage(exercise: exercise),
                              ),
                            ),
                          ),
                        ),
                        decoration: new BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(.5),
                              blurRadius: 20.0, // soften the shadow
                              spreadRadius: 0.0, //extend the shadow
                              offset: Offset(
                                2.0, // Move to right 10  horizontally
                                2.0, // Move to bottom 10 Vertically
                              ),
                            )
                          ],
                        ),
                      );
                    });
              }),
        ),
      ]),
      // floatingActionButton: FloatingActionButton(
      //   child: Icon(Icons.add),
      //   onPressed: () {
      //     Navigator.push(
      //         context, MaterialPageRoute(builder: (_) => AddExercise()));
      //   },
      // ),
    );
  }
}

void _deleteExercise(BuildContext context, String id) async {
  if (await _showConfirmationDialog(context)) {
    try {
      await FirestoreService().deleteNode(id);
    } catch (e) {
      print(e);
    }
  }
}

Future<bool> _showConfirmationDialog(BuildContext context) async {
  return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => AlertDialog(
            content: Text("Você tem certeza que deseja excluir ?"),
            actions: <Widget>[
              FlatButton(
                color: Colors.red,
                child: Text("Excluir"),
                onPressed: () => Navigator.pop(context, true),
              ),
              FlatButton(
                color: Colors.red,
                child: Text("Não"),
                onPressed: () => Navigator.pop(context, false),
              )
            ],
          ));
}
