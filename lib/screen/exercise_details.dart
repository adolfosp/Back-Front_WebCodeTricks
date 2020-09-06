import 'package:flutter/material.dart';
import 'package:webcodetricks/model/exercise.dart';

class ExerciseDetailsPage extends StatelessWidget {
  const ExerciseDetailsPage({Key key, @required this.exercise})
      : super(key: key);

  final Exercise exercise;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("DETAILS"),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              exercise.titulo,
            ),
            Text(
              exercise.pergunta,
            ),
            Text(
              exercise.resposta,
            ),
            Text(
              exercise.autor,
            ),
            Text(
              exercise.tag,
            ),
            Image.network(exercise.url),
            const SizedBox(
              height: 20.0,
            ),
          ],
        ),
      ),
    );
  }
}
