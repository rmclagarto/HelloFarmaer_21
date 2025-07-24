import 'package:flutter/material.dart';
import 'package:hellofarmer/Core/constants.dart';
import 'package:hellofarmer/Core/image_assets.dart';
import 'package:hellofarmer/Model/produto.dart';
import 'package:hellofarmer/Screens/market_screens/product_detail_screen.dart';


class ProductCard extends StatelessWidget {
  final Produto product;
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
              builder: (context) => ProductDetailScreen(produto: product),
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
                  Imagens.alface, // product.imagem,
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
                        color: PaletaCores.corPrimaria,
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
