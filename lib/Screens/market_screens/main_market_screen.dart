import 'package:flutter/material.dart';
import 'package:hellofarmer/Services/basedados.dart';
import 'package:hellofarmer/Model/produto.dart';
import 'package:hellofarmer/Core/cores.dart';
import 'package:hellofarmer/Model/utilizador.dart';
import 'package:hellofarmer/Widgets/market_widgets/search_box.dart';
import 'package:hellofarmer/Widgets/market_widgets/cartao_produto.dart';
import 'package:hellofarmer/Screens/market_screens/cart_screen.dart';
import 'package:hellofarmer/Screens/market_screens/favorites_screen.dart';
import 'package:hellofarmer/Widgets/market_widgets/selecionador_categoria.dart';
// import 'package:hellofarmer/Widgets/market_widgets/category_horizontal_list.dart';

class MarketScreen extends StatefulWidget {
  final Utilizador user;

  const MarketScreen({super.key, required this.user});

  @override
  State<MarketScreen> createState() => _MarketScreenState();
}

class _MarketScreenState extends State<MarketScreen> {
  final TextEditingController _searchController = TextEditingController();
  final BancoDadosServico _dbService = BancoDadosServico();

  int _currentIndex = 0;
  int _selectedCategory = 0;

  final List<String> categories = ['Todos', 'Ofertas', 'Vegetais', 'Frutas'];

  List<Produto> _allProducts = [];
  List<Produto> _filteredProducts = [];
  // bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _loadProdutos();
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadProdutos() async {
    final produtos = await fetchProdutos();
    setState(() {
      _allProducts = produtos;
      _filteredProducts = produtos;
      // _isLoading = false;
    });
  }

  Future<List<Produto>> fetchProdutos() async {
    try {
      // Get all products
      final allProductsSnapshot = await _dbService.read(caminho: 'products');
      if (allProductsSnapshot == null || allProductsSnapshot.value == null) {
        return [];
      }

      // Get user's stores
      final myStoreListSnapshot = await _dbService.read(
        caminho: 'users/${widget.user.idUtilizador}/minhasLojas',
      );

      // If user has no stores, return all products
      if (myStoreListSnapshot == null || myStoreListSnapshot.value == null) {
        return _convertProductsData(allProductsSnapshot.value!);
      }

      // Extract store IDs
      final storesIds = _extractStoreIds(myStoreListSnapshot.value!);
      if (storesIds.isEmpty) {
        return _convertProductsData(allProductsSnapshot.value!);
      }

    
      final productIdsFromStores = await _getProductIdsFromStores(storesIds);

    
      return _filterProducts(allProductsSnapshot.value!, productIdsFromStores);
    } catch (e) {
      debugPrint('Error fetching products: $e');
      return [];
    }
  }

  List<String> _extractStoreIds(dynamic storeListData) {
    if (storeListData is List) {
      return storeListData.whereType<String>().toList();
    } else if (storeListData is Map) {
      return storeListData.keys.whereType<String>().toList();
    }
    return [];
  }

  Future<Set<String>> _getProductIdsFromStores(List<String> storesIds) async {
    final Set<String> productIdsFromStores = {};

    for (var storeId in storesIds) {
      try {
        final storeProducts = await _dbService.read(
          caminho: 'stores/$storeId/listProductsId',
        );

        if (storeProducts != null &&
            storeProducts.value != null &&
            storeProducts.value is List) {
          final ids = (storeProducts.value! as List).whereType<String>();
          productIdsFromStores.addAll(ids);
        }
      } catch (e) {
        debugPrint('Error getting products from store $storeId: $e');
      }
    }
    return productIdsFromStores;
  }

  List<Produto> _filterProducts(
    dynamic allProductsData,
    Set<String> productIdsToExclude,
  ) {
    final List<Produto> products = [];

    if (allProductsData is Map) {
      for (var productId in allProductsData.keys) {
        if (productId is String && !productIdsToExclude.contains(productId)) {
          final productData = allProductsData[productId];
          if (productData != null && productData is Map) {
            try {
              products.add(
                Produto.fromJson(Map<String, dynamic>.from(productData)),
              );
            } catch (e) {
              debugPrint('Error parsing product $productId: $e');
            }
          }
        }
      }
    }
    return products;
  }

  List<Produto> _convertProductsData(dynamic productsData) {
    if (productsData is! Map) return [];

    return productsData.entries
        .map((entry) {
          try {
            return Produto.fromJson(Map<String, dynamic>.from(entry.value));
          } catch (e) {
            debugPrint('Error converting product ${entry.key}: $e');
            return null;
          }
        })
        .whereType<Produto>()
        .toList();
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();

    setState(() {
      List<Produto> baseList;

      if (_selectedCategory == 0) {
        // Todos - todos os produtos que não são do usuário
        baseList = List.from(_allProducts);
      } else if (_selectedCategory == 1) {
        // Ofertas - produtos promovidos
        baseList = _allProducts.where((p) => p.promovido == true).toList();
      } else {
        // Categoria específica (Vegetais ou Frutas)
        final category = categories[_selectedCategory];
        baseList = _allProducts.where((p) => p.categoria == category).toList();
      }

      if (query.isEmpty) {
        _filteredProducts = baseList;
      } else {
        _filteredProducts =
            baseList.where((p) {
              final title = p.nomeProduto.toLowerCase();
              final category = p.categoria.toLowerCase();
              return title.contains(query) || category.contains(query);
            }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: PaletaCores.corPrimaria(context),
        title: Text(
          "Mercado",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CaixaPesquisa(
              controller: _searchController,
              onSubmitted: (pesquisa) {
                
                debugPrint('Pesquisa executada: $pesquisa');
              },
            ),

            SeletorCategoria(
              categorias: categories,
              indiceSelecionado: _selectedCategory,
              aoSelecionar: (index) {
                setState(() {
                  _selectedCategory = index;
                  _onSearchChanged();
                });
              },
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child:
                  _filteredProducts.isEmpty
                      ? const Center(
                        child: Text(
                          'Nenhum produto encontrado.',
                          style: TextStyle(fontSize: 16),
                        ),
                      )
                      : GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _filteredProducts.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2, // 2 produtos por linha
                              crossAxisSpacing:
                                  16, // espaço horizontal entre os itens
                              mainAxisSpacing:
                                  16, // espaço vertical entre os itens
                              childAspectRatio:
                                  0.7, // ajuste a proporção conforme o design do ProductCard
                            ),
                        itemBuilder: (context, index) {
                          final product = _filteredProducts[index];
                          return CartaoProduto(produto: product);
                        },
                      ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_basket),
          label: 'Mercado',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add_shopping_cart),
          label: 'Carrinho',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favoritos'),
      ],
      currentIndex: 0,
      selectedItemColor: PaletaCores.corPrimaria(context),
      unselectedItemColor: Colors.grey,
      onTap: (index) {
        setState(() {
          _currentIndex = index;

          switch (_currentIndex) {
            case 1:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CartScreen()),
              );
              break;

            case 2:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FavoritesScreen()),
              );
              break;
          }
        });
      },
    );
  }
}
