class Images {
  final String id;
  final String url;
  final int pos;
  final int x;
  final int y;
  final String usuario;

  Images({this.id, this.url, this.pos, this.x, this.y, this.usuario});

  Images.fromMap(Map<String, dynamic> data, String id)
      : url = data['image'],
        id = id,
        pos = data['pos'],
        x = data['x'],
        y = data['y'],
        usuario = data['usuario'];

  Map<String, dynamic> toMap() {
    return {
      "image": url,
      "pos": pos,
      "x": x,
      "y": y,
      "usuario": usuario,
    };
  }
}
