import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hellofarmer/Core/constants.dart';
import 'package:hellofarmer/Core/image_assets.dart';
import 'package:hellofarmer/Model/produtos.dart';
import 'package:hellofarmer/Screens/store_screens/my_product_detail_screen.dart';

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
              builder: (context) => MyProductDetailScreen(produto: produto),
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
                  child: buildProductImage(ImageAssets.fruta, produto.isAsset),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      produto.nomeProduto,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      produto.preco.toString(),
                      style: TextStyle(color: Constants.secondaryColor),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      produto.data.toString(),
                      style: const TextStyle(color: Colors.grey),
                    ),
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
      return Image.asset(
        imagePath,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return const Icon(Icons.broken_image, color: Colors.grey);
        },
      );
    } else {
      final file = File(imagePath);
      return FutureBuilder<bool>(
        future: file.exists(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.data == true) {
            return Image.file(
              file,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.broken_image, color: Colors.grey);
              },
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(strokeWidth: 2),
            );
          } else {
            return const Icon(Icons.broken_image, color: Colors.grey);
          }
        },
      );
    }
  }
}
