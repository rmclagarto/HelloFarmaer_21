
import 'package:flutter/material.dart';
import 'package:hellofarmer/Core/cores.dart';
import 'package:hellofarmer/Model/carrinho.dart';
import 'package:hellofarmer/Screens/market_screens/checkout_screen.dart';

class CartTotalWidget extends StatelessWidget {
  final List<Carrinho> cartItems;
  final double subtotal;

  const CartTotalWidget({
    super.key,
    required this.cartItems,
    required this.subtotal,
  });

  @override
  Widget build(BuildContext context) {
    
    final double total = subtotal;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildSubtotal(subtotal, context),
          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 12),
          _buildTotal(total, context),
          const SizedBox(height: 20),
          _buildContinueButton(context),
        ],
      ),
    );
  }

  // Widget para Subtotal
  Widget _buildSubtotal(double value, BuildContext context) {
    return _buildTotalRow('Subtotal:', value, context: context);
  }

  // Widget para Total
  Widget _buildTotal(double value, BuildContext context) {
    return _buildTotalRow('Total:', value, context: context, isTotal: true);
  }

  // Botão "Continuar"
  Widget _buildContinueButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: PaletaCores.corPrimaria(context),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: () {
          if (cartItems.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'O carrinho está vazio. Adicione produtos antes de continuar.',
                ),
                backgroundColor: Colors.redAccent,
              ),
            );
            return;
          }
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) =>
                      CheckoutScreen(cartItems: cartItems, subtotal: subtotal),
            ),
          );
        },
        child: const Text(
          'Continuar',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildTotalRow(
    String label,
    double value, {
      required BuildContext context,
      bool isDiscount = false,
      bool isTotal = false,
    }
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 16 : 15,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? Colors.black : Colors.grey[700],
            ),
          ),
          Text(
            '${value.toStringAsFixed(2)} €',
            style: TextStyle(
              fontSize: isTotal ? 18 : 15,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color:
                  isDiscount
                      ? PaletaCores.dangerColor(context)
                      : (isTotal ? PaletaCores.corPrimaria(context) : Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
