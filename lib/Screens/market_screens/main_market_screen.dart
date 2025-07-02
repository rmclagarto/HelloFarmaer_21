// import 'package:flutter/material.dart';
// import 'package:projeto_cm/Core/constants.dart';
// import 'package:projeto_cm/Model/custom_user.dart';
// import 'package:projeto_cm/Widgets/market_widgets/category_selector.dart';
// import 'package:projeto_cm/Widgets/market_widgets/produtcts_grid.dart';
// import 'package:projeto_cm/Widgets/market_widgets/searchBox.dart';

// class MarketScreen extends StatefulWidget {
//   final CustomUser user;
//   const MarketScreen({super.key, required this.user});

//   @override
//   State<MarketScreen> createState() => _MarketScreenState();
// }

// class _MarketScreenState extends State<MarketScreen> {
//   final TextEditingController _searchController = TextEditingController();
//   bool _isSearching = false;

//   final List<Map<String, String>> products = [
//     {'name': 'Tomate', 'price': '€1.50/kg', 'image': 'assets/img/fruta.jpg', 'store': 'Agrícola Silva', 'category': 'Vegetais'},
//     {'name': 'Batata', 'price': '€0.90/kg', 'image': 'assets/img/fruta.jpg', 'store': 'Horta Fresca', 'category': 'Vegetais'},
//     {'name': 'Maçã', 'price': '€2.00/kg', 'image': 'assets/img/fruta.jpg', 'store': 'Frutas Sabor', 'category': 'Frutas'},
//     {'name': 'Serviço X', 'price': '€15', 'image': 'assets/img/servico.jpg', 'store': 'Serviços Y', 'category': 'Serviços'},
//     // mais produtos...
//   ];

//   int _selectedCategory = 0;
//   final List<String> categories = [
//     'Todos',
//     'Vegetais',
//     'Frutas',
//     'Serviços',
//     'Ofertas',
//   ];

//   @override
//   void dispose() {
//     _searchController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     // Aqui podes adicionar filtro baseado na pesquisa e categoria
//     List<Map<String, String>> filteredProducts = products; // Para já não filtra nada

//     return Scaffold(
//       backgroundColor: Colors.grey[100],
//       appBar: AppBar(
//         backgroundColor: Constants.primaryColor,
//         elevation: 0,
//         centerTitle: true,
//         iconTheme: const IconThemeData(color: Colors.white),
//         title: _isSearching
//             ? TextField(
//                 controller: _searchController,
//                 autofocus: true,
//                 style: const TextStyle(color: Colors.white),
//                 decoration: const InputDecoration(
//                   hintText: 'Pesquisar...',
//                   hintStyle: TextStyle(color: Colors.white54),
//                   border: InputBorder.none,
//                 ),
//                 onSubmitted: (query) {
//                   print('Pesquisando por: $query');
//                 },
//               )
//             : const Text(
//                 'Mercado',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             SearchBox(
//               controller: _searchController,
//               onSubmitted: (query) {
//                 // Pesquisa executada
//                 print('Pesquisa executada: $query');
//               },
//             ),
//             CategorySelector(
//               categories: categories,
//               selectedIndex: _selectedCategory,
//               onSelected: (index) {
//                 setState(() {
//                   _selectedCategory = index;
//                 });
//               },
//             ),
//             ProductsGrid(products: filteredProducts),
//           ],
//         ),
//       ),
//       bottomNavigationBar: _buildBottomNavigationBar(),
//     );
//   }

//   Widget _buildBottomNavigationBar() {
//     return BottomNavigationBar(
//       type: BottomNavigationBarType.fixed,
//       items: const [
//         BottomNavigationBarItem(
//           icon: Icon(Icons.shopping_basket),
//           label: 'Mercado',
//         ),
//         BottomNavigationBarItem(
//           icon: Icon(Icons.add_shopping_cart),
//           label: 'Carrinho',
//         ),
//         BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favoritos'),
//       ],
//       currentIndex: 1, // Carrinho selecionado — ajusta se quiseres
//       selectedItemColor: Constants.primaryColor,
//       unselectedItemColor: Colors.grey,
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:projeto_cm/Core/constants.dart';
import 'package:projeto_cm/Model/custom_user.dart';
import 'package:projeto_cm/Widgets/market_widgets/category_selector.dart';
import 'package:projeto_cm/Widgets/market_widgets/product_card.dart';  // Importa o ProductCard para usar abaixo
import 'package:projeto_cm/Widgets/market_widgets/searchBox.dart';

class MarketScreen extends StatefulWidget {
  final CustomUser user;
  const MarketScreen({super.key, required this.user});

  @override
  State<MarketScreen> createState() => _MarketScreenState();
}

class _MarketScreenState extends State<MarketScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  final List<Map<String, String>> products = [
    {'name': 'Tomate', 'price': '€1.50/kg', 'image': 'assets/img/fruta.jpg', 'store': 'Agrícola Silva', 'category': 'Vegetais'},
    {'name': 'Batata', 'price': '€0.90/kg', 'image': 'assets/img/fruta.jpg', 'store': 'Horta Fresca', 'category': 'Vegetais'},
    {'name': 'Maçã', 'price': '€2.00/kg', 'image': 'assets/img/fruta.jpg', 'store': 'Frutas Sabor', 'category': 'Frutas'},
    {'name': 'Serviço X', 'price': '€15', 'image': 'assets/img/servico.jpg', 'store': 'Serviços Y', 'category': 'Serviços'},
    // mais produtos...
  ];

  int _selectedCategory = 0;
  final List<String> categories = [
    'Todos',
    'Vegetais',
    'Frutas',
    'Serviços',
    'Ofertas',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Filtra produtos pela categoria selecionada
    List<Map<String, String>> filteredProducts = _selectedCategory == 0
        ? products
        : products.where((p) => p['category'] == categories[_selectedCategory]).toList();

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Constants.primaryColor,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        title: _isSearching
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
                });
              },
            ),
            // Se categoria "Todos", mostra blocos horizontais para cada categoria (exceto "Todos")
            if (_selectedCategory == 0)
              ...categories.skip(1).map((category) {
                final catProducts = products.where((p) => p['category'] == category).toList();
                if (catProducts.isEmpty) return const SizedBox.shrink();
                return CategoryHorizontalList(
                  categoryName: category,
                  products: catProducts,
                  onShowAll: () {
                    print('Show all products for category: $category');
                    // Aqui podes navegar para uma página que mostra todos produtos desta categoria
                  },
                );
              }).toList()
            else
              // Se estiver numa categoria específica, mostra os produtos dessa categoria numa grid simples
              Padding(
                padding: const EdgeInsets.all(16),
                child: Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: filteredProducts.map((product) => SizedBox(
                    width: (MediaQuery.of(context).size.width / 2) - 24,
                    child: ProductCard(product: product),
                  )).toList(),
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
      currentIndex: 1, // Carrinho selecionado — ajusta se quiseres
      selectedItemColor: Constants.primaryColor,
      unselectedItemColor: Colors.grey,
    );
  }
}

// Widget que mostra os produtos numa lista horizontal, com título e botão Show All
class CategoryHorizontalList extends StatelessWidget {
  final String categoryName;
  final List<Map<String, String>> products;
  final VoidCallback onShowAll;

  const CategoryHorizontalList({
    super.key,
    required this.categoryName,
    required this.products,
    required this.onShowAll,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 8, left: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título da categoria + botão Show All
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                categoryName,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: onShowAll,
                child: const Text('Show All'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 220, // altura fixa para os cartões
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: products.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final product = products[index];
                return SizedBox(
                  width: 140,
                  child: ProductCard(product: product),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
