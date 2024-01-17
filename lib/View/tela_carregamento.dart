import 'package:testelojongapp/View/widget/appbar.dart';
import 'package:testelojongapp/View/widget/appbar_of.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';


class TelaCarregamento extends StatefulWidget {
  TelaCarregamento({
    Key? key,
  }) : super(key: key);

  @override
  State<TelaCarregamento> createState() => _TelaCarregamentoState();
}

class _TelaCarregamentoState extends State<TelaCarregamento> {
  get keyboardType => null;
  get raisedButtonStyle => null;


  @override
  initState() {
    super.initState();
    _verificarConexao();

  }


  _verificarConexao() async {
    var connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult == ConnectivityResult.none) {
      // Navegar para a tela sem internet
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => TelaAppBarOf(),
        ),
      );
    } else {
      ///Navegar para a tela com internet
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => TelaAppBarOn(),
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    double screenWidth =
        MediaQuery.of(context).size.width;
    double screenHeight =
        MediaQuery.of(context).size.height;

    return Scaffold(
      body: SizedBox(
        width: screenWidth,
        height: screenHeight,
        child: Container(
          decoration: const BoxDecoration(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: screenWidth * 0.7,
                height: screenHeight * 0.3,
                child: Image.asset(
                  'assets/img/lojong.png',
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
