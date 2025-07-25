import 'package:flutter/foundation.dart';
import 'package:hellofarmer/Model/produto.dart';
import 'package:hellofarmer/Model/loja.dart';
import 'package:hellofarmer/Services/basedados.dart';

class LojaProvider with ChangeNotifier {
  final List<Loja> _lojas = [];
  final List<Produto> _produtos = [];
  final BancoDadosServico _bancoDados = BancoDadosServico();


  // Getter que devolve a lista local de lojas do utilizador
  List<Loja> get lojasUtilizador => _lojas;

  
  // Obtém as lojas de um utilizador, com base no seu ID.
  Stream<List<Loja>> obterLojasDoUtilizador(String utilizadorId) {
    return _bancoDados.obterIDsDasLojasDoUtilizador(utilizadorId).asyncExpand((storeIds) {
      if (storeIds.isEmpty) return Stream.value([]);

      // Obtem os dados completos de cada loja atraves do ID
      final futurasLojas =
          storeIds.map((id) => _bancoDados.obterLoja(id)).toList();

      // Aguarda por todas as lojas e filtra apenas as minhas.
      return Stream.fromFuture(Future.wait(futurasLojas)).map((lojas) {
        return lojas.whereType<Loja>().toList();
      });
    });
  }


  //  Obtém todos os produtos de uma loja específica.
  Stream<List<Produto>> obterProdutosDaLoja(String lojaId) {
    return _bancoDados.obterIdsProdutosDaLoja(lojaId).asyncExpand((productIds) {
      if (productIds.isEmpty) return Stream.value([]);

      // Obtém os dados de cada produto
      final produtosFuturos =
          productIds.map((id) => _bancoDados.obterProdutoPorId(id)).toList();

      // Filtra os produtos válidos.
      return Stream.fromFuture(Future.wait(produtosFuturos)).map((products) {
        return products.whereType<Produto>().toList();
      });
    });
  }



  // Adiciona um produto a base de dados e associa-o à loja indicada
  Future<void> adicionarProdutoALoja({
    required String lojaId,
    required String produtoId,
    required Produto produto,
  }) async {
    try {

      // Guarda o produto na base de dados.
      await _bancoDados.create(
        caminho: 'products/$produtoId',
        dados: produto.toJson(),
      );

      // Lê a lista atual de produtos da loja.  
      final snapshot = await _bancoDados.read(
        caminho: 'stores/$lojaId/listProductsId',
      );

      List<String> idsAtuais = [];
      if (snapshot != null && snapshot.value is List) {
        idsAtuais = List<String>.from(snapshot.value as List);
      }

      // Adiciona o novo ID se ainda não existir
      if (!idsAtuais.contains(produtoId)) {
        idsAtuais.add(produtoId);
        await _bancoDados.update(
          caminho: 'stores/$lojaId/listProductsId',
          dados: idsAtuais,
        );
      }

      // Atualiza o estado local.
      _produtos.add(produto);
      notifyListeners();
    } catch (e) {
      debugPrint('Erro ao adicionar produto à loja: $e');
      rethrow;
    }
  }

  // Remove um produto da loja e da base de dados.
  Future<void> removerProduto({
    required String lojaId,
    required String produtoId,
  }) async {
    try {
      // Lê a lista atual de produtos da loja.
      final idsAtuais = await _bancoDados.read(
        caminho: 'stores/$lojaId/listProductsId',
      );

      // Remove o ID do produto da lista e atualiza na base de dados.
      if (idsAtuais != null && idsAtuais.value is List) {
        final listaAtualizada = List<String>.from(idsAtuais.value as List)
          ..remove(produtoId);
        await _bancoDados.update(
          caminho: 'stores/$lojaId/listProductsId',
          dados: listaAtualizada,
        );
      }

      // Apaga o produto da base de dados.
      await _bancoDados.delete(caminho: 'products/$produtoId');

      notifyListeners();
    } catch (e) {
      debugPrint('Erro ao remover produto: $e');
      rethrow;
    }
  }


  // Atualiza os dados de um produto na base de dados.
  Future<void> atualizarProduto(Produto produto) async {
    try {
      await _bancoDados.update(
        caminho: 'products/${produto.idProduto}',
        dados: produto.toJson(),
      );
      notifyListeners();
    } catch (e) {
      debugPrint('Erro ao atualizar produto: $e');
      rethrow;
    }
  }



  // Adiciona uma loja à lista local.
  Future<void> adicionarLoja(Loja loja) async {
    try {
      
      if (!_lojas.any((s) => s.idLoja == loja.idLoja)) {
        _lojas.add(loja);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error adding store to provider: $e');
      rethrow;
    }
  }

  // Remove uma loja completamente (produtos, referência no utilizador, e a loja).
  Future<void> removerLoja({
    required String utilizadorId,
    required String lojaId,
  }) async {
    try {
      
      // Apaga todos os produtos associados à loja.
      final produtosSnapshot = await _bancoDados.read(
        caminho: 'stores/$lojaId/listProductsId',
      );

      final List<String> idsProdutos =
          (produtosSnapshot?.value is List)
              ? List<String>.from(produtosSnapshot!.value as List)
              : [];

      for (final idProduto in idsProdutos) {
        await _bancoDados.delete(caminho: 'products/$idProduto');
        debugPrint('Produto $idProduto apagado');
      }

      // Remove o ID da loja da lista de lojas do utilizador.
      final utilizadorSnapshot = await _bancoDados.read(
        caminho: 'users/$utilizadorId/minhasLojas',
      );
      if (utilizadorSnapshot?.value is List) {
        final List<String> listaActual = List<String>.from(
          utilizadorSnapshot!.value as List,
        );
        if (listaActual.contains(lojaId)) {
          final listaActualizada = List<String>.from(listaActual)..remove(lojaId);

          
          await _bancoDados.update(
            caminho: 'users/$utilizadorId/minhasLojas',
            dados: listaActualizada,
          );
          debugPrint('Loja removida da lista do usuário');
        }
      }

      // Apaga a própria loja.
      await _bancoDados.delete(caminho: 'stores/$lojaId');
      debugPrint('Loja $lojaId deletada');

      //Atualiza o estado local.
      _lojas.removeWhere((loja) => loja.idLoja == lojaId);
      notifyListeners();
    } catch (e) {
      debugPrint('Erro ao excluir loja: $e');
      rethrow;
    }
  }


  // Procura o ID da loja que contém um determinado produto.
  Future<String?> encontrarIdLojaDoProduto(String idProduto) async {
    try {
      // Lê todas as lojas do sistema.
      final lojasSnapshot = await _bancoDados.read(caminho: 'stores');

      if (lojasSnapshot?.value is Map) {
        final mapaLojas = lojasSnapshot!.value as Map;

        // Percorre cada loja para verificar se o produto está listado.
        for (final lojaId in mapaLojas.keys) {
          final produtos = await _bancoDados.read(
            caminho: 'stores/$lojaId/listProductsId',
          );

          if (produtos?.value is List) {
            final idsProdutos = List<String>.from(produtos!.value as List);
            if (idsProdutos.contains(idProduto)) {
              return lojaId as String;
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
