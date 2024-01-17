import 'package:flutter/material.dart';
import 'package:testelojongapp/View/widget/mensagem_conexao.dart';

class TelaAppBarOf extends StatelessWidget {
  const TelaAppBarOf({super.key});

  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    double containerWidthPercentage = 95;
    double containerHeightPercentage = 5;

    double containerWidth = (containerWidthPercentage / 100) * screenWidth;
    double containerHeight = (containerHeightPercentage / 100) * screenHeight;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(80.0),
          child: AppBar(
            elevation: 0,
            title: const Center(
              child: SizedBox(
                width: 210,
                child: Text(
                  'I N S P I R A Ç Õ E S',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            backgroundColor: Colors.redAccent.shade100,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                //bot de voltar
              },
            ),
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            color: Colors.redAccent.shade100,
            // border: Border.all(color: Colors.black.withOpacity(0.3)),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(),
                ],
              ),
              Container(
                height: containerHeight,
                width: containerWidth,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: TabBar(
                  indicator: BoxDecoration(
                  color: Colors.grey, //
                  borderRadius: BorderRadius.circular(15.0),
                ),
                  tabs: [
                    _buildTab('V I D E O S'),
                    _buildTab('A R T I G O S'),
                    _buildTab('C I T A Ç Õ E S'),
                  ],
                ),

              ),
              const SizedBox(
                height: 15,
              ),
              const Expanded(
                child: TabBarView(
                  children: [
                    TelaConexao(),
                    TelaConexao(),
                    TelaConexao(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTab(String text) {
    return Container(
      child: Tab(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
          ),
          padding: EdgeInsets.all(8.0),
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11.0,
            ),
          ),
        ),
      ),
    );
  }
}
