// import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:hellofarmer/Core/constants.dart';
import 'package:hellofarmer/Core/image_assets.dart';
import 'package:hellofarmer/Model/custom_user.dart';
import 'package:hellofarmer/Model/produtos.dart';
import 'package:hellofarmer/Providers/cart_provider.dart';
import 'package:hellofarmer/Screens/market_screens/cart_screen.dart';
import 'package:hellofarmer/Widgets/market_widgets/category_horizontal_list.dart';
import 'package:hellofarmer/Widgets/market_widgets/category_selector.dart';
import 'package:hellofarmer/Widgets/market_widgets/product_card.dart';
import 'package:hellofarmer/Widgets/market_widgets/search_box.dart';
import 'package:provider/provider.dart';

class MarketScreen extends StatefulWidget {
  final CustomUser user;

  const MarketScreen({super.key, required this.user});

  @override
  State<MarketScreen> createState() => _MarketScreenState();
}

class _MarketScreenState extends State<MarketScreen> {
  final TextEditingController _searchController = TextEditingController();

  int _currentIndex = 0;
  int _selectedCategory = 0;

  // Substitua por streams do Firestore
  // late Stream<QuerySnapshot> _productsStream;

  final List<String> categories = ['Todos', 'Ofertas', 'Vegetais', 'Frutas'];
  List<Produtos> products = [
    Produtos.simple(
      title: "Alface",
      price: "10.0",
      image: ImageAssets.alface,
      categoria: "Ofertas",
      stock: 4,
    ),
    Produtos.simple(
      title: "Alface 1",
      price: "10.0",
      image: ImageAssets.fruta,
      categoria: "Vegetais",
      stock: 2,
    ),
    Produtos.simple(
      title: "Alface 2",
      price: "10.0",
      image: ImageAssets.fruta,
      categoria: "Vegetais",
      stock: 1,
    ),
    Produtos.simple(
      title: "Alface 3",
      price: "10.0",
      image: ImageAssets.fruta,
      categoria: "Vegetais",
      stock: 0,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _filteredProducts = List.from(products);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  List<Produtos> _filteredProducts = [];

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();

    setState(() {
      if (query.isEmpty) {
        _filteredProducts =
            _selectedCategory == 0
                ? List.from(products)
                : products
                    .where((p) => p.categoria == categories[_selectedCategory])
                    .toList();
      } else {
        _filteredProducts =
            products.where((p) {
              final title = p.title.toLowerCase();
              final category = p.categoria?.toLowerCase() ?? '';
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
        backgroundColor: Constants.primaryColor,
        title: Text("Mercado", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Consumer<CartProvider>(
        builder: (context, cartProvider, child) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SearchBox(
                  controller: _searchController,
                  onSubmitted: (pesquisa) {
                    // Usar as query para pesquisar na loja
                    debugPrint('Pesquisa executada: $pesquisa');
                  },
                ),

                CategorySelector(
                  categories: categories,
                  selectedIndex: _selectedCategory,
                  onSelected: (index) {
                    setState(() {
                      _selectedCategory = index;
                      _onSearchChanged();
                    });
                  },
                ),
                if (_selectedCategory == 0 && _searchController.text.isEmpty)
                  ...categories.skip(1).map((category) {
                    final catProducts =
                        products.where((p) => p.categoria == category).toList();

                    if (catProducts.isEmpty) return const SizedBox.shrink();
                    return CategoryHorizontalList(
                      categoryName: category,
                      products: catProducts,
                      onShowAll: () {
                        print(
                          'Mostrar todos os produtos da categoria: $category',
                        );
                      },
                    );
                  })
                else
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
                            : Wrap(
                              spacing: 16,
                              runSpacing: 16,
                              children:
                                  _filteredProducts
                                      .map(
                                        (product) => SizedBox(
                                          width:
                                              (MediaQuery.of(
                                                    context,
                                                  ).size.width /
                                                  2) -
                                              24,
                                          child: ProductCard(product: product),
                                        ),
                                      )
                                      .toList(),
                            ),
                  ),
              ],
            ),
          );
        },
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
      selectedItemColor: Constants.primaryColor,
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
          }
        });
      },
    );
  }
}
