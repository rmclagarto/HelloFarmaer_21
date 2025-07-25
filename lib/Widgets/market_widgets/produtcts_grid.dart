
import 'package:hellofarmer/Model/produto.dart';


import 'cartao_produto.dart';
import 'package:flutter/material.dart';

class GradeProdutos extends StatelessWidget {
  final List<Produto> produtos;

  const GradeProdutos({super.key, required this.produtos});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.75,
        ),
        itemCount: produtos.length,
        itemBuilder: (context, indice) {
          final produto = produtos[indice];
          return CartaoProduto(produto: produto);
        },
      ),
    );
  }
}



