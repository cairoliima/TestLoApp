import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:testelojongapp/model/citacao.dart';

Future<List<Citacao>> buscarCitacao(String userToken, int page) async {
  final dio = Dio();
  (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (client) {
    client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  };

  try {
    final response = await dio.get(
      'https://applojong.com/api/quotes2',
      options: Options(
        headers: {'Authorization': 'Bearer $userToken'},
      ),
      queryParameters: {'page': page},
    );

    if (response.statusCode == 200) {
      if (response.data != null && response.data is Map<String, dynamic>) {
        final List<dynamic> citacoesData = response.data['list'];

        final List<Citacao> citacoes = citacoesData
            .map((citacoesData) => Citacao(
          id: citacoesData['id'] ?? 0,
          text: citacoesData['text'] ?? '',
          autor: citacoesData['author'] ?? '',
        ))
            .toList();

        return citacoes;
      } else {
        print('Resposta da API: $response');
        throw Exception('Resposta em formato inválido - lista de artigos ausente');
      }
    } else {
      throw Exception('Falha ao carregar artigos. Código de status: ${response.statusCode}');
    }
  } catch (error, stackTrace) {
    throw Exception('Erro na requisição');
  }
}