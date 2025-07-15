import 'package:flutter/foundation.dart';
import 'package:hellofarmer/Model/encomenda.dart';
import 'package:hellofarmer/Model/produtos.dart';
import 'package:hellofarmer/Model/store.dart';
// import 'package:hellofarmer/Providers/user_provider.dart';
import 'package:hellofarmer/Services/database_service.dart';

class StoreProvider with ChangeNotifier {
  final List<Store> _stores = [];
  final List<Produtos> _products = [];
  // final List<Encomenda> _encomendas = [];

  List<Store> get userStore => _stores;

  final DatabaseService _dbService = DatabaseService();

  Stream<List<Store>> getUserStores(String userId) {
    

    return _dbService.getUserStoresIDs(userId).asyncExpand((storeIds) {
      if (storeIds.isEmpty) return Stream.value([]);

      // Busca todas as lojas em paralelo
      final storeFutures =
          storeIds.map((id) => _dbService.getStore(id)).toList();

      return Stream.fromFuture(Future.wait(storeFutures)).map((stores) {
        return stores.whereType<Store>().toList();
      });
    });
  }


  Stream<List<Produtos>> getStoreProducts(String storeId) {
    return _dbService.getProdutosIdsDaLoja(storeId).asyncExpand((productIds) {
      if (productIds.isEmpty) return Stream.value([]);

      final productFutures = productIds.map((id) => _dbService.getProdutoById(id)).toList();
      
      return Stream.fromFuture(Future.wait(productFutures)).map((products) {
        return products.whereType<Produtos>().toList();
      });
    });
  }


  Future<void> addProductToStore({
    required String storeId,
    required String productId,
    required Produtos produto,
  }) async {
    try {
      // 1. Adiciona o produto à coleção geral
      await _dbService.create(
        path: 'products/$productId',
        data: produto.toJson(),
      );

      // 2. Adiciona o ID à lista da loja
      final snapshot = await _dbService.read(
        path: 'stores/$storeId/listProductsId',
      );

      List<String> currentIds = [];
      if (snapshot != null && snapshot.value is List) {
        currentIds = List<String>.from(snapshot.value as List);
      }

      if (!currentIds.contains(productId)) {
        currentIds.add(productId);
        await _dbService.update(
          path: 'stores/$storeId/listProductsId',
          data: currentIds,
        );
      }

      // 3. Atualiza o estado local
      _products.add(produto);
      notifyListeners();
    } catch (e) {
      debugPrint('Erro ao adicionar produto à loja: $e');
      rethrow;
    }
  }


  Future<void> deleteProduct({
    required String storeId,
    required String productId,
  }) async {
    try {
      // Remove da lista da loja
      final currentIds = await _dbService.read(
        path: 'stores/$storeId/listProductsId',
      );
      
      if (currentIds != null && currentIds.value is List) {
        final updatedIds = List<String>.from(currentIds.value as List)..remove(productId);
        await _dbService.update(
          path: 'stores/$storeId/listProductsId',
          data: updatedIds,
        );
      }

      // Remove o produto
      await _dbService.delete(path: 'produtos/$productId');
      
      notifyListeners();
    } catch (e) {
      debugPrint('Erro ao remover produto: $e');
      rethrow;
    }
  }

  Future<void> updateProduct(Produtos produto) async {
    try {
      await _dbService.update(
        path: 'produtos/${produto.idProduto}',
        data: produto.toJson(),
      );
      notifyListeners();
    } catch (e) {
      debugPrint('Erro ao atualizar produto: $e');
      rethrow;
    }
  }

  Future<void> addStore(Store store) async {
    try {
      // Add to local state
      if (!_stores.any((s) => s.idLoja == store.idLoja)) {
        _stores.add(store);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error adding store to provider: $e');
      rethrow;
    }
  }
}
