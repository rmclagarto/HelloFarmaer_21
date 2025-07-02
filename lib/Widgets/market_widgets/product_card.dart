import 'package:flutter/material.dart';
import 'package:projeto_cm/Core/constants.dart';
import 'package:projeto_cm/Core/image_assets.dart';

class ProductCard extends StatelessWidget {
  final Map<String, String> product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          // Navegar para detalhes do produto
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            // Remova mainAxisSize: MainAxisSize.min para permitir altura flexível
            children: [
              Container(
                height: 80,
                alignment: Alignment.center,
                child: Image.asset(
                  ImageAssets.fruta,
                  width: 80,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                product['name'] ?? '',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                product['store'] ?? '',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
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
                      product['price'] ?? '',
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
                    icon: const Icon(
                      Icons.add_shopping_cart,
                      size: 20,
                    ),
                    color: Constants.primaryColor,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () {
                      // Adicionar ao carrinho
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
