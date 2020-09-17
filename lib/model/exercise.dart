class Exercise {
  final String titulo;
  final String pergunta;
  final String resposta;
  final String autor;
  final String id;
  final String url;
  final String tag;

  Exercise(
      {this.titulo,
      this.id,
      this.autor,
      this.pergunta,
      this.resposta,
      this.url,
      this.tag});

  Exercise.fromMap(Map<String, dynamic> data, String id)
      : titulo = data['titulo'],
        id = id,
        pergunta = data['pergunta'],
        resposta = data['resposta'],
        autor = data['autor'],
        url = data['url'],
        tag = data['tag'];

  Map<String, dynamic> toMap() {
    return {
      "titulo": titulo,
      "pergunta": pergunta,
      "resposta": resposta,
      "autor": autor,
      "url": url,
      "tag": tag,
    };
  }

}
