import 'package:flutter/material.dart';
import 'package:hellofarmer/Core/cores.dart';
import 'package:hellofarmer/Core/imagens.dart';
import 'package:hellofarmer/Model/carrinho.dart';
import 'package:hellofarmer/Model/produto.dart';
import 'package:hellofarmer/Providers/utilizador_provider.dart';
import 'package:hellofarmer/Services/basedados.dart';
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
    final user = Provider.of<UtilizadorProvider>(context, listen: false).utilizador;
    final dbService = BancoDadosServico();

    try {
      // 1. Buscar lista de IDs no carrinho
      final cartSnapshot = await dbService.read(
        caminho: "users/${user?.idUtilizador}/cartProductsList",
      );

      if (cartSnapshot != null && cartSnapshot.value != null) {
        final List<String> productIds = List<String>.from(
          cartSnapshot.value as List,
        );

        // 2. Buscar detalhes de cada produto
        final List<Produto> products = [];
        final Map<String, int> productQuantities = {};

        for (String id in productIds) {
          final produto = await dbService.obterProdutoPorId(id);
          if (produto != null) {
            products.add(produto);
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

      if(!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao carregar carrinho: $e')));
    }
  }

  Future<void> _updateQuantity(String productId, int newQuantity) async {
    
    final product = cartProducts.firstWhere(
      (p) => p.idProduto == productId,
      orElse:
          () => Produto(
            idProduto: '',
            nomeProduto: '',
            preco: 0,
            quantidade: 0,
            idLoja: '', 
            categoria: '', 
            imagem: '', 
            isAsset: false, 
            descricao: '',
            unidadeMedida: '', 
            data: DateTime.now(),
          ),
    );

    
    if (newQuantity < 1) {
      newQuantity = 1; 

    } else if (newQuantity > product.quantidade) {
      newQuantity = product.quantidade; 

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
    final user = Provider.of<UtilizadorProvider>(context, listen: false).utilizador;
    final dbService = BancoDadosServico();

    try {
      // 1. Buscar lista atual
      final cartSnapshot = await dbService.read(
        caminho: "users/${user?.idUtilizador}/cartProductsList",
      );

      if (cartSnapshot != null && cartSnapshot.value != null) {
        List<String> productIds = List<String>.from(cartSnapshot.value as List);

        // 2. Remover o item
        productIds.remove(productId);

        // 3. Atualizar na base de dados
        await dbService.update(
          caminho: "users/${user?.idUtilizador}/cartProductsList",
          dados: productIds,
        );

        // 4. Atualizar estado local
        setState(() {
          cartProducts.removeWhere((p) => p.idProduto == productId);
          quantities.remove(productId);
        });
      }
    } catch (e) {
      if(!mounted) return;
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
        backgroundColor: PaletaCores.corPrimaria(context),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Expanded(
            child:
                isLoading
                    ? const Center(child: CircularProgressIndicator(color: Colors.blueAccent,))
                    : cartProducts.isEmpty
                    ? const Center(child: Text('Seu carrinho está vazio'))
                    : ListView.separated(
                      itemCount: cartProducts.length,
                      separatorBuilder: (context, index) => Divider(height: 1),

                      itemBuilder: (context, index) {
                        final product = cartProducts[index];
                        return ItemCarrinhoWidget(
                          item: {
                            'name': product.nomeProduto,
                            'price': product.preco,
                            'quantity': quantities[product.idProduto] ?? 1.0,
                            'maxQuantity': product.quantidade,
                            'image': Imagens.alface,
                            'inStock': product.quantidade > 0,
                          },
                          aoAlterarQuantidade: (newQuantity) {
                            _updateQuantity(product.idProduto, newQuantity);
                          },
                          aoRemover: () {
                            _removeItem(product.idProduto);
                          },
                        );
                      },
                    ),
          ),
          if (cartProducts.isNotEmpty)
            TotalCarrinhoWidget(
              itensCarrinho:
                  cartProducts
                      .map(
                        (p) => Carrinho(
                          produto: p,
                          quantidade: quantities[p.idProduto] ?? 1,
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
