import 'package:flutter/material.dart';
import 'package:webcodetricks/model/firestore_service.dart';
import 'package:webcodetricks/model/exercise.dart';
import 'package:webcodetricks/screen/exercise_details.dart';

class HomePageExercise extends StatelessWidget {
  const HomePageExercise({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ExerciseDetailsPage(exercise: exercise),
                      ),
                    ),
                  );
                });
          }),
    );
  }
}
