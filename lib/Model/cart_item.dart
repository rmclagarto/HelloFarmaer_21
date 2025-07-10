import 'package:hellofarmer/Model/produtos.dart';

class CartItem{
  final Produtos product;
  int quantity;
  final bool inStock;

  double get unitPrice => _parsePrice(product.price);
  double get totalPrice => unitPrice * quantity;


  CartItem({
    required this.product,
    this.quantity = 1,
    this.inStock = true
  });

  Map<String, dynamic> toMap() {
    return {
      'name': product.title,
      'quantity': quantity,
      'price': product.price,
      'inStock': inStock,
    };
  }


  double _parsePrice(String priceStr) {
    final numericString = priceStr
        .replaceAll('€', '')
        .replaceAll(',', '.')
        .replaceAll(RegExp(r'[^0-9.]'), '');
    return double.tryParse(numericString) ?? 0.0;
  }
}