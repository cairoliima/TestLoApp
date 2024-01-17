import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testelojongapp/model/artigo.dart';
import 'package:testelojongapp/model/citacao.dart';
import 'package:testelojongapp/model/video.dart';

class GerenciadorCache {
  final Dio dio = Dio();
  late SharedPreferences prefs;
  late Directory diretorioApp;

  GerenciadorCache() {
    inicializar();
  }

  Future<void> inicializar() async {
    prefs = await SharedPreferences.getInstance();
    diretorioApp = await getApplicationDocumentsDirectory();
  }

  Future<bool> deveBuscarNaApi() async {
    final String? ultimaAtualizacao = prefs.getString('ultima_atualizacao');

    if (ultimaAtualizacao == null) {
      return true;
    }

    final DateTime ultimaAtualizacaoDate = DateTime.parse(ultimaAtualizacao);
    final DateTime dataAtual = DateTime.now();

    return dataAtual.difference(ultimaAtualizacaoDate).inDays >= 1;
  }

  Future<void> salvarArtigosNoCache(List<Artigo> artigos) async {
    final arquivo = File('${diretorioApp.path}/cache_artigos.json');
    await arquivo.writeAsString(jsonEncode(artigos));

    prefs.setString('ultima_atualizacao', DateTime.now().toIso8601String());
  }

  Future<void> salvarImagemNoCache(String imageUrl, String fileName) async {
    try {
      final Response<List<int>> response = await dio.get<List<int>>(
        imageUrl,
        options: Options(responseType: ResponseType.bytes),
      );

      final File file = File('${diretorioApp.path}/$fileName');
      await file.writeAsBytes(response.data!);
    } catch (e) {
      print('Erro ao salvar imagem: $e');
    }
  }

  Future<List<Artigo>> obterArtigosEmCache() async {
    try {
      final arquivo = File('${diretorioApp.path}/cache_artigos.json');
      if (await arquivo.exists()) {
        final String conteudo = await arquivo.readAsString();
        final List<dynamic> dadosDecodificados = jsonDecode(conteudo);

        final List<Artigo> artigosEmCache = dadosDecodificados
            .map((dynamic json) => Artigo.fromJson(json))
            .toList();

        return artigosEmCache;
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<bool> deveBuscarCitacoesNaApi(int page) async {
    final String lastUpdateKey = 'last_update_citacoes_page_$page';
    final String? lastUpdate = prefs.getString(lastUpdateKey);

    if (lastUpdate == null) {
      return true;
    }

    final DateTime lastUpdateDate = DateTime.parse(lastUpdate);
    final DateTime currentDate = DateTime.now();

    return currentDate.difference(lastUpdateDate).inDays >= 1;
  }

  Future<void> salvarCitacoesNoCache(List<Citacao> citacoes, int page) async {
    final String cacheKey = 'cache_citacoes_page_$page';
    final file = File('${diretorioApp.path}/$cacheKey.json');
    await file.writeAsString(jsonEncode(citacoes));

    final String lastUpdateKey = 'last_update_citacoes_page_$page';
    prefs.setString(lastUpdateKey, DateTime.now().toIso8601String());
  }

  Future<List<Citacao>> obterCitacoesEmCache(int page) async {
    try {
      final String cacheKey = 'cache_citacoes_page_$page';
      final file = File('${diretorioApp.path}/$cacheKey.json');
      if (await file.exists()) {
        final String content = await file.readAsString();
        final List<dynamic> decodedData = jsonDecode(content);

        final List<Citacao> citacoesCache = decodedData
            .map((dynamic json) => Citacao.fromJson(json))
            .toList();

        return citacoesCache;
      }
      return [];
    } catch (e) {
      return [];
    }
  }


  Future<List<Video>> obterVideosEmCache() async {
    final String cachedVideos = prefs.getString('videos') ?? '[]';
    final List<dynamic> decodedVideos = jsonDecode(cachedVideos);

    return decodedVideos.map((video) => Video.fromJson(video)).toList();
  }

  Future<void> salvarVideosNoCache(List<Video> videos) async {
    final List<Map<String, dynamic>> videoMapList =
    videos.map((video) => video.toJson()).toList();

    final String encodedVideos = jsonEncode(videoMapList);
    await prefs.setString('videos', encodedVideos);
  }

  Future<bool> deveBuscarVideosNaApi() async {
    return true;
  }
}







