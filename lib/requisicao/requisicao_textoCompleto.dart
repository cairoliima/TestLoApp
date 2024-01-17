import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:testelojongapp/model/artigo_texto.dart';

Future<List<artTexto>> buscarArtTexto(String userToken, int idArtigo) async {
  final dio = Dio();
  (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (client) {
    client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  };

  try {
    final response = await dio.get(
      'https://applojong.com/api/article-content',
      options: Options(
        headers: {'Authorization': 'Bearer $userToken'},
      ),
      queryParameters: {'articleid': idArtigo},
    );

    if (response.statusCode == 200) {
      final dynamic responseData = response.data;

      if (responseData != null && responseData is Map<String, dynamic>) {
        final artTexto artigoCompleto = artTexto(
          id: responseData['id'] ?? 0,
          titulo: responseData['title'] ?? '',
          textoCompleto: responseData['full_text'] ?? '',
          image: responseData['image'] ?? '',
          imageUrl: responseData['image_url'] ?? '',
          text: responseData['text'] ?? '',
          autor: responseData['author_name'] ?? '',
        );
        return [artigoCompleto];
      } else {
        print('Resposta da API: $response');
        throw Exception('Resposta em formato inválido - dados do artigo ausentes');
      }
    } else {
      throw Exception('Falha ao carregar dados do artigo. Código de status: ${response.statusCode}');
    }
  } catch (error, stackTrace) {
    throw Exception('Erro na requisição: $error');
  }
}