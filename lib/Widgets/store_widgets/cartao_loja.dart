
import 'package:flutter/material.dart';
import 'package:hellofarmer/Model/loja.dart';


class CartaoLoja extends StatelessWidget {
  final Loja loja;
  final VoidCallback onTap;

  const CartaoLoja({
    super.key, 
    required this.loja, 
    required this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: ListTile(
          contentPadding: const EdgeInsets.all(16),
          leading: const Icon(Icons.store, color: Colors.blueAccent),
          title: Text(
            loja.nomeLoja,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(loja.descricao),
              const SizedBox(height: 4),
              Text(
                '📍 ${loja.endereco['rua']}, ${loja.endereco['numero']} - ${loja.endereco['bairro']}',
              ),
              Text('📞 ${loja.telefone}'),
            ],
          ),
        ),
      ),
    );
  }
}
