import 'package:firebase_storage/firebase_storage.dart';

class Exercise {
  final String titulo;
  final String pergunta;
  final String resposta;
  final String autor;
  final String id;
  final String url;

  Exercise(
      {this.titulo,
      this.id,
      this.autor,
      this.pergunta,
      this.resposta,
      this.url});

  Exercise.fromMap(Map<String, dynamic> data, String id)
      : titulo = data['titulo'],
        id = id,
        pergunta = data['pergunta'],
        resposta = data['resposta'],
        autor = data['autor'],
        url = data['url'];

  Map<String, dynamic> toMap() {
    return {
      "titulo": titulo,
      "pergunta": pergunta,
      "resposta": resposta,
      "autor": autor,
      "url": url,
    };
  }
}
