import 'package:flutter/material.dart';

class ProductHeader extends StatelessWidget {
  final String productName;
  
  const ProductHeader({
    super.key,
    required this.productName,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      productName,
      style: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}