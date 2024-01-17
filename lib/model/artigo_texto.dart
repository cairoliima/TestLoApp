class artTexto {
  final int id;
  final String text;
  final String autor;
  final String titulo;
  final String textoCompleto;
  final String image;
  final String imageUrl;

  artTexto({
    required this.id,
    required this.titulo,
    required this.textoCompleto,
    required this.image,
    required this.imageUrl,
    required this.text,
    required this.autor,
  });

  factory artTexto.fromJson(Map<String, dynamic> json) {
    return artTexto(
      id: json['id'] ?? 0,
      text: json['text'] ?? '',
      titulo: json['title'] ?? '',
      textoCompleto: json['full_text'] ?? '',
      autor: json['author_name'] ?? '',
      image: json['image'] ?? '',
      imageUrl: json['image_url'] ?? '',

    );
  }
}
