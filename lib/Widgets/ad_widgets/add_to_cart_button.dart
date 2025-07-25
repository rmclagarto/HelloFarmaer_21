
import 'package:flutter/material.dart';
import 'package:hellofarmer/Core/cores.dart';


class AddToCartButton extends StatelessWidget {
  final VoidCallback onPressed;
  
  const AddToCartButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: PaletaCores.corPrimaria(context),
        minimumSize: const Size(double.infinity, 50),
      ),
      onPressed: onPressed,
      child: const Text(
        'Adicionar ao Carrinho',
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
        ),
      ),
    );
  }
}