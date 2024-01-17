import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:testelojongapp/model/video.dart';

Future<List<Video>> fetchVideos(String userToken, int page) async {
  final dio = Dio();
  (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (client) {
    client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  };

  try {
    final response = await dio.get(
      'https://applojong.com/api/videos',
      options: Options(
        headers: {'Authorization': 'Bearer $userToken'},
      ),
      queryParameters: {'page': page},
    );

    if (response.statusCode == 200) {
      try {

        if (response.data != null && response.data is List) {

          final List<Video> videos = (response.data as List)
              .map((videoData) => Video(
            id: videoData['id'] ?? 0,
            name: videoData['name'] ?? '',
            description: videoData['description'] ?? '',
            file: videoData['file'] ?? '',
            url: videoData['url'] ?? '',
            url2: videoData['url2'] ?? '',
            awsUrl: videoData['aws_url'] ?? '',
            image: videoData['image'] ?? '',
            imageUrl: videoData['image_url'] ?? '',
          ))
              .toList();

          return videos;
        } else {
          throw Exception('Resposta vazia ou em formato inválido');
        }
      } catch (error) {
        throw Exception('Erro ao processar dados da resposta');
      }
    } else {
      throw Exception('Falha ao carregar vídeos. Código de status: ${response.statusCode}');
    }
  } catch (error) {
    throw Exception('Erro na requisição');
  }
}