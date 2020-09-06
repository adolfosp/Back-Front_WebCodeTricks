import 'package:flutter/material.dart';
import 'package:webcodetricks/model/firestore_service.dart';
import 'package:webcodetricks/model/exercise.dart';
import 'package:webcodetricks/screen/addExercise.dart';
import 'package:webcodetricks/screen/exercise_details.dart';

class HomePageExercise extends StatelessWidget {
  const HomePageExercise({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: StreamBuilder(
          stream: FirestoreService().getExercise(),
          builder:
              (BuildContext context, AsyncSnapshot<List<Exercise>> snapshot) {
            if (snapshot.hasError || !snapshot.hasData)
              return CircularProgressIndicator();
            return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  Exercise exercise = snapshot.data[index];
                  return ListTile(
                    title: Text(exercise.titulo),
                    subtitle: Text(exercise.titulo),
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
                        builder: (_) => ExerciseDetailsPage(exercise: exercise),
                      ),
                    ),
                  );
                });
          }),
      // floatingActionButton: FloatingActionButton(
      //   child: Icon(Icons.add),
      //   onPressed: () {
      //     Navigator.push(
      //         context, MaterialPageRoute(builder: (_) => AddExercise()));
      //   },
      // ),
    );
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
}
