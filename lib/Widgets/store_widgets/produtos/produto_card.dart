import 'dart:io';
import 'package:flutter/material.dart';
import 'package:projeto_cm/Core/constants.dart';
import 'package:projeto_cm/Model/produtos.dart';
import 'package:projeto_cm/Widgets/store_widgets/produtos/produtos_stats.dart';

class ProdutoCard extends StatelessWidget {
  final Produtos produto;
  final VoidCallback onDelete;
  final Function(Produtos) onUpdate;

  const ProdutoCard({
    super.key,
    required this.produto,
    required this.onDelete,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () async {
          final updatedProduto = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProdutosStats(produto: produto),
            ),
          );

          if (updatedProduto is Produtos) {
            onUpdate(updatedProduto);
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  width: 80,
                  height: 80,
                  child: buildProductImage(produto.image, produto.isAsset),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(produto.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    Text(produto.price, style: TextStyle(color: Constants.secondaryColor)),
                    const SizedBox(height: 6),
                    Text(produto.date, style: const TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildProductImage(String imagePath, bool isAsset) {
    if (isAsset) {
      return Image.asset(imagePath, fit: BoxFit.cover);
    } else {
      return Image.file(File(imagePath), fit: BoxFit.cover);
    }
  }
}
