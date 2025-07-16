import 'package:flutter/material.dart';
import 'package:hellofarmer/Core/constants.dart';
import 'package:hellofarmer/Model/produtos.dart';
import 'package:hellofarmer/Providers/favorites_provider.dart';
import 'package:hellofarmer/Screens/market_screens/product_detail_screen.dart';
import 'package:provider/provider.dart';

class FavoritesScreen extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    final favorites = Provider.of<FavoritesProvider>(context).favItens;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Favoritos",
          style: TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold
          ),
        ),
        centerTitle: true,
        backgroundColor: Constants.primaryColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: favorites.isEmpty
          ? const Center(
              child: Text(
                "Ainda não adicionaste favoritos.",
                style: TextStyle(fontSize: 16),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final Produtos produto = favorites[index];

                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 3,
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        produto.imagem,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text(
                      produto.nomeProduto,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Text(
                      "Preço: ${produto.preco}€",
                      style: const TextStyle(fontSize: 14),
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.grey,
                      size: 18,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ProductDetailScreen(product: produto),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}

