import 'package:flutter/material.dart';
import 'package:hellofarmer/Core/cores.dart';
import 'package:hellofarmer/Core/imagens.dart';
import 'package:hellofarmer/Model/produto.dart';
import 'package:hellofarmer/Providers/utilizador_provider.dart';
import 'package:hellofarmer/Screens/market_screens/product_detail_screen.dart';
import 'package:hellofarmer/Services/basedados.dart';
import 'package:provider/provider.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final BancoDadosServico _dbService = BancoDadosServico();
  List<Produto> _favorites = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final user = Provider.of<UtilizadorProvider>(context, listen: false).utilizador;

    try {
      // 1. Buscar lista de IDs de favoritos
      final favoritesSnapshot = await _dbService.read(
        caminho: 'users/${user?.idUtilizador}/favoritos',
      );

      if (favoritesSnapshot == null || favoritesSnapshot.value == null) {
        setState(() {
          _favorites = [];
          _isLoading = false;
        });
        return;
      }

      List<String> favoriteIds = [];
      if (favoritesSnapshot.value is List) {
        favoriteIds = List<String>.from(favoritesSnapshot.value as List);
      } else if (favoritesSnapshot.value is Map) {
        favoriteIds =
            (favoritesSnapshot.value as Map).keys.cast<String>().toList();
      }

      // 2. Buscar detalhes de cada produto favorito
      List<Produto> loadedFavorites = [];
      for (String productId in favoriteIds) {
        final productSnapshot = await _dbService.read(
          caminho: 'products/$productId',
        );

        if (productSnapshot != null && productSnapshot.value != null) {
          loadedFavorites.add(
            Produto.fromJson(
              Map<String, dynamic>.from(productSnapshot.value as Map),
            ),
          );
        }
      }

      setState(() {
        _favorites = loadedFavorites;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao carregar favoritos: $e')));
    }
  }

  Future<void> _removeFavorite(String productId) async {
    final user = Provider.of<UtilizadorProvider>(context, listen: false).utilizador;

    try {
      // 1. Buscar lista atual
      final favoritesSnapshot = await _dbService.read(
        caminho: 'users/${user?.idUtilizador}/favorites',
      );

      if (favoritesSnapshot == null || favoritesSnapshot.value == null) return;

      List<String> favoriteIds = [];
      if (favoritesSnapshot.value is List) {
        favoriteIds = List<String>.from(favoritesSnapshot.value as List);
      } else if (favoritesSnapshot.value is Map) {
        favoriteIds =
            (favoritesSnapshot.value as Map).keys.cast<String>().toList();
      }

      // 2. Remover o produto
      favoriteIds.remove(productId);

      // 3. Atualizar no Firebase
      await _dbService.update(
        caminho: 'users/${user?.idUtilizador}/favorites',
        dados: favoriteIds,
      );

      // 4. Atualizar lista local
      setState(() {
        _favorites.removeWhere((p) => p.idProduto == productId);
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Removido dos favoritos')));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao remover favorito: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Favoritos",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: PaletaCores.corPrimaria(context),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator(color: Colors.blueAccent,))
              : _favorites.isEmpty
              ? const Center(
                child: Text(
                  "Ainda não adicionaste favoritos.",
                  style: TextStyle(fontSize: 16),
                ),
              )
              : RefreshIndicator(
                onRefresh: _loadFavorites,
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _favorites.length,
                  itemBuilder: (context, index) {
                    final Produto produto = _favorites[index];

                    return Dismissible(
                      key: Key(produto.idProduto),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        color: Colors.red,
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      onDismissed: (_) => _removeFavorite(produto.idProduto),
                      child: Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 3,
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(12),
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              Imagens.alface,// produto.imagem,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                            ),
                          ),
                          title: Text(
                            produto.nomeProduto,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Text(
                            "Preço: ${produto.preco}€",
                            style: const TextStyle(fontSize: 14),
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.grey,
                            size: 18,
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (_) =>
                                        ProductDetailScreen(produto: produto),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
    );
  }
}
