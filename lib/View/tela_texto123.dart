import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/file.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_html/flutter_html.dart';
// import 'package:share_plus/share_plus.dart';
import 'package:testelojongapp/model/artigo_texto.dart';

class TelaArtigoCompleto extends StatelessWidget {
  final List<artTexto> textos;

  TelaArtigoCompleto({ required this.textos});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red.shade200,
        automaticallyImplyLeading: false,
        leading:
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
      ),
      body: ListView.builder(
        itemCount: textos.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              const SizedBox(height: 20,),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Center(
                  child: Text(
                    textos[index].titulo.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20,),
              Container(
                width: 350,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: Image.network(
                    textos[index].image,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Html(
                  data: textos[index].textoCompleto,
                  style: {
                    'body': Style(
                      fontSize: FontSize(14.0),
                    ),
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Text(
                  'Autor: ${textos[index].autor}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                ),
              ),
              const SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton.icon(
                  onPressed: () {
                    // _compartilhar(context, textos[0].textoCompleto);
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
                    style: TextStyle(fontWeight: FontWeight.bold,color: Colors.grey),
                  ),
                ),
              ),
              const SizedBox(height: 10,),

            ],
          );
        },
      ),
    );
  }

  // void _compartilhar(BuildContext context, String texto) {
  //   Share.share(texto);
  // }


}
