import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:testelojongapp/cache/cache.dart';
import 'package:testelojongapp/model/video.dart';
import 'package:testelojongapp/requisicao/requisicao_video.dart';

class TelaVideo extends StatefulWidget {
  @override
  _TelaVideoState createState() => _TelaVideoState();
}

class _TelaVideoState extends State<TelaVideo> {
  List<Video> videos = [];

  @override
  void initState() {
    super.initState();
    _loadVideos();
  }


  Future<void> _loadVideos() async {
    try {
      final GerenciadorCache gerenciadorCache = GerenciadorCache();
      await gerenciadorCache.inicializar();

      var connectivityResult = await Connectivity().checkConnectivity();

      if (connectivityResult == ConnectivityResult.none) {

        final List<Video> cachedVideos = await gerenciadorCache.obterVideosEmCache();

        setState(() {
          videos = cachedVideos;
        });
      } else {
        if (await gerenciadorCache.deveBuscarVideosNaApi()) {
          final List<Video> fetchedVideos = await fetchVideos(
              'O7Kw5E2embxod5YtL1h1YsGNN7FFN8wIxPYMg6J9zFjE6Th9oDssEsFLVhxf', 1);

          setState(() {
            videos = fetchedVideos;
          });

          await gerenciadorCache.salvarVideosNoCache(videos);
        } else {

          final List<Video> cachedVideos = await gerenciadorCache.obterVideosEmCache();

          setState(() {
            videos = cachedVideos;
          });
        }
      }
    } catch (error) {
      print('Erro ao carregar vídeos: $error');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: ListView.builder(
          itemCount: videos.length,
          itemBuilder: (context, index) {
            return Card(
              elevation: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'EP. ${index + 1}: ${videos[index].name.toUpperCase()}',
                        style: const TextStyle(

                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.grey,
                        ),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.fade,
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15.0),
                          child: AspectRatio(
                            aspectRatio: 16 / 9,
                            child: CachedNetworkImage(
                              imageUrl: videos[index].imageUrl,
                              fit: BoxFit.cover,
                              placeholder: (context, url) =>
                              const CircularProgressIndicator(),
                              errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          videos[index].description,
                          style: const TextStyle(
                              fontSize: 16, color: Colors.grey),
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.fade,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton.icon(
                          onPressed: () {},
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
                          label: const Text(
                            'Compartilhar',
                            style: TextStyle(fontWeight: FontWeight.bold,
                                color: Colors.grey),
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


