import 'package:flutter/material.dart';
import 'package:hellofarmer/Core/constants.dart';
import 'package:hellofarmer/Core/image_assets.dart';
import 'package:hellofarmer/Model/cart_item.dart';
import 'package:hellofarmer/Model/produtos.dart';
import 'package:hellofarmer/Model/store.dart';
import 'package:hellofarmer/Providers/store_provider.dart';
import 'package:hellofarmer/Providers/user_provider.dart';

import 'package:hellofarmer/Screens/market_screens/checkout_screen.dart';
import 'package:hellofarmer/Screens/market_screens/store_detail_screen.dart';
import 'package:hellofarmer/Services/database_service.dart';
import 'package:provider/provider.dart';

class ProductDetailScreen extends StatefulWidget {
  final Produtos product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final DatabaseService _db = DatabaseService();
  bool _isFavorite = false;
  bool _isLoading = false;

  Future<void> _addToCart(BuildContext context) async {
    if (!mounted || _isLoading) return;
    setState(() => _isLoading = true);

    final user = Provider.of<UserProvider>(context, listen: false);
    final dbService = DatabaseService();

    try {
      final cartSnapshot = await dbService.read(
        path: 'users/${user.user?.idUser}/cartProductsList',
      );
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
      if (updatedCart.contains(widget.product.idProduto)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Produto já está no carrinho')),
        );
        return;
      }

      // Adicionar o novo ID do produto
      updatedCart.add(widget.product.idProduto);

      // Atualizar o carrinho no Firebase
      await dbService.update(
        path: "users/${user.user?.idUser}/cartProductsList",
        data: updatedCart,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Produto adicionado ao carrinho!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao adicionar: ${e.toString()}')),
      );
    }
  }

  Future<void> _toggleFavorite(BuildContext context) async {
    if (!mounted || _isLoading) return;
    setState(() => _isLoading = true);
    
    final user = Provider.of<UserProvider>(context, listen: false);
    

    try {
      final snapshot = await _db.read(
        path: 'user/${user.user?.idUser}/favoritos',
      );

      List<String> favoritos = [];

      if (snapshot?.value != null) {
        favoritos = List<String>.from(snapshot!.value as List);
      }

      if (favoritos.contains(widget.product.idProduto)) {
        favoritos.remove(widget.product.idProduto);
      } else {
        favoritos.add(widget.product.idProduto!);
      }

      await _db.update(
        path: 'users/${user.user?.idUser}/favoritos',
        data: favoritos,
      );

      if (!mounted) return;
      setState(() => _isFavorite = !_isFavorite);


      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isFavorite
                ? 'Adicionado aos favoritos'
                : 'Removido dos favoritos',
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      print("\n\n\n\n");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro: $e')));

      print("Erro; $e");
      print("\n\n\n\n");
    }
    finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isAvailable = (widget.product.quantidade ?? 0) > 0;
    // final favoritesSnapshot = Provider.of<UserProvider>(context).userFavorites;
    // final isFavorited = favoritesSnapshot?.contains(product.idProduto) ?? false;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Constants.primaryColor,
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
                    ImageAssets.alface, // widget.product.imagem,
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
                        widget.product.nomeProduto,
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
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '${widget.product.preco}€',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Constants.primaryColor,
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
                          ? 'Em stock (${widget.product.quantidade})'
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
                  widget.product.descricao,
                  style: const TextStyle(fontSize: 16, height: 1.5),
                ),
                const SizedBox(height: 20),
                Text(
                  'Categoria: ${widget.product.categoria}',
                  style: const TextStyle(fontSize: 16),
                ),

                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () {
                    // Simule ou busque os produtos da loja real
                    final storeProvider = Provider.of<StoreProvider>(
                      context,
                      listen: false,
                    );

                    // final produtosDaLoja = storeProvider.getProdutosDaLoja(
                    //   widget.product.loja,
                    // );

                    // Dados estáticos da loja
                    final lojaEstatica = Store.myStore(
                      idLoja: "1",
                      nomeLoja: "Fazenda Orgânica do Zé",
                      descricao:
                          "Produtos orgânicos frescos diretamente da nossa fazenda familiar com mais de 20 anos de tradição.",
                      telefone: "912345678",
                      endereco: {
                        "rua": "Estrada da Fazenda, 123",
                        "cidade": "São Paulo",
                        "estado": "SP",
                        "cep": "12345-000",
                      },
                      avaliacoes: 0,
                      imagem: "assets/img/quinta.jpg",
                      faturamento: 0,
                    );

                    final productStatic = Produtos(
                      idProduto: "1",
                      nomeProduto: "product teste estatico",
                      categoria: "Vegetais",
                      imagem: "assets/img/alface.png",
                      isAsset: true,
                      descricao: "description",
                      // isAsset: true,
                      preco: 23.0,
                      quantidade: 1,
                      unidadeMedida: "unidades",
                      data: DateTime.now(),
                    );

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) => StoreDetailScreen(
                              loja: lojaEstatica,
                              produtosDaLoja: [
                                productStatic,
                                productStatic,
                                productStatic,
                                productStatic,
                                productStatic,
                                productStatic,
                                productStatic,
                                productStatic,
                              ],
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
                      backgroundColor: Constants.primaryColor,
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
                                product: widget.product,
                                quantity: 1,
                                inStock: true,
                              );
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (_) => CheckoutScreen(
                                        cartItems: [itemUnico],
                                        subtotal: widget.product.preco,
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
