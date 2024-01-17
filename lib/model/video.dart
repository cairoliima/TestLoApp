class Video {
  final int id;
  final String name;
  final String description;
  final String? file;
  final String url;
  final String url2;
  final String awsUrl;
  final String image;
  final String imageUrl;


  Video({
    required this.id,
    required this.name,
    required this.description,
    this.file,
    required this.url,
    required this.url2,
    required this.awsUrl,
    required this.image,
    required this.imageUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'url': url,
      'file': file,
      'url2': url2,
      'awsUrl': awsUrl,
      'image': image,
      'image_url': imageUrl,
    };
  }

  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      file: json['file'],
      url: json['url'] ?? '',
      url2: json['url2'] ?? '',
      awsUrl: json['aws_url'] ?? '',
      image: json['image'] ?? '',
      imageUrl: json['image_url'] ?? '',
    );
  }
}
