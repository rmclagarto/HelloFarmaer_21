import 'package:flutter/material.dart';
import 'package:projeto_cm/Core/constants.dart';
import 'package:projeto_cm/Model/custom_user.dart';
import 'package:projeto_cm/Widgets/market_widgets/category_selector.dart';
import 'package:projeto_cm/Widgets/market_widgets/product_card.dart';
import 'package:projeto_cm/Widgets/market_widgets/search_box.dart';
import 'package:projeto_cm/Widgets/market_widgets/category_horizontal_list.dart';

class MarketScreen extends StatefulWidget {
  final CustomUser user;
  const MarketScreen({super.key, required this.user});

  @override
  State<MarketScreen> createState() => _MarketScreenState();
}

class _MarketScreenState extends State<MarketScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  int _currentIndex = 0; // índice inicial


  final List<Map<String, String>> products = [
    {
      'name': 'Tomate',
      'price': '€1.50/kg',
      'image': 'assets/img/fruta.jpg',
      'store': 'Agrícola Silva',
      'category': 'Vegetais',
    },
    {
      'name': 'Batata',
      'price': '€0.90/kg',
      'image': 'assets/img/fruta.jpg',
      'store': 'Horta Fresca',
      'category': 'Vegetais',
    },
    {
      'name': 'Maçã',
      'price': '€2.00/kg',
      'image': 'assets/img/fruta.jpg',
      'store': 'Frutas Sabor',
      'category': 'Frutas',
    },
    {
      'name': 'Serviço X',
      'price': '€15',
      'image': 'assets/img/servico.jpg',
      'store': 'Serviços Y',
      'category': 'Serviços',
    },
    {
      'name': 'Oferta y',
      'price': '€15',
      'image': 'assets/img/servico.jpg',
      'store': 'Oferta Y',
      'category': 'Ofertas',
    },
  ];

  List<Map<String, String>> _filteredProducts = [];

  int _selectedCategory = 0;
  final List<String> categories = [
    'Todos',
    'Ofertas',
    'Vegetais',
    'Frutas',
    'Serviços',
    'Bancas',
  ];

  @override
  void initState() {
    super.initState();
    _filteredProducts = List.from(products);
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();

    setState(() {
      if (query.isEmpty) {
        _filteredProducts =
            _selectedCategory == 0
                ? List.from(products)
                : products
                    .where(
                      (p) => p['category'] == categories[_selectedCategory],
                    )
                    .toList();
      } else {
        _filteredProducts =
            products.where((p) {
              final name = p['name']!.toLowerCase();
              final store = p['store']!.toLowerCase();
              final category = p['category']!.toLowerCase();
              return name.contains(query) ||
                  store.contains(query) ||
                  category.contains(query);
            }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> filteredProducts = _filteredProducts;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Constants.primaryColor,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        title:
            _isSearching
                ? TextField(
                  controller: _searchController,
                  autofocus: true,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: 'Pesquisar...',
                    hintStyle: TextStyle(color: Colors.white54),
                    border: InputBorder.none,
                  ),
                  onSubmitted: (query) {
                    print('Pesquisando por: $query');
                  },
                )
                : const Text(
                  'Mercado',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SearchBox(
              controller: _searchController,
              onSubmitted: (query) {
                print('Pesquisa executada: $query');
              },
            ),
            CategorySelector(
              categories: categories,
              selectedIndex: _selectedCategory,
              onSelected: (index) {
                setState(() {
                  _selectedCategory = index;
                  _onSearchChanged(); // Atualiza filtragem ao mudar categoria
                });
              },
            ),
            if (_selectedCategory == 0 && _searchController.text.isEmpty)
              ...categories.skip(1).map((category) {
                final catProducts =
                    products.where((p) => p['category'] == category).toList();
                if (catProducts.isEmpty) return const SizedBox.shrink();
                return CategoryHorizontalList(
                  categoryName: category,
                  products: catProducts,
                  onShowAll: () {
                    print('Mostrar todos os produtos da categoria: $category');
                  },
                );
              }).toList()
            else
              Padding(
                padding: const EdgeInsets.all(16),
                child:
                    filteredProducts.isEmpty
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
                              filteredProducts
                                  .map(
                                    (product) => SizedBox(
                                      width:
                                          (MediaQuery.of(context).size.width /
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
      currentIndex: 0, // Mercado selecionado
      selectedItemColor: Constants.primaryColor,
      unselectedItemColor: Colors.grey,
      onTap: (index) {
        setState(() {
          _currentIndex = index;
          /*
            index = 1 -> carrinho
            index = 2 -> favoritos
            index = 0 -> mercado(main store)
           */
        });
      },
    );
  }
}
