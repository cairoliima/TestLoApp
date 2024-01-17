class Artigo {
  final int id;
  final String text;
  final String titulo;
  final String imageUrl;
  final String? autor;
  final String url;


  Artigo({
    required this.id,
    required this.text,
     this.autor,
    required this.url,
    required this.titulo,
    required this.imageUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'author_name': autor,
      'url': url,
      'title': titulo,
      'image_url': imageUrl,
    };
  }


  factory Artigo.fromJson(Map<String, dynamic> json) {
    return Artigo(
      id: json['id'] ?? 0,
      text: json['text'] ?? '',
      autor: json['author_name'] ?? '',
      url: json['url'] ?? '',
      titulo: json['title'] ?? '',
      imageUrl: json['image_url'] ?? '',
    );
  }
}
