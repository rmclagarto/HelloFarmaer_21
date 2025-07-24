// category_horizontal_list.dart

import 'package:flutter/material.dart';
import 'package:hellofarmer/Model/produto.dart';
import 'package:hellofarmer/Widgets/market_widgets/product_card.dart';


class CategoryHorizontalList extends StatelessWidget {
  final String categoryName;
  final List<Produto> products;
  final VoidCallback onShowAll;

  const CategoryHorizontalList({
    super.key,
    required this.categoryName,
    required this.products,
    required this.onShowAll,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 8, left: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título da categoria + botão Show All
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                categoryName,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: onShowAll,
                child: const Text(
                  'Mostrar mais',
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 220, // altura fixa para os cartões
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: products.length,
              separatorBuilder: (_, _) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final product = products[index];
                return SizedBox(
                  width: 140,
                  child: ProductCard(product: product),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
