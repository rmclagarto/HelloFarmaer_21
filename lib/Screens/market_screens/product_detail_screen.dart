import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hellofarmer/Core/constants.dart';
import 'package:hellofarmer/Core/image_assets.dart';
import 'package:hellofarmer/Model/cart_item.dart';
import 'package:hellofarmer/Model/produto.dart';
// import 'package:hellofarmer/Model/store.dart';
import 'package:hellofarmer/Providers/store_provider.dart';
import 'package:hellofarmer/Providers/user_provider.dart';
import 'package:hellofarmer/Screens/market_screens/checkout_screen.dart';
import 'package:hellofarmer/Screens/market_screens/store_detail_screen.dart';
import 'package:hellofarmer/Services/database_service.dart';
import 'package:provider/provider.dart';

class ProductDetailScreen extends StatefulWidget {
  final Produto produto;

  const ProductDetailScreen({super.key, required this.produto});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final BancoDadosServico _db = BancoDadosServico();
  bool _isFavorite = false;
  bool _isLoading = false;

  Future<void> _addToCart(BuildContext context) async {
    if (!mounted || _isLoading) return;
    setState(() => _isLoading = true);

    final user = Provider.of<UserProvider>(context, listen: false);
    final dbService = BancoDadosServico();
    final productId = widget.produto.idProduto;

    try {
      final cartSnapshot = await dbService.read(
        path: 'users/${user.user?.idUtilizador}/cartProductsList',
      );

      if (!mounted) return;

      List<String> updatedCart = [];

      if (cartSnapshot != null && cartSnapshot.value != null) {
        if (cartSnapshot.value is List) {
          updatedCart = List<String>.from(cartSnapshot.value as List);
        } else if (cartSnapshot.value is Map) {
          // Se for um Map (estrutura antiga), converter para List
          updatedCart =
              (cartSnapshot.value as Map).keys.cast<String>().toList();
        }
      }

      // Verificar se o produto já está no carrinho
      if (updatedCart.contains(productId)) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Produto já está no carrinho')),
        );
        return;
      }

      // Adicionar o novo ID do produto
      updatedCart.add(widget.produto.idProduto);

