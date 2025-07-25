import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:hellofarmer/Model/produto.dart';
import 'package:hellofarmer/Model/loja.dart';

class BancoDadosServico {

  final bancoDados = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL:
        'https://hello-farmer-cm-2025-c2db6-default-rtdb.europe-west1.firebasedatabase.app/',
  );

  /// Cria um novo registo no caminho especificado.
  Future<void> create({required String caminho, required dynamic dados}) async {
    final DatabaseReference referencia = bancoDados.ref().child(caminho);

    try {
      await referencia.set(dados);
    } catch (e) {
      debugPrint('\n\n\n\nErro ao criar dados no caminho $caminho: $e');
      rethrow;
    }
  }

  // Lê os dados no caminho indicado.
  Future<DataSnapshot?> read({required String caminho}) async {
    final DatabaseReference referencia = bancoDados.ref().child(caminho);
    final DataSnapshot resultado = await referencia.get();
    return resultado.exists ? resultado : null;
  }


  // Atualiza dados no caminho indicado.
  Future<void> update({required String caminho, required dynamic dados}) async {
    final DatabaseReference ref = bancoDados.ref().child(caminho);

    if (dados is List) {
      await ref.set(dados);
    } else {
      await ref.update(dados as Map<String, dynamic>);
    }
  }


  // Elimina os dados no caminho especificado.
  Future<void> delete({required String caminho}) async {
    final DatabaseReference referencia = bancoDados.ref().child(caminho);
    return referencia.remove();
  }


  // Lê dados continuamente como stream.
  Stream<DatabaseEvent> readAsStream({required String caminho}) {
    return bancoDados.ref().child(caminho).onValue;
  }


  // Obtém uma lista contínua dos IDs das lojas associadas a um utilizador.
  Stream<List<String>> obterIDsDasLojasDoUtilizador(String idUtilizador) {
    final referencia = bancoDados.ref().child('users/$idUtilizador/minhasLojas');
    return referencia.onValue.map((evento) {
      final dados = evento.snapshot.value;
      if (dados == null || dados == false) return [];
      if (dados is List) {
        return dados.whereType<String>().toList();
      }
      return [];
    });
  }


  




  // Obtém os dados de uma loja a partir do ID.
  Future<Loja?> obterLoja(String lojaId) async {
    final snapshot = await bancoDados.ref().child('stores/$lojaId').get();
    if (snapshot.exists) {
      return Loja.fromJson(Map<String, dynamic>.from(snapshot.value as Map));
    }
    return null;
  }

  // Obtém continuamente os IDs dos produtos de uma loja específica.
  Stream<List<String>> obterIdsProdutosDaLoja(String storeId) {
    final referencia = bancoDados.ref().child('stores/$storeId/listProductsId');
    return referencia.onValue.map((event) {
      final dados = event.snapshot.value;
      if (dados == null) return [];
      if (dados is List) return dados.whereType<String>().toList();
      return [];
    });
  }

  // Obtém os dados de um produto específico pelo seu ID.
  Future<Produto?> obterProdutoPorId(String produtoId) async {
    final snapshot = await bancoDados.ref().child('products/$produtoId').get();
    if (snapshot.exists) {
      return Produto.fromJson(
        Map<String, dynamic>.from(snapshot.value as Map),
      );
    }
    return null;
  }
}
