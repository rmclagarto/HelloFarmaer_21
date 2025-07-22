import 'package:flutter/foundation.dart';
import 'package:hellofarmer/Model/produtos.dart';
import 'package:hellofarmer/Model/store.dart';
import 'package:hellofarmer/Services/database_service.dart';

class StoreProvider with ChangeNotifier {
  final List<Store> _stores = [];
  final List<Produtos> _products = [];

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

      final productFutures =
          productIds.map((id) => _dbService.getProdutoById(id)).toList();

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
        final updatedIds = List<String>.from(currentIds.value as List)
          ..remove(productId);
        await _dbService.update(
          path: 'stores/$storeId/listProductsId',
          data: updatedIds,
        );
      }

      // Remove o produto
      await _dbService.delete(path: 'products/$productId');

      notifyListeners();
    } catch (e) {
      debugPrint('Erro ao remover produto: $e');
      rethrow;
    }
  }

  Future<void> updateProduct(Produtos produto) async {
    try {
      await _dbService.update(
        path: 'products/${produto.idProduto}',
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

  Future<void> deleteStore({
    required String userID,
    required String storeID,
  }) async {
    try {
      debugPrint('Iniciando exclusão da loja $storeID para usuário $userID');

      // 1. Deletar produtos da loja
      final productsSnapshot = await _dbService.read(
        path: 'stores/$storeID/listProductsId',
      );

      final List<String> productIds =
          (productsSnapshot?.value is List)
              ? List<String>.from(productsSnapshot!.value as List)
              : [];

      for (final productId in productIds) {
        await _dbService.delete(path: 'products/$productId');
        debugPrint('Produto $productId deletado');
      }

      // 2. Remover a loja da lista do usuário
      final userSnapshot = await _dbService.read(
        path: 'users/$userID/myStoreList',
      );
      if (userSnapshot?.value is List) {
        final List<String> currentList = List<String>.from(
          userSnapshot!.value as List,
        );
        if (currentList.contains(storeID)) {
          final updatedList = List<String>.from(currentList)..remove(storeID);

          // CORREÇÃO AQUI - usar set com o caminho completo
          await _dbService.update(
            path: 'users/$userID/myStoreList',
            data: updatedList,
          );
          debugPrint('Loja removida da lista do usuário');
        }
      }

      // 3. Remover a própria loja
      await _dbService.delete(path: 'stores/$storeID');
      debugPrint('Loja $storeID deletada');

      // 4. Atualizar estado local
      _stores.removeWhere((store) => store.idLoja == storeID);
      notifyListeners();
    } catch (e) {
      debugPrint('Erro ao excluir loja: $e');
      rethrow;
    }
  }

  // Adicione este método no seu StoreProvider
  Future<String?> findStoreIdForProduct(String productId) async {
    try {
      // 1. Obter todas as lojas
      final storesSnapshot = await _dbService.read(path: 'stores');

      if (storesSnapshot?.value is Map) {
        final storesMap = storesSnapshot!.value as Map;

        // 2. Verificar cada loja
        for (final storeId in storesMap.keys) {
          final products = await _dbService.read(
            path: 'stores/$storeId/listProductsId',
          );

          if (products?.value is List) {
            final productIds = List<String>.from(products!.value as List);
            if (productIds.contains(productId)) {
              return storeId as String;
            }
          }
        }
      }
      return null;
    } catch (e) {
      debugPrint('Erro ao buscar loja do produto: $e');
      return null;
    }
  }
}
