
import 'package:flutter/material.dart';
import 'package:hellofarmer/Core/constants.dart';
import 'package:hellofarmer/Core/image_assets.dart';
import 'package:hellofarmer/Model/store.dart';


class StoreDetails extends StatelessWidget {
  final Store store;

  const StoreDetails({super.key, required this.store});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
    child:Padding(
      padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card principal
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. Imagem da loja (destaque)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        Imagens.quinta,
                        height: 220,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder:
                            (context, error, stackTrace) => Container(
                              height: 220,
                              color: Colors.grey[200],
                              child: const Icon(
                                Icons.image_not_supported,
                                color: Colors.grey,
                              ),
                            ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // 2. Seção de avaliação (destaque)
                    _buildRatingSection(context),

                    const SizedBox(height: 20),

                    // 3. Descrição
                    Text(
                      store.descricao,
                      style: theme.textTheme.bodyLarge?.copyWith(height: 1.5),
                    ),

                    const SizedBox(height: 24),

                    // 4. Contato e endereço
                    _buildContactInfo(context),
                  ],
                ),
              ),
            ),
            // Seção de comentários pode ser adicionada aqui
          ],
        ),
      // ),
    ),
    );
  }

  // Widget para a seção de avaliação
  Widget _buildRatingSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            // Nota em destaque
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 231, 228, 228),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: const Color.fromARGB(255, 231, 228, 228),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.star_rounded, color: Colors.amber, size: 24),
                  const SizedBox(width: 6),
                  Text(
                    '${store.avaliacoes}/5',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyLarge?.copyWith(color: Colors.black),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Widget para detalhes de contato
  Widget _buildContactInfo(BuildContext context) {
    return Column(
      children: [
        _buildInfoRow(context, Icons.phone, store.telefone),
        const SizedBox(height: 12),
        _buildInfoRow(
          context,
          Icons.location_on,
          "${store.endereco['rua']}, ${store.endereco['numero']}\n"
          "${store.endereco['bairro']}, ${store.endereco['cidade']}",
        ),
      ],
    );
  }

  // Widget base para linhas de informação
  Widget _buildInfoRow(BuildContext context, IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 24, color: PaletaCores.corPrimaria),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.4),
          ),
        ),
      ],
    );
  }

}