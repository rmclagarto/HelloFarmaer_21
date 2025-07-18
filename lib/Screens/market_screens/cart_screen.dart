import 'package:flutter/material.dart';
import 'package:hellofarmer/Core/constants.dart';
import 'package:hellofarmer/Core/image_assets.dart';
import 'package:hellofarmer/Model/cart_item.dart';
import 'package:hellofarmer/Model/produtos.dart';
import 'package:hellofarmer/Providers/user_provider.dart';
import 'package:hellofarmer/Services/database_service.dart';
import 'package:hellofarmer/Widgets/market_widgets/cart/cart_item_widget.dart';
import 'package:hellofarmer/Widgets/market_widgets/cart/cart_total_widget.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<Produtos> cartProducts = [];
  Map<String, int> quantities = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProdutos();
  }

  Future<void> _loadProdutos() async {
    final user = Provider.of<UserProvider>(context, listen: false).user;
    final dbService = DatabaseService();

    try {
      // 1. Buscar lista de IDs no carrinho
      final cartSnapshot = await dbService.read(
        path: "users/${user?.idUser}/cartProductsList",
      );

      if (cartSnapshot != null && cartSnapshot.value != null) {
        final List<String> productIds = List<String>.from(
          cartSnapshot.value as List,
        );

        // 2. Buscar detalhes de cada produto
        final List<Produtos> products = [];
        final Map<String, int> productQuantities = {};

        for (String id in productIds) {
          final produto = await dbService.getProdutoById(id);
          if (produto != null) {
            products.add(produto);
            // Inicializa quantidade como 1 ou mantém a existente
            productQuantities[id] = quantities[id] ?? 1;
          }
        }

        setState(() {
          cartProducts = products;
          quantities = productQuantities;
          isLoading = false;
        });
      } else {
        setState(() {
          cartProducts = [];
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao carregar carrinho: $e')));
    }
  }

  Future<void> _updateQuantity(String productId, int newQuantity) async {
    if (newQuantity < 1) return;

    setState(() {
      quantities[productId] = newQuantity;
    });
  }

  Future<void> _removeItem(String productId) async {
    final user = Provider.of<UserProvider>(context, listen: false).user;
    final dbService = DatabaseService();

    try {
      // 1. Buscar lista atual
      final cartSnapshot = await dbService.read(
        path: "users/${user?.idUser}/cartProductsList",
      );

      if (cartSnapshot != null && cartSnapshot.value != null) {
        List<String> productIds = List<String>.from(cartSnapshot.value as List);

        // 2. Remover o item
        productIds.remove(productId);

        // 3. Atualizar no banco
        await dbService.update(
          path: "users/${user?.idUser}/cartProductsList",
          data: productIds,
        );

        // 4. Atualizar estado local
        setState(() {
          cartProducts.removeWhere((p) => p.idProduto == productId);
          quantities.remove(productId);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao remover item: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final subtotal = cartProducts.fold<double>(
      0,
      (sum, product) =>
          sum + (product.preco * (quantities[product.idProduto] ?? 1)),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Meu Carrinho",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Constants.primaryColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Expanded(
            child:
                cartProducts.isEmpty
                    ? const Center(child: Text('Seu carrinho está vazio'))
                    : ListView.separated(
                      itemCount: cartProducts.length,
                      separatorBuilder: (context, index) => Divider(height: 1),

                      itemBuilder: (context, index) {
                        final product = cartProducts[index];
                        return CartItemWidget(
                          item: {
                            'name': product.nomeProduto,
                            'price': product.preco,
                            'quantity': product.quantidade,
                            'image': ImageAssets.alface,
                            'inStock': true,
                          },
                          onQuantityChanged: (newQuantity) {
                            _updateQuantity(product.idProduto, newQuantity);
                          },
                          onDelete: () {
                            _removeItem(product.idProduto);
                          },
                        );
                      },
                    ),
          ),
          if (cartProducts.isNotEmpty)
            CartTotalWidget(
              cartItems:
                  cartProducts
                      .map(
                        (p) => CartItem(
                          product: p,
                          quantity: quantities[p.idProduto] ?? 1,
                        ),
                      )
                      .toList(),
              subtotal: subtotal,
            ),
        ],
      ),
    );
  }
}
