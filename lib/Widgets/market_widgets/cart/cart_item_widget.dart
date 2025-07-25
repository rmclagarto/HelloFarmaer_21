import 'package:flutter/material.dart';

class ItemCarrinhoWidget extends StatelessWidget {
  final Map<String, dynamic> item;
  final Function(int) aoAlterarQuantidade;
  final VoidCallback aoRemover;

  const ItemCarrinhoWidget({
    super.key,
    required this.item,
    required this.aoAlterarQuantidade,
    required this.aoRemover,
  });

  @override
  Widget build(BuildContext context) {
    final bool emStock = item['inStock'] ?? true;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          _imagemProduto(),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                cabecalho(),
                const SizedBox(height: 4),
                if (!emStock)
                  Text(
                    "Fora de stock",
                    style: TextStyle(
                      color: Colors.red[400],
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                const SizedBox(height: 8),
                _linhaQuantidadeRemover(emStock),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _imagemProduto() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.asset(
        item['image'],
        width: 80,
        height: 80,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget cabecalho() {
    double priceDouble = 0.0;
    if (item['price'] is String) {
      priceDouble = double.tryParse(item['price'].replaceAll(',', '.')) ?? 0.0;
    } else if (item['price'] is double) {
      priceDouble = item['price'];
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            item['name'],
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Text(
          '${priceDouble.toStringAsFixed(2)} €',
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _linhaQuantidadeRemover(bool habilitado) {
    return Row(
      children: [
        _seletorQuantidade(habilitado),
        const Spacer(),
        IconButton(
          icon: const Icon(Icons.delete),
          color: Colors.red[400],
          onPressed: aoRemover,
        ),
      ],
    );
  }

  Widget _seletorQuantidade(bool habilitado) {
    return Opacity(
      opacity: habilitado ? 1.0 : 0.5,
      child: IgnorePointer(
        ignoring: !habilitado,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.remove, size: 18),
                onPressed: () {
                  if (item['quantity'] > 1) {
                    aoAlterarQuantidade(item['quantity'] - 1);
                  }
                },
                padding: EdgeInsets.zero,
              ),
              Text(
                item['quantity'].toString(),
                style: const TextStyle(fontSize: 16),
              ),
              IconButton(
                icon: const Icon(Icons.add, size: 18),
                onPressed: () {
                  final novaQtd = (item['quantity'] as num).toInt() + 1;
                  if (novaQtd <= (item['maxQuantity'] as num).toInt()) {
                    aoAlterarQuantidade(novaQtd);
                  }
                },
                padding: EdgeInsets.zero,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
