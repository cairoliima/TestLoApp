import 'package:flutter/material.dart';

class TelaConexao extends StatelessWidget {
  const TelaConexao({super.key});

  @override
  Widget build(BuildContext context) {
      return Container(
        color: Colors.white,
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(5.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'OPS!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 19,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 10),
                // Adiciona um espaço entre os textos
                RichText(
                  textAlign: TextAlign.center,
                  text: const TextSpan(
                    children: [
                      TextSpan(
                        text: 'Não foi possível conectar ao \n',
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 18,
                          color: Colors.grey,
                        ),
                      ),
                      TextSpan(
                        text: 'servidor, verifique se está\n',
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 18,
                          color: Colors.grey,
                        ),
                      ),
                      TextSpan(
                        text: 'conectado a internet.',
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 18,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }