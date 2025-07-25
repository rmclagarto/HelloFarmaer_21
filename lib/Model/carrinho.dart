import 'package:hellofarmer/Model/produto.dart';

class Carrinho{
  final Produto produto;
  int quantidade;
  final bool inStock;

  double get precoUnitario => produto.preco;
  double get precoTotal => precoUnitario * quantidade;


  Carrinho({
    required this.produto,
    this.quantidade = 1,
    this.inStock = true
  });

  Map<String, dynamic> toMap() {
    return {
      'name': produto.nomeProduto,
      'quantity': quantidade,
      'price': produto.preco,
      'inStock': inStock,
    };
  }
}