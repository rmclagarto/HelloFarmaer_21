

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hellofarmer/Core/cores.dart';
import 'package:hellofarmer/Core/imagens.dart';
import 'package:hellofarmer/Model/produto.dart';
import 'package:hellofarmer/Model/loja.dart';
import 'package:hellofarmer/Screens/market_screens/product_detail_screen.dart';
import 'package:hellofarmer/Services/basedados.dart';

class StoreDetailScreen extends StatefulWidget {
  final String lojaId;
  const StoreDetailScreen({super.key, required this.lojaId});

  @override
  State<StoreDetailScreen> createState() => _StoreDetailScreenState();
}

class _StoreDetailScreenState extends State<StoreDetailScreen> {
  final BancoDadosServico _dbService = BancoDadosServico();
  Loja? _store;
  bool _isLoading = true;
  String? _errorMessage;
  bool _loadingProducts = true;
  String? _productsError;
  List<Produto> _produtos = [];
  bool _productsLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadInitialData(widget.lojaId);
  }

  Future<void> _loadInitialData(String lojaId) async {
    try {
      setState(() => _isLoading = true);
      
      await carregarInfoDaLoja(lojaId);
      
      if (_store != null && mounted) {
        await _loadProdutos(lojaId);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Erro ao carregar dados: ${e.toString()}';
          _isLoading = false;
        });
      }
      debugPrint('Erro no _loadInitialData: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> carregarInfoDaLoja(String lojaId) async {
    try {
      final storeSnapshot = await _dbService.read(caminho: 'stores/$lojaId');
      
      if (!mounted) return;
      
      if (storeSnapshot == null || storeSnapshot.value == null) {
        setState(() {
          _errorMessage = 'Loja não encontrada';
          _isLoading = false;
        });
        return;
      }

      final storeData = storeSnapshot.value;
      final storeInfo = Map<String, dynamic>.from(storeData as Map);

      setState(() {
        _store = Loja.fromJson(storeInfo);
        _errorMessage = null;
      });
    } catch (e, stackTrace) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Erro ao carregar informações da loja';
          _isLoading = false;
        });
      }
      debugPrint('Erro ao carregar loja: $e, $stackTrace');
    }
  }

  Future<void> _loadProdutos(String lojaId) async {
  try {
    if (!mounted) return;
  
    setState(() {
      _loadingProducts = true;
      _productsError = null;
    });
    
    final productsIdSnapshot = await _dbService.read(
      caminho: 'stores/$lojaId/listProductsId',
    );

    debugPrint('Produtos ID Snapshot: ${productsIdSnapshot?.value}');

    if (productsIdSnapshot == null || productsIdSnapshot.value == null) {
      debugPrint('Nenhum produto encontrado para a loja $lojaId');
      setState(() {
        _produtos = [];
        _loadingProducts = false;
        _productsLoaded = true;
      });
      return;
    }

    final productIds = List<String>.from(productsIdSnapshot.value as List);
    debugPrint('IDs de produtos encontrados: $productIds');
    final List<Produto> loadedProducts = [];

    for (final id in productIds) {
      try {
        final productSnapshot = await _dbService.read(caminho: 'products/$id');
        debugPrint('Produto $id: ${productSnapshot?.value}');
        
        if (productSnapshot != null && productSnapshot.value != null) {
          
          final productData = productSnapshot.value;
          final productMap = Map<String, dynamic>.from(productData as Map);
          
          loadedProducts.add(
            Produto.fromJson(productMap),
          );
        }
      } catch (e) {
        debugPrint('Erro ao carregar produto $id: $e');
      }
    }

    if (mounted) {
      setState(() {
        _produtos = loadedProducts;
        _loadingProducts = false;
        _productsLoaded = true;
      });
    }
    debugPrint('Total de produtos carregados: ${_produtos.length}');
  } catch (e, stackTrace) {
    debugPrint('Erro ao carregar produtos: $e');
    debugPrint('Stack trace: $stackTrace');
    if (mounted) {
      setState(() {
        _loadingProducts = false;
        _productsError = 'Erro ao carregar produtos: ${e.toString()}';
        _productsLoaded = true;
      });
    }
  }
}

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: Colors.blueAccent,)),
      );
    }

    if (_errorMessage != null || _store == null) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: PaletaCores.corPrimaria(context),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: Center(
          child: Text(_errorMessage ?? 'Loja não disponível'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: PaletaCores.corPrimaria(context),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              Imagens.quinta,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),

          const SizedBox(height: 16),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _store!.nomeLoja,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Chip(
                  backgroundColor: Colors.amber[50],
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 18),
                      const SizedBox(width: 4),
                      Text(
                        _store!.avaliacoes.toStringAsFixed(1),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Text(
                  _store!.descricao,
                  style: const TextStyle(fontSize: 16, height: 1.5),
                ),
                const SizedBox(height: 20),
                
                const Text(
                  'Informação de Contato',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(Icons.phone, color: PaletaCores.corPrimaria(context)),
                  title: Text(_store!.telefone),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading:  Icon(
                    Icons.location_on,
                    color: PaletaCores.corPrimaria(context),
                  ),
                  title: Text(
                    '${_store!.endereco['rua']}, ${_store!.endereco["cidade"]}',
                  ),
                ),
                const SizedBox(height: 20),
                
                const Text(
                  'Produtos Disponíveis:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                
                if (_loadingProducts)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Center(child: CircularProgressIndicator(color: Colors.blueAccent,)),
                  )
                else if (_productsError != null)
                  Text(
                    _productsError!,
                    style: const TextStyle(color: Colors.red),
                  )
                else if (_produtos.isEmpty)
                  const Text('Nenhum produto disponível nesta loja')
                else
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.7,
                    ),
                    itemCount: _produtos.length,
                    itemBuilder: (context, index) {
                      final produto = _produtos[index];
                      return ProductCard(produto: produto);
                    },
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Widget de card de produto
class ProductCard extends StatelessWidget {
  final Produto produto;

  const ProductCard({super.key, required this.produto});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProductDetailScreen(produto: produto),
          ),
        );
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                child:
                    produto.isAsset
                        ? Image.asset(
                          // produto.imagem,
                          Imagens.alface,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        )
                        : Image.network(
                          // produto.imagem,
                          Imagens.alface,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    produto.nomeProduto,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${produto.preco}€',
                    style: TextStyle(
                      color: PaletaCores.corPrimaria(context),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      produto.categoria,
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
