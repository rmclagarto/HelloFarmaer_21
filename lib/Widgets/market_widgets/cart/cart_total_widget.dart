import 'package:flutter/material.dart';
import 'package:projeto_cm/Core/constants.dart';
import 'package:projeto_cm/Model/cart.dart';


import 'package:projeto_cm/Screens/market_screens/checkout_screen.dart';

class CartTotalWidget extends StatelessWidget {
  
  final List<CartItem> cartItems;
  final double subtotal;

  const CartTotalWidget({
    super.key,
    required this.cartItems,
    required this.subtotal,
  });

  @override
  Widget build(BuildContext context) {
    final double discount = subtotal * 0.4;
    final double total = subtotal - discount;

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
          _buildSubtotal(subtotal),
          const SizedBox(height: 8),
          _buildDiscount(discount),
          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 12),
          _buildTotal(total),
          const SizedBox(height: 20),
          _buildContinueButton(context),
        ],
      ),
    );
  }

  // Widget para Subtotal
  Widget _buildSubtotal(double value) {
    return _buildTotalRow('Subtotal:', value);
  }

  // Widget para Desconto
  Widget _buildDiscount(double discount) {
    return _buildTotalRow('Discount (40%):', -discount, isDiscount: true);
  }

  // Widget para Total
  Widget _buildTotal(double value) {
    return _buildTotalRow('Total:', value, isTotal: true);
  }

  // Botão "Continuar"
  Widget _buildContinueButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Constants.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CheckoutScreen(
                cartItems: cartItems, 
                subtotal: subtotal
              ),
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

  Widget _buildTotalRow(String label, double value,
      {bool isDiscount = false, bool isTotal = false}) {
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
              color: isDiscount
                  ? Colors.red
                  : (isTotal ? Constants.primaryColor : Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
