import 'package:flutter/material.dart';
import 'package:hellofarmer/Core/cores.dart';
import 'package:hellofarmer/Model/loja.dart';
import 'package:hellofarmer/Widgets/store_widgets/analise_dados_section.dart';
import 'package:hellofarmer/Widgets/store_widgets/clientes/clientes_section.dart';
import 'package:hellofarmer/Widgets/store_widgets/ecomendas/encomendas_section.dart';
import 'package:hellofarmer/Widgets/store_widgets/produtos/produtos_section.dart';

class GestaoSection extends StatelessWidget {
  final Loja store;

  const GestaoSection({super.key, required this.store});

  @override
  Widget build(BuildContext context) {
    final cardItems = [
      _CardItem(
        icon: Icons.receipt_long,
        title: 'Encomendas',
        subtitles: ['Faturação', 'Compras abandonadas'],
        onTap: () => _navegarParaEncomendas(context),
      ),
      _CardItem(
        icon: Icons.shopping_basket,
        title: 'Produtos',
        subtitles: ['Gestão de estoque', 'Gestão de preços', 'Cabazes'],
        onTap: () => _navegarParaProdutos(context),
      ),
      _CardItem(
        icon: Icons.people,
        title: 'Clientes',
        subtitles: ['Base de dados', 'Histórico', 'Grupos'],
        onTap: () => _navegarParaClientes(context),
      ),
      _CardItem(
        icon: Icons.analytics,
        title: 'Análise de Dados',
        subtitles: ['Relatórios', 'Canais de venda', 'Finanças'],
        onTap: () => _navegarParaAnalise(context),
      ),
    ];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),

          const SizedBox(height: 30),
          _buildGridCards(cardItems),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Text(
      'Gestão da Loja',
      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
        fontWeight: FontWeight.bold,
        color: PaletaCores.corPrimaria(context),
      ),
    );
  }

  Widget _buildGridCards(List<_CardItem> items) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = (constraints.maxWidth - 16) / 2;
        final cardHeight = cardWidth * 1.2;

        return Wrap(
          spacing: 16,
          runSpacing: 16,
          children:
              items
                  .map(
                    (item) => SizedBox(
                      width: cardWidth,
                      height: cardHeight,
                      child: _buildGestaoCard(item, context),
                    ),
                  )
                  .toList(),
        );
      },
    );
  }

  Widget _buildGestaoCard(_CardItem item, BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: item.onTap,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(item.icon, size: 30, color: PaletaCores.corPrimaria(context)),
              const SizedBox(height: 8),
              Text(
                item.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              ...item.subtitles.map(
                (sub) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Text('• $sub', style: const TextStyle(fontSize: 12)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navegarParaEncomendas(BuildContext context) {
    // Implemente a navegação
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EncomendasSection(storeId: store.idLoja,)),
    );
  }

  void _navegarParaProdutos(BuildContext context) {
    // Implemente a navegação
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProdutosSection(storeId: store.idLoja),
      ),
    );
  }

  void _navegarParaClientes(BuildContext context) {
    // Implemente a navegação
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ClientesSection(storeId: store.idLoja,)),
    );
  }

  void _navegarParaAnalise(BuildContext context) {
    // Implemente a navegação
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AnalisesFinanceirasSection(storeId: store.idLoja)),
    );
  }
}

class _CardItem {
  final IconData icon;
  final String title;
  final List<String> subtitles;
  final VoidCallback onTap;

  _CardItem({
    required this.icon,
    required this.title,
    required this.subtitles,
    required this.onTap,
  });
}
