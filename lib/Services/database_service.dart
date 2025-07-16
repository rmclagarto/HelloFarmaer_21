import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:hellofarmer/Model/produtos.dart';
import 'package:hellofarmer/Model/store.dart';

class DatabaseService {
  final database = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL:
        'https://hello-farmer-cm-2025-c2db6-default-rtdb.europe-west1.firebasedatabase.app/',
  );

  Future<void> create({required String path, required dynamic data}) async {
    final DatabaseReference ref = database.ref().child(path);

    try {
      await ref.set(data);
    } catch (e) {
      debugPrint('\n\n\n\nErro ao criar dados no caminho $path: $e');
      rethrow;
    }
  }

  Future<DataSnapshot?> read({required String path}) async {
    final DatabaseReference ref = database.ref().child(path);
    final DataSnapshot snapshot = await ref.get();
    return snapshot.exists ? snapshot : null;
  }

  Future<void> update({required String path, required dynamic data}) async {
    final DatabaseReference ref = database.ref().child(path);

    if (data is List) {
      await ref.set(data); // Usa set() para listas
    } else {
      await ref.update(data as Map<String, dynamic>); // Usa update() para mapas
    }
  }

  Future<void> delete({required String path}) async {
    final DatabaseReference ref = database.ref().child(path);
    return ref.remove();
  }

  Stream<List<String>> getUserStoresIDs(String userID) {
    final ref = database.ref().child('users/${userID}/myStoreList');
    return ref.onValue.map((event) {
      final data = event.snapshot.value;
      if (data == null || data == false) return [];
      if (data is List) {
        return data.whereType<String>().toList();
      }
      return [];
    });
  }


  Future<Store?> getStore(String storeID) async {
    final snapshot = await database.ref().child('stores/${storeID}').get();
    if (snapshot.exists) {
      return Store.fromJson(Map<String, dynamic>.from(snapshot.value as Map));
    }
    return null;
  }

  Stream<List<String>> getProdutosIdsDaLoja(String storeId) {
    final ref = database.ref().child('stores/$storeId/listProductsId');
    return ref.onValue.map((event) {
      final data = event.snapshot.value;
      if (data == null) return [];
      if (data is List) return data.whereType<String>().toList();
      return [];
    });
  }

  Future<Produtos?> getProdutoById(String produtoId) async {
    final snapshot = await database.ref().child('products/$produtoId').get();
    if (snapshot.exists) {
      return Produtos.fromJson(
        Map<String, dynamic>.from(snapshot.value as Map),
      );
    }
    return null;
  }
  
}
