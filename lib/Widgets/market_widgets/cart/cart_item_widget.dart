import 'package:flutter/material.dart';

class CartItemWidget extends StatelessWidget {
  final Map<String, dynamic> item;
  final Function(int) onQuantityChanged;
  final VoidCallback onDelete;

  const CartItemWidget({
    super.key,
    required this.item,
    required this.onQuantityChanged,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final bool inStock = item['inStock'] ?? true;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          _buildProductImage(),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeaderRow(),
                // _buildDescription(),
                const SizedBox(height: 4),
                if (!inStock)
                  Text(
                    "Fora de stock",
                    style: TextStyle(
                      color: Colors.red[400],
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                const SizedBox(height: 8),
                _buildQuantityAndDeleteRow(inStock),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductImage() {
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

  Widget _buildHeaderRow() {
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

  Widget _buildQuantityAndDeleteRow(bool inStock) {
    return Row(
      children: [
        _buildQuantitySelector(inStock),
        const Spacer(),
        IconButton(
          icon: const Icon(Icons.delete),
          color: Colors.red[400],
          onPressed: onDelete,
        ),
      ],
    );
  }

  Widget _buildQuantitySelector(bool enabled) {
    return Opacity(
      opacity: enabled ? 1.0 : 0.5,
      child: IgnorePointer(
        ignoring: !enabled,
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
                    onQuantityChanged(item['quantity'] - 1);
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
                  final newQty = (item['quantity'] as num).toInt() + 1;
                  if (newQty <= (item['maxQuantity'] as num).toInt()) {
                    onQuantityChanged(newQty);
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
