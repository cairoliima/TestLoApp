class Citacao {
  final int id;
  final String text;
  final String autor;


  Citacao({
    required this.id,
    required this.text,
    required this.autor,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'author_name': autor,
    };
  }

  factory Citacao.fromJson(Map<String, dynamic> json) {
    return Citacao(
      id: json['id'] ?? 0,
      text: json['text'] ?? '',
      autor: json['author'] ?? '',
    );
  }
}
