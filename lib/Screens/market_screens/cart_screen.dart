import 'package:flutter/material.dart';
import 'package:hellofarmer/Core/constants.dart';
import 'package:hellofarmer/Core/image_assets.dart';
import 'package:hellofarmer/Model/cart_item.dart';
import 'package:hellofarmer/Model/produto.dart';
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
  List<Produto> cartProducts = [];
  Map<String, int> quantities = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProdutos();
  }

  Future<void> _loadProdutos() async {
    final user = Provider.of<UserProvider>(context, listen: false).user;
    final dbService = BancoDadosServico();

    try {
      // 1. Buscar lista de IDs no carrinho
      final cartSnapshot = await dbService.read(
        path: "users/${user?.idUtilizador}/cartProductsList",
      );

      if (cartSnapshot != null && cartSnapshot.value != null) {
        final List<String> productIds = List<String>.from(
          cartSnapshot.value as List,
        );

        // 2. Buscar detalhes de cada produto
        final List<Produto> products = [];
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
    // Find the product to check available quantity
    final product = cartProducts.firstWhere(
      (p) => p.idProduto == productId,
      orElse:
          () => Produto(
            idProduto: '',
            nomeProduto: '',
            preco: 0,
            quantidade: 0,
            idLoja: '', // Added required field
            categoria: '', // Added required field
            imagem: '', // Added required field
            isAsset: false, // Added required field
            descricao: '', // Added required field
            unidadeMedida: '', // Added required field
            data: DateTime.now(), // Added required field
          ),
    );

    // Enforce quantity limits
    if (newQuantity < 1) {
      newQuantity = 1; // Minimum quantity
    } else if (newQuantity > product.quantidade) {
      newQuantity = product.quantidade; // Maximum available quantity
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Quantidade máxima disponível atingida'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }

    if (mounted) {
      setState(() {
        quantities[productId] = newQuantity;
      });
    }
  }

  Future<void> _removeItem(String productId) async {
    final user = Provider.of<UserProvider>(context, listen: false).user;
    final dbService = BancoDadosServico();

    try {
      // 1. Buscar lista atual
      final cartSnapshot = await dbService.read(
        path: "users/${user?.idUtilizador}/cartProductsList",
      );

      if (cartSnapshot != null && cartSnapshot.value != null) {
        List<String> productIds = List<String>.from(cartSnapshot.value as List);

        // 2. Remover o item
        productIds.remove(productId);

        // 3. Atualizar no banco
        await dbService.update(
          path: "users/${user?.idUtilizador}/cartProductsList",
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
        backgroundColor: PaletaCores.corPrimaria,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Expanded(
            child:
                isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : cartProducts.isEmpty
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
                            'quantity': quantities[product.idProduto] ?? 1.0,
                            'maxQuantity': product.quantidade,
                            'image': Imagens.alface,
                            'inStock': product.quantidade > 0,
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
