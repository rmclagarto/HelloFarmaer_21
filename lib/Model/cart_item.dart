import 'package:hellofarmer/Model/produto.dart';

class CartItem{
  final Produto product;
  int quantity;
  final bool inStock;

  double get unitPrice => product.preco;
  double get totalPrice => unitPrice * quantity;


  CartItem({
    required this.product,
    this.quantity = 1,
    this.inStock = true
  });

  Map<String, dynamic> toMap() {
    return {
      'name': product.nomeProduto,
      'quantity': quantity,
      'price': product.preco,
      'inStock': inStock,
    };
  }
}