      // Atualizar o carrinho no Firebase
      await dbService.update(
        path: "users/${user.user?.idUtilizador}/cartProductsList",
        data: updatedCart,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Produto adicionado ao carrinho!')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao adicionar: ${e.toString()}')),
      );
    }
  }

  Future<void> _toggleFavorite(BuildContext context) async {
    if (!mounted || _isLoading) return;

    final user = Provider.of<UserProvider>(context, listen: false);

    if (user.user?.idUtilizador == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, faça login primeiro')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final snapshot = await _db.read(
        path: 'users/${user.user?.idUtilizador}/favoritos',
      );

      List<String> favoritos = [];

      if (snapshot?.value != null) {
        if (snapshot!.value is List) {
          favoritos = List<String>.from(snapshot.value as List);
        } else if (snapshot.value is Map) {
          favoritos = (snapshot.value as Map).keys.cast<String>().toList();
        }
      }

      final productId = widget.produto.idProduto;
      if (productId == null) throw Exception('ID do produto inválido');

      final isCurrentlyFavorite = favoritos.contains(productId);

      if (isCurrentlyFavorite) {
        favoritos.remove(productId);
      } else {
        favoritos.add(productId);
      }

      await _db.update(
        path: 'users/${user.user?.idUtilizador}/favoritos',
        data: favoritos,
      );

      if (!mounted) return;
      setState(() => _isFavorite = !isCurrentlyFavorite);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            !isCurrentlyFavorite
                ? 'Adicionado aos favoritos'
                : 'Removido dos favoritos',
          ),
        ),
      );
    } catch (e) {
      debugPrint('Erro ao atualizar favoritos: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              e.toString().contains('permission-denied')
                  ? 'Permissão negada. Verifique seu login.'
                  : 'Erro: ${e.toString()}',
            ),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _incrementClicks() async {
    if (widget.produto.idProduto == null) return;

    try {
      final currentCliks = widget.produto.cliques ?? 0;

      await _db.update(
        path: 'products/${widget.produto.idProduto}',
        data: {'cliques': currentCliks + 1},
      );
    } catch (e) {
      debugPrint('Erro ao atualizar cliques: $e');
    }
  }

  Future<void> _checkIfFavorite() async {
    if (!mounted) return;

    final user = Provider.of<UserProvider>(context, listen: false);

    // Verificar se o usuário está autenticado
    if (user.user?.idUtilizador == null) {
      setState(() => _isFavorite = false);
      return;
    }

    try {
      final snapshot = await _db.read(
        path: 'users/${user.user?.idUtilizador}/favoritos',
      );

      if (snapshot?.value != null) {
        List<String> favoritos = [];

        if (snapshot!.value is List) {
          favoritos = List<String>.from(snapshot.value as List);
        } else if (snapshot.value is Map) {
          favoritos = (snapshot.value as Map).keys.cast<String>().toList();
        }

        if (mounted) {
          setState(() {
            _isFavorite = favoritos.contains(widget.produto.idProduto);
          });
        }
      }
    } catch (e) {
      debugPrint('Erro ao verificar favoritos: $e');
      if (mounted) {
        setState(() => _isFavorite = false);
      }
    }
  }

  Future<void> getQuantidadePreco() async {
    try {
      final snapshot = await _db.read(
        path: "products/${widget.produto.idProduto}",
      );

      final rawData = snapshot?.value;
      if (rawData != null && rawData is Map) {
        final data = Map<String, dynamic>.from(rawData);

        final novaQuantidade = data['quantidade'];
        final novoPreco = data['preco'];

        if (!mounted) return;

        setState(() {
          widget.produto.quantidade = novaQuantidade;
          widget.produto.preco = novoPreco;
        });
      }
    } catch (e) {
      debugPrint('Erro ao buscar quantidade/preço: $e');
    }
  }

  StreamSubscription? _favoritesSubscription;

  @override
  void initState() {
    super.initState();
    _incrementClicks();
    _checkIfFavorite();
    getQuantidadePreco();

    final user = Provider.of<UserProvider>(context, listen: false);
    if (user.user?.idUtilizador != null) {
      _favoritesSubscription = _db
          .readAsStream(path: 'users/${user.user?.idUtilizador}/favoritos')
          .listen((event) {
            if (mounted && event.snapshot.exists) {
              List<String> favoritos = [];
              final value = event.snapshot.value;

              if (value is List) {
                favoritos = List<String>.from(value);
              } else if (value is Map) {
                favoritos = (value as Map).keys.cast<String>().toList();
              }

              setState(() {
                _isFavorite = favoritos.contains(widget.produto.idProduto);
              });
            }
          });
    }
  }

  @override
  void dispose() {
    _favoritesSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isAvailable = (widget.produto.quantidade ?? 0) > 0;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: PaletaCores.corPrimaria,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    Imagens.alface, // widget.product.imagem,
                    width: double.infinity,
                    height: 250,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        widget.produto.nomeProduto,
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(8),
                        elevation: 2,
                      ),
                      onPressed: () => _toggleFavorite(context),
                      child: Icon(
                        _isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: _isFavorite ? Colors.red : Colors.grey[400],
                        size: 24,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '${widget.produto.preco}€',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: PaletaCores.corPrimaria,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(
                      isAvailable ? Icons.check_circle : Icons.cancel,
                      color: isAvailable ? Colors.green : Colors.red,
                      size: 20,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      isAvailable
                          ? 'Em stock (${widget.produto.quantidade} / ${widget.produto.unidadeMedida})'
                          : 'Indisponível',
                      style: TextStyle(
                        color: isAvailable ? Colors.green : Colors.red,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  'Descrição:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.produto.descricao,
                  style: const TextStyle(fontSize: 16, height: 1.5),
                ),
                const SizedBox(height: 20),

                Text(
                  'Categoria: ${widget.produto.categoria}',
                  style: const TextStyle(fontSize: 16),
                ),

                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () {
                    
                    final storeProvider = Provider.of<StoreProvider>(
                      context,
                      listen: false,
                    );

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) => StoreDetailScreen(
                              lojaId: widget.produto.idLoja,
                            ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.store),
                  label: const Text('Ver Loja'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade700,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: isAvailable ? () => _addToCart(context) : null,
                    icon: const Icon(Icons.add_shopping_cart),
                    label: const Text('Adicionar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: PaletaCores.corPrimaria,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed:
                        isAvailable
                            ? () {
                              final itemUnico = CartItem(
                                product: widget.produto,
                                quantity: 1,
                                inStock: true,
                              );
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (_) => CheckoutScreen(
                                        cartItems: [itemUnico],
                                        subtotal: widget.produto.preco,
                                      ),
                                ),
                              );
                            }
                            : null,
                    icon: const Icon(Icons.local_offer),
                    label: const Text('Comprar Agora'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange.shade600,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
