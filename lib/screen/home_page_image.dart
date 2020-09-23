import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webcodetricks/model/firestore_service.dart';
import 'package:webcodetricks/model/image.dart';
import 'package:webcodetricks/screen/exercise_details.dart';

var resultado = "";
var autor = "";

TextEditingController _textController = TextEditingController();

class HomePageImage extends StatefulWidget {
  HomePageImage({Key key, this.usuarioAutor}) : super(key: key);
  String usuarioAutor;

  @override
  _HomePageImageState createState() => _HomePageImageState();
}

@override
void initState() {
  _textController.text = resultado;
}

class _HomePageImageState extends State<HomePageImage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: <Widget>[
        Expanded(
          child: StreamBuilder(
              stream: FirestoreService().getImageWhere(widget.usuarioAutor),
              builder:
                  (BuildContext context, AsyncSnapshot<List<Images>> snapshot) {
                if (snapshot.hasError || !snapshot.hasData)
                  return CircularProgressIndicator();
                return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      Images images = snapshot.data[index];

                      return Container(
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: ListTile(
                              leading: Image.network(images.url),
                              contentPadding: EdgeInsets.all(20),
                              title: Text(
                                images.usuario,
                                style:
                                    GoogleFonts.robotoCondensed(fontSize: 20),
                                textAlign: TextAlign.center,
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                      color: Colors.red,
                                      icon: Icon(Icons.delete),
                                      onPressed: () =>
                                          _deleteImage(context, images.id)),
                                ],
                              ),
                              onTap: () {}),
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

void _deleteImage(BuildContext context, String id) async {
  if (await _showConfirmationDialog(context)) {
    try {
      await FirestoreService().deleteNodeImage(id);
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
