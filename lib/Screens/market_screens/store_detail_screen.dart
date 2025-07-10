import 'package:flutter/material.dart';
import 'package:hellofarmer/Core/constants.dart';
import 'package:hellofarmer/Model/produtos.dart';
import 'package:hellofarmer/Model/store.dart';
import 'package:hellofarmer/Screens/market_screens/product_detail_screen.dart';

class StoreDetailScreen extends StatelessWidget {
  final Store loja;
  final List<Produtos> produtosDaLoja;

  const StoreDetailScreen({
    super.key,
    required this.loja,
    required this.produtosDaLoja,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(loja.nome),
        backgroundColor: Constants.primaryColor,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            loja.descricao,
            style: const TextStyle(fontSize: 16, height: 1.5),
          ),
          const SizedBox(height: 20),
          const Text(
            'Produtos desta loja:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          ...produtosDaLoja.map((produto) {
            return ListTile(
              leading: Image.asset(produto.image, width: 50),
              title: Text(produto.title),
              subtitle: Text('${produto.price}€'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ProductDetailScreen(product: produto),
                  ),
                );
              },
            );
          }).toList(),
        ],
      ),
    );
  }
}

