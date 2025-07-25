import 'package:flutter/material.dart';
import 'package:hellofarmer/Core/cores.dart';
import 'package:hellofarmer/Model/produto.dart';
import 'package:hellofarmer/Providers/loja_provider.dart';
import 'package:hellofarmer/Screens/store_screens/criar_produto_screen.dart';
import 'package:hellofarmer/Widgets/store_widgets/produtos/produto_card.dart';
import 'package:provider/provider.dart';


class ProdutosSection extends StatefulWidget {
  final String storeId;
  const ProdutosSection({super.key, required this.storeId});

  @override
  State<ProdutosSection> createState() => _ProdutosSectionState();
}

class _ProdutosSectionState extends State<ProdutosSection> {
  late final LojaProvider _storeProvider;
  late Stream<List<Produto>> _produtosStream;

  @override
  void initState() {
    super.initState();
     _storeProvider = Provider.of<LojaProvider>(context, listen: false);
    _produtosStream = _storeProvider.obterProdutosDaLoja(widget.storeId);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Gestão de Produtos',
          style: theme.textTheme.headlineSmall?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
        backgroundColor: PaletaCores.corPrimaria(context),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<List<Produto>>(
                stream: _produtosStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Erro: ${snapshot.error}'));
                  }

                  final produtos = snapshot.data ?? [];

                  if (produtos.isEmpty) {
                    return const Center(child: Text('Nenhum produto registrado'));
                  }

                  return ListView.builder(
                    itemCount: produtos.length,
                    itemBuilder: (context, index) {
                      return ProdutoCard(
                        produto: produtos[index],
                        onDelete: () => _deleteProduct(context, produtos[index].idProduto),
                        onUpdate: (produtoAtualizado) => _updateProduct(context, produtoAtualizado),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToAddProduct(context),
        backgroundColor: PaletaCores.corPrimaria(context),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Future<void> _navigateToAddProduct(BuildContext context) async {
    final novoProduto = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PublicarProdutoScreen(storeId: widget.storeId),
      ),
    );
    
    if (novoProduto != null && mounted) {
      await _storeProvider.adicionarProdutoALoja(
        lojaId: widget.storeId,
        produtoId: novoProduto.idProduto,
        produto: novoProduto,
      );
    }
  }

  Future<void> _deleteProduct(BuildContext context, String productId) async {
    try {
      await _storeProvider.removerProduto(
        lojaId: widget.storeId,
        produtoId: productId,
      );
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Produto removido com sucesso!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao remover produto: ${e.toString()}')),
        );
      }
    }
  }

  Future<void> _updateProduct(BuildContext context, Produto produto) async {
    try {
      await _storeProvider.atualizarProduto(produto);
      
      setState(() {
      _produtosStream = _storeProvider.obterProdutosDaLoja(widget.storeId);
    });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Produto atualizado com sucesso!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao atualizar produto: ${e.toString()}')),
        );
      }
    }
  }
}