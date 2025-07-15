// import 'package:flutter/material.dart';
// import 'package:hellofarmer/Core/constants.dart';
// import 'package:hellofarmer/Model/produtos.dart';
// import 'package:hellofarmer/Providers/store_provider.dart';
// import 'package:hellofarmer/Screens/store_screens/criar_produto_screen.dart';
// import 'package:hellofarmer/Services/database_service.dart';
// import 'package:hellofarmer/Widgets/store_widgets/produtos/produto_card.dart';
// import 'package:hellofarmer/Widgets/store_widgets/produtos/search_bar.dart';

// class ProdutosSection extends StatefulWidget {
//   final String storeId;
//   const ProdutosSection({super.key, required this.storeId});

//   @override
//   State<ProdutosSection> createState() => _ProdutosSectionState();
// }

// class _ProdutosSectionState extends State<ProdutosSection> {
//   final StoreProvider _storeProvider = StoreProvider();
//   late Stream<List<Produtos>> _produtosIdsStream;

//   @override
//   void initState() {
//     super.initState();
//     _produtosIdsStream = _storeProvider.getStoreProducts(widget.storeId);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Gestão de Produtos',
//           style: theme.textTheme.headlineSmall?.copyWith(
//             color: Colors.white,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         elevation: 0,
//         backgroundColor: Constants.primaryColor,
//         centerTitle: true,
//         iconTheme: const IconThemeData(color: Colors.white),
//       ),
//       body:StreamBuilder<List<Produtos>>(
//         stream: _produtosIdsStream, 
//         builder: (context, snapshot){
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           if (snapshot.hasError) {
//             return Center(child: Text('Erro: ${snapshot.error}'));
//           }

//           final produtos = snapshot.data ?? [];

//           if (produtos.isEmpty) {
//             return const Center(child: Text('Nenhum produto cadastrado'));
//           }

//           return ListView.builder(
//             itemCount: produtos.length,
//             itemBuilder: (context, index){
//               return ProdutoCard(
//                 produto: produtos[index],
//                 onDelete: () => _deleteProduct(produtos[index].idProduto),
//                 onUpdate: (produtoAtualizado) => _updateProduct(produtoAtualizado),
//               );
//             },
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//           onPressed: () => _navigateToAddProduct(),
//           child: const Icon(Icons.add),
//         ),
//       );
//   }

//   Future<void> _navigateToAddProduct() async{
//     final novoProduto = await Navigator.push(
//       context, 
//       MaterialPageRoute(builder: (_) => PublicarProdutoScreen(storeId: widget.storeId)),
//     );

//     if(novoProduto != null){
//       await _storeProvider.addProductToStore(
//         storeId: widget.storeId, 
//         productId: novoProduto.idProduto, 
//         produto: novoProduto
//       );
//     }
//   }

//   Future<List<Produtos>> _fetchProdutosDetails(List<String> produtosIds) async {
//     final produtos = <Produtos>[];
//     for (final id in produtosIds) {
//       final produto = await _dbService.getProdutoById(id);
//       if (produto != null) {
//         produtos.add(produto);
//       }
//     }
//     return produtos;
//   }

//   Future<void> _addProduct(Produtos novoProduto) async {
//     try {
//       // Adiciona o produto à coleção geral
//       await _dbService.create(
//         path: 'produtos/${novoProduto.idProduto}',
//         data: novoProduto.toJson(),
//       );

//       // Adiciona o ID à lista da loja
//       final currentIds = await _dbService.read(
//         path: 'stores/${widget.storeId}/listProductsId',
//       );
//       final List<String> updatedIds = [];

//       if (currentIds != null && currentIds.value is List) {
//         updatedIds.addAll(List<String>.from(currentIds.value as List));
//       }

//       if (!updatedIds.contains(novoProduto.idProduto)) {
//         updatedIds.add(novoProduto.idProduto);
//         await _dbService.update(
//           path: 'stores/${widget.storeId}/listProductsId',
//           data: updatedIds,
//         );
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Erro ao adicionar produto: ${e.toString()}')),
//       );
//     }
//   }

//   Future<void> _deleteProduct(String productId) async {
//     try {
//       // Remove da lista da loja
//       final currentIds = await _dbService.read(
//         path: 'stores/${widget.storeId}/listProductsId',
//       );
//       if (currentIds != null && currentIds.value is List) {
//         final List<String> updatedIds = List<String>.from(
//           currentIds.value as List,
//         )..remove(productId);

//         await _dbService.update(
//           path: 'stores/${widget.storeId}/listProductsId',
//           data: updatedIds,
//         );
//       }

//       // Remove o produto (opcional - depende da sua regra de negócio)
//       await _dbService.delete(path: 'produtos/$productId');

//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Produto removido com sucesso!')),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Erro ao remover produto: ${e.toString()}')),
//       );
//     }
//   }

//   Future<void> _updateProduct(Produtos produto) async {
//     try {
//       await _dbService.update(
//         path: 'produtos/${produto.idProduto}',
//         data: produto.toJson(),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Erro ao atualizar produto: ${e.toString()}')),
//       );
//     }
//   }
// }



import 'package:flutter/material.dart';
import 'package:hellofarmer/Core/constants.dart';
import 'package:hellofarmer/Model/produtos.dart';
import 'package:hellofarmer/Providers/store_provider.dart';
import 'package:hellofarmer/Screens/store_screens/criar_produto_screen.dart';
import 'package:hellofarmer/Widgets/store_widgets/produtos/produto_card.dart';
import 'package:hellofarmer/Widgets/store_widgets/produtos/search_bar.dart';

class ProdutosSection extends StatefulWidget {
  final String storeId;
  const ProdutosSection({super.key, required this.storeId});

  @override
  State<ProdutosSection> createState() => _ProdutosSectionState();
}

class _ProdutosSectionState extends State<ProdutosSection> {
  late final StoreProvider _storeProvider;
  late Stream<List<Produtos>> _produtosStream;

  @override
  void initState() {
    super.initState();
    _storeProvider = StoreProvider();
    _produtosStream = _storeProvider.getStoreProducts(widget.storeId);
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
        backgroundColor: Constants.primaryColor,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SearchBarWidget(),
            const SizedBox(height: 20),
            Expanded(
              child: StreamBuilder<List<Produtos>>(
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
                    return const Center(child: Text('Nenhum produto cadastrado'));
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
        backgroundColor: Constants.primaryColor,
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
      await _storeProvider.addProductToStore(
        storeId: widget.storeId,
        productId: novoProduto.idProduto,
        produto: novoProduto,
      );
    }
  }

  Future<void> _deleteProduct(BuildContext context, String productId) async {
    try {
      await _storeProvider.deleteProduct(
        storeId: widget.storeId,
        productId: productId,
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

  Future<void> _updateProduct(BuildContext context, Produtos produto) async {
    try {
      await _storeProvider.updateProduct(produto);
      
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