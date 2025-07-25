
import 'package:flutter/material.dart';
import 'package:hellofarmer/Core/cores.dart';
import 'package:hellofarmer/Core/imagens.dart';
import 'package:hellofarmer/Model/loja.dart';


class StoreDetails extends StatelessWidget {
  final Loja loja;

  const StoreDetails({
    super.key,
    required this.loja
  });

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);

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
                    // 1. Imagem da loja
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

                    // 2. Seção de avaliação
                    _secaoAvaliacao(context),

                    const SizedBox(height: 20),

                    // 3. Descrição
                    Text(
                      loja.descricao,
                      style: tema.textTheme.bodyLarge?.copyWith(height: 1.5),
                    ),

                    const SizedBox(height: 24),

                    // 4. Contato e endereço
                    _infoContato(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      // ),
    ),
    );
  }

  // Widget para a seção de avaliação
  Widget _secaoAvaliacao(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
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
                    '${loja.avaliacoes}/5',
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
  Widget _infoContato(BuildContext context) {
    return Column(
      children: [
        _linhaInfo(context, Icons.phone, loja.telefone),
        const SizedBox(height: 12),
        _linhaInfo(
          context,
          Icons.location_on,
          "${loja.endereco['rua']}, ${loja.endereco['numero']}\n"
          "${loja.endereco['bairro']}, ${loja.endereco['cidade']}",
        ),
      ],
    );
  }

  // Widget base para linhas de informação
  Widget _linhaInfo(BuildContext context, IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 24, color: PaletaCores.corPrimaria(context)),
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