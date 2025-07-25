import 'package:flutter/material.dart';
import 'package:hellofarmer/Model/produto.dart';
import 'package:hellofarmer/Providers/utilizador_provider.dart';
import 'package:hellofarmer/Services/basedados.dart';
import 'package:hellofarmer/main.dart';
import 'package:hellofarmer/Core/cores.dart';
import 'package:hellofarmer/Widgets/home_widgets/drawer.dart';
import 'package:hellofarmer/Widgets/home_widgets/map_widget.dart';
import 'package:hellofarmer/Widgets/home_widgets/button_panel.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController searchController = TextEditingController();
  final GlobalKey<MapWidgetState> _mapKey = GlobalKey<MapWidgetState>();

  List<Produto> _ads = [];

  @override
  void initState() {
    super.initState();
    _loadADS();
  }

  Future<List<Produto>> fetchAds() async {
    final snapshot = await BancoDadosServico().read(caminho: "products");
    if(snapshot == null) return [];


    final data = snapshot.value as Map<dynamic, dynamic>;
    final List<Produto> produtos = [];


    data.forEach((key, value){
      final produtoJson = Map<String, dynamic>.from(value);
    final produto = Produto.fromJson(produtoJson);
    // Só adiciona se for promovido
    if (produto.promovido == true) {
      produtos.add(produto);
    }
    });

    return produtos;
  }

  Future<void> _loadADS () async {
    final ads = await fetchAds();
    setState(() {
      _ads = ads;
    });
  }

  @override
  Widget build(BuildContext context) {


    final user = Provider.of<UtilizadorProvider>(context).utilizador;
    if(user == null){
      return Scaffold(
        body: Center(child: CircularProgressIndicator(),),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'HelloFarmer',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: PaletaCores.corPrimaria(context),
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: AppDrawer(themeNotifier: themeNotifier),
      body: Stack(
        children: [
          MapWidget(key: _mapKey),

          BottomPanel(
            ads: _ads,
            onAdTap: (produto) {
              _mapKey.currentState?.addRandomMarker(produto);
            },
          ),
        ],
      ),
    );
  }
}
