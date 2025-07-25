
import 'package:flutter/material.dart';
import 'package:hellofarmer/Core/cores.dart';


class PriceQuantityRow extends StatelessWidget {
  final int quantity;
  final String unit;
  final double pricePerUnit;
  
  const PriceQuantityRow({
    super.key,
    required this.quantity,
    required this.unit,
    required this.pricePerUnit,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text('$quantity unidades'),
        const SizedBox(width: 8),
        Text(unit),
        const Spacer(),
        Text(
          '${pricePerUnit.toStringAsFixed(2)}€/unidade',
          style: TextStyle(
            color: PaletaCores.corPrimaria(context),
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}