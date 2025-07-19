import 'package:flutter/material.dart';
import 'package:hellofarmer/Core/constants.dart';
import 'package:hellofarmer/Core/image_assets.dart';
import 'package:hellofarmer/Model/produtos.dart';
import 'package:hellofarmer/Providers/user_provider.dart';
import 'package:hellofarmer/Screens/market_screens/product_detail_screen.dart';
import 'package:hellofarmer/Services/database_service.dart';

import 'package:provider/provider.dart';

class ProductCard extends StatelessWidget {
  final Produtos product;
  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          // Navegar para detalhes do produto
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductDetailScreen(product: product),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 80,
                alignment: Alignment.center,
                child: Image.asset(
                  ImageAssets.alface, // product.imagem,
                  width: 80,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                product.nomeProduto,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 8), // Espaço manual no lugar do Spacer
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      '${product.preco.toStringAsFixed(2)} / ${product.unidadeMedida}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Constants.primaryColor,
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_shopping_cart, size: 20),
                    color: Constants.primaryColor,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () => _addToCart(context),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _addToCart(BuildContext context) async {
    final user = Provider.of<UserProvider>(context, listen: false);
    final dbService = DatabaseService();

    try {
      final cartSnapshot = await dbService.read(
        path: 'users/${user.user?.idUser}/cartProductList',
      );

      List<String> updatedCart = [];

      if(cartSnapshot != null && cartSnapshot.value != null){
        if (cartSnapshot.value is List) {
        updatedCart = List<String>.from(cartSnapshot.value as List);
      } else if (cartSnapshot.value is Map) {
        // Se for um Map (estrutura antiga), converter para List
        updatedCart = (cartSnapshot.value as Map).keys.cast<String>().toList();
      }
      }

      // 4. Verificar se o produto já está no carrinho
    if (updatedCart.contains(product.idProduto)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Produto já está no carrinho')),
      );
      return;
    }

      // 5. Adicionar o novo ID do produto
    updatedCart.add(product.idProduto);

    // 6. Atualizar o carrinho no Firebase
    await dbService.update(
      path: "users/${user.user?.idUser}/cartProductsList",
      data: updatedCart,
    );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Produto adicionado ao carrinho!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao adicionar: ${e.toString()}')),
      );
    }
  }
}
