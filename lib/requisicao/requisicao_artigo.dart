import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:testelojongapp/model/artigo.dart';

Future<List<Artigo>> buscarArtigos(String userToken, int page) async {
  final dio = Dio();
  (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (client) {
    client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  };

  try {
    final response = await dio.get(
      'https://applojong.com/api/articles2',
      options: Options(
        headers: {'Authorization': 'Bearer $userToken'},
      ),
      queryParameters: {'page': page},
    );

    if (response.statusCode == 200) {
      if (response.data != null && response.data is Map<String, dynamic>) {
        final List<dynamic> artigosData = response.data['list'];

        final List<Artigo> artigos = artigosData
            .map((artigoData) => Artigo(
          id: artigoData['id'] ?? 0,
          text: artigoData['text'] ?? '',
          titulo: artigoData['title'] ?? '',
          imageUrl: artigoData['image_url'] ?? '',
          url: artigoData['url'] ?? '',
          autor: artigoData['author_name'] ?? '',
        ))
            .toList();

        return artigos;
      } else {
        throw Exception('Resposta em formato inválido - lista de artigos ausente');
      }
    } else {
      throw Exception('Falha ao carregar artigos. Código de status: ${response.statusCode}');
    }
  } catch (error) {
    throw Exception('Erro na requisição');
  }
}