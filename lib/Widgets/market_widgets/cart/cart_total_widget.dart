
import 'package:flutter/material.dart';
import 'package:hellofarmer/Core/cores.dart';
import 'package:hellofarmer/Model/carrinho.dart';
import 'package:hellofarmer/Screens/market_screens/checkout_screen.dart';

class TotalCarrinhoWidget extends StatelessWidget {
  final List<Carrinho> itensCarrinho;
  final double subtotal;

  const TotalCarrinhoWidget({
    super.key,
    required this.itensCarrinho,
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
        children: <Widget>[
          _subTotal(subtotal, context),
          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 12),
          _total(total, context),
          const SizedBox(height: 20),
          _botaoContinuar(context),
        ],
      ),
    );
  }


  Widget _subTotal(double value, BuildContext context) {
    return _linha('Subtotal:', value, context: context);
  }


  Widget _total(double value, BuildContext context) {
    return _linha('Total:', value, context: context, isTotal: true);
  }

  // Botão "Continuar"
  Widget _botaoContinuar(BuildContext context) {
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
          if (itensCarrinho.isEmpty) {
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
                      CheckoutScreen(cartItems: itensCarrinho, subtotal: subtotal),
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

  Widget _linha(
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
