import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:testelojongapp/cache/cache.dart';
import 'package:testelojongapp/model/citacao.dart';
import 'package:testelojongapp/requisicao/requisicao_citacao.dart';

class TelaCitacao extends StatefulWidget {
  @override
  _TelaCitacaoState createState() => _TelaCitacaoState();
}

class _TelaCitacaoState extends State<TelaCitacao> {

  final PagingController<int, Citacao> _pagingController =
  PagingController(firstPageKey: 1);

  final List<Color> backgroundColors = [Colors.lightBlueAccent.shade100, Colors.orangeAccent.shade100, Colors.redAccent.shade100];
  int currentColorIndex = 0;

  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener((pageKey) {
      _carregarCitacao(pageKey);
    });
  }

  Future<void> _carregarCitacao(int page) async {
    try {
      final GerenciadorCache gerenciadorCache = GerenciadorCache();
      await gerenciadorCache.inicializar();

      var connectivityResult = await Connectivity().checkConnectivity();

      if (connectivityResult == ConnectivityResult.none) {
        // Sem conexão de rede, carrega do cache
        final List<Citacao> cachedCitacoes =
        await gerenciadorCache.obterCitacoesEmCache(page);

        _pagingController.appendPage(cachedCitacoes, page + 1);
      } else {
        if (await gerenciadorCache.deveBuscarCitacoesNaApi(page)) {
          final List<Citacao> buscandoCitacoes = await buscarCitacao(
              'O7Kw5E2embxod5YtL1h1YsGNN7FFN8wIxPYMg6J9zFjE6Th9oDssEsFLVhxf',
              page);

          if (buscandoCitacoes.isNotEmpty) {
            // Salva as citações no cache
            await gerenciadorCache.salvarCitacoesNoCache(buscandoCitacoes, page);

            _pagingController.appendPage(buscandoCitacoes, page + 1);
          } else {
            print('Lista de citações vazia');
          }
        } else {
          // Cache está atualizado, use as citações do cache
          final List<Citacao> cachedCitacoes =
          await gerenciadorCache.obterCitacoesEmCache(page);

          _pagingController.appendPage(cachedCitacoes, page + 1);
        }
      }
    } catch (error) {
      print('Erro ao carregar citações: $error');
      _pagingController.error = error;
    }
  }

  Color getNextBackgroundColor() {
    final color = backgroundColors[currentColorIndex];
    currentColorIndex = (currentColorIndex + 1) % backgroundColors.length;
    return color;
  }

  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    double containerWidthPercentage = 50;
    double containerHeightPercentage = 50;

    double containerWidth = (containerWidthPercentage / 100) * screenWidth;
    double containerHeight = (containerHeightPercentage / 100) * screenHeight;

    return Container(
      color: Colors.white,
      child: PagedListView<int, Citacao>(
        pagingController: _pagingController,
        builderDelegate: PagedChildBuilderDelegate<Citacao>(
          itemBuilder: (context, citacao, index) {
            final backgroundColor = getNextBackgroundColor();

            return Card(
              elevation: 1,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  color: backgroundColor,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 20,),
                    Center(
                      child: Container(
                        width: containerWidth,
                        height: containerHeight,
                        child: Center(
                          child: Text(
                            citacao.text,
                            style: const TextStyle(fontSize: 16, color: Colors.blueGrey
                            ,fontWeight: FontWeight.bold,),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.fade,
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          citacao.autor,
                          style: const TextStyle(fontSize: 16, color:Colors.blueGrey),
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.fade,
                        ),
                      ),
                    ),
                    Center(
                      child: Padding(
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
                          label: const Text(
                            'Compartilhar',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}