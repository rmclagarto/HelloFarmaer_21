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
    final opcoesCartoes = [
      _itemCartao(
        icon: Icons.receipt_long,
        titulo: 'Encomendas',
        subTitulo: ['Faturação', 'Compras abandonadas'],
        onTap: () => _navegarParaEncomendas(context),
      ),
      _itemCartao(
        icon: Icons.shopping_basket,
        titulo: 'Produtos',
        subTitulo: ['Gestão de estoque', 'Gestão de preços', 'Cabazes'],
        onTap: () => _navegarParaProdutos(context),
      ),
      _itemCartao(
        icon: Icons.people,
        titulo: 'Clientes',
        subTitulo: ['Base de dados', 'Histórico', 'Grupos'],
        onTap: () => _navegarParaClientes(context),
      ),
      _itemCartao(
        icon: Icons.analytics,
        titulo: 'Análise de Dados',
        subTitulo: ['Relatórios', 'Canais de venda', 'Finanças'],
        onTap: () => _navegarParaAnalise(context),
      ),
    ];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _cabecalho(context),

          const SizedBox(height: 30),
          gradeCartoes(opcoesCartoes),
        ],
      ),
    );
  }

  Widget _cabecalho(BuildContext context) {
    return Text(
      'Gestão da Loja',
      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
        fontWeight: FontWeight.bold,
        color: PaletaCores.corPrimaria(context),
      ),
    );
  }

  Widget gradeCartoes(List<_itemCartao> itens) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final larguraCartao = (constraints.maxWidth - 16) / 2;
        final alturaCartao = larguraCartao * 1.2;

        return Wrap(
          spacing: 16,
          runSpacing: 16,
          children:
              itens
                  .map(
                    (item) => SizedBox(
                      width: larguraCartao,
                      height: alturaCartao,
                      child: _construirCartaoGestao(item, context),
                    ),
                  )
                  .toList(),
        );
      },
    );
  }

  Widget _construirCartaoGestao(_itemCartao item, BuildContext context) {
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
                item.titulo,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              ...item.subTitulo.map(
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
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EncomendasSection(lojaId: store.idLoja,)),
    );
  }

  void _navegarParaProdutos(BuildContext context) {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProdutosSection(lojaId: store.idLoja),
      ),
    );
  }

  void _navegarParaClientes(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ClientesSection(storeId: store.idLoja,)),
    );
  }

  void _navegarParaAnalise(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AnalisesFinanceirasSection(storeId: store.idLoja)),
    );
  }
}

class _itemCartao {
  final IconData icon;
  final String titulo;
  final List<String> subTitulo;
  final VoidCallback onTap;

  _itemCartao({
    required this.icon,
    required this.titulo,
    required this.subTitulo,
    required this.onTap,
  });
}
