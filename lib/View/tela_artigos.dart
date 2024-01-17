import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:testelojongapp/View/tela_texto.dart';
import 'package:testelojongapp/cache/cache.dart';
import 'package:testelojongapp/model/artigo.dart';
import 'package:testelojongapp/model/artigo_texto.dart';
import 'package:testelojongapp/requisicao/requisicao_artigo.dart';
import 'package:testelojongapp/requisicao/requisicao_textoCompleto.dart';

class TelaArtigo extends StatefulWidget {
  @override
  _TelaArtigoState createState() => _TelaArtigoState();
}

class _TelaArtigoState extends State<TelaArtigo> {
  List<Artigo> artigos = [];


  @override
  void initState() {
    super.initState();
    _carregarArtigos();
  }


  Future<void> _carregarArtigos() async {
    try {
      final GerenciadorCache gerenciadorCache = GerenciadorCache();
      await gerenciadorCache.inicializar();

      var connectivityResult = await Connectivity().checkConnectivity();

      if (connectivityResult == ConnectivityResult.none) {

        final List<Artigo> cachedArtigos = await gerenciadorCache.obterArtigosEmCache();

        setState(() {
          artigos = cachedArtigos;
        });
      } else {

        if (await gerenciadorCache.deveBuscarNaApi()) {
          final List<Artigo> buscandoArtigos = await buscarArtigos(
              'O7Kw5E2embxod5YtL1h1YsGNN7FFN8wIxPYMg6J9zFjE6Th9oDssEsFLVhxf', 1);

          for (Artigo artigo in buscandoArtigos) {
            await gerenciadorCache.salvarImagemNoCache(
                artigo.imageUrl, 'imagem_${artigo.id}.jpg'
            );
          }

          setState(() {
            artigos = buscandoArtigos;
          });

          await gerenciadorCache.salvarArtigosNoCache(artigos);
        } else {
          final List<Artigo> cachedArtigos = await gerenciadorCache.obterArtigosEmCache();

          setState(() {
            artigos = cachedArtigos;
          });
        }
      }
    } catch (error) {
      print('Erro ao carregar artigos: $error');
    }
  }

  Future<void> _carregarArtigoCompleto(int index) async {
    try {
      final List<artTexto> textos = await buscarArtTexto(
        'O7Kw5E2embxod5YtL1h1YsGNN7FFN8wIxPYMg6J9zFjE6Th9oDssEsFLVhxf',
        artigos[index].id,
      );

      if (textos.isNotEmpty) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TelaArtigoCompleto(
              textos: textos,
            ),
          ),
        );
      } else {
        print('Lista de textos vazia');
      }
    } catch (error) {
      print('Erro ao carregar artigo completo: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: ListView.builder(
          itemCount: artigos.length,
          itemBuilder: (context, index) {
            return Card(
              elevation: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 15,),
                  Center(
                    child: Text(
                      'ARTIGO: ${artigos[index].titulo.toUpperCase()}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.fade,
                    ),
                  ),
                  const SizedBox(height: 8,),

                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: GestureDetector(
                          onTap: () {
                            _carregarArtigoCompleto(index);
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15.0),
                            child: AspectRatio(
                              aspectRatio: 16 / 9,
                              child: CachedNetworkImage(
                                imageUrl: artigos[index].imageUrl,
                                fit: BoxFit.cover,
                                placeholder: (context, url) =>
                                const CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Center(
                        child: Container(
                          child: Text(
                            artigos[index].text,
                            style: const TextStyle(fontSize: 18, color: Colors.grey),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.fade,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton.icon(
                          onPressed: () {
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.grey.shade200,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                          ),
                          icon: const Icon(
                            Icons.share,
                            color: Colors.grey,
                          ),
                          label:  Text(
                            'Compartilhar',
                            style: TextStyle(fontWeight: FontWeight.bold,color: Colors.grey),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

