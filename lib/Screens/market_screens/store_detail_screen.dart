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
        title: Text(loja.nomeLoja),
        backgroundColor: Constants.primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Imagem da loja
          
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                loja.imagem!,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          
          const SizedBox(height: 16),
          
          // Nome e avaliação
          Row(
            children: [
              Expanded(
                child: Text(
                  loja.nomeLoja,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Chip(
                backgroundColor: Colors.amber[50],
                label: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 18),
                    const SizedBox(width: 4),
                    Text(
                      loja.avaliacoes.toString(),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 8),
          
          // Descrição
          Text(
            loja.descricao,
            style: const TextStyle(fontSize: 16, height: 1.5),
          ),
          
          const SizedBox(height: 20),
          
          // Informações de contato
          const Text(
            'Informações de Contato:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ListTile(
            leading: const Icon(Icons.phone, color: Constants.primaryColor),
            title: Text(loja.telefone),
          ),
          ListTile(
            leading: const Icon(Icons.location_on, color: Constants.primaryColor),
            title: Text('${loja.endereco["rua"]}, ${loja.endereco["cidade"]}'),
          ),
          
          const SizedBox(height: 20),
          
          // Lista de produtos
          const Text(
            'Produtos Disponíveis:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.7,
            ),
            itemCount: produtosDaLoja.length,
            itemBuilder: (context, index) {
              final produto = produtosDaLoja[index];
              return ProductCard(produto: produto);
            },
          ),
        ],
      ),
    );
  }
}

// Widget de card de produto
class ProductCard extends StatelessWidget {
  final Produtos produto;

  const ProductCard({super.key, required this.produto});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProductDetailScreen(product: produto),
          ),
        );
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12)),
                child: produto.isAsset
                    ? Image.asset(
                        produto.imagem,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      )
                    : Image.network(
                        produto.imagem,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    produto.nomeProduto,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${produto.preco}€',
                    style: TextStyle(
                      color: Constants.primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        produto.categoria,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}