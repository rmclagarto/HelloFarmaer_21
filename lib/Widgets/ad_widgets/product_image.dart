import 'package:flutter/material.dart';

class ProductImage extends StatelessWidget {
  final String imagePath;

  const ProductImage({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: AspectRatio(
        aspectRatio: 4 / 3, // largura : altura, ajusta se quiseres
        child: Image.asset(
          imagePath,
          fit: BoxFit.cover,
          errorBuilder:
              (context, error, stackTrace) => Container(
                color: Colors.grey[300],
                child: const Center(child: Icon(Icons.broken_image, size: 40)),
              ),
        ),
      ),
    );
  }
}
