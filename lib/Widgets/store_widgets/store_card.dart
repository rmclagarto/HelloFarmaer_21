import 'package:flutter/material.dart';
import 'package:projeto_cm/Model/store.dart';

class StoreCard extends StatelessWidget {
  final Store store;
  final VoidCallback onTap;

  const StoreCard({super.key, required this.store, required this.onTap});

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
            store.nome,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(store.descricao),
              const SizedBox(height: 4),
              Text(
                '📍 ${store.endereco['rua']}, ${store.endereco['numero']} - ${store.endereco['bairro']}',
              ),
              Text('📞 ${store.telefone}'),
            ],
          ),
        ),
      ),
    );
  }
}
