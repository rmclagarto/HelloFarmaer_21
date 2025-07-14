import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class DatabaseService {
final database = FirebaseDatabase.instanceFor(
  app: Firebase.app(),
  databaseURL: 'https://hello-farmer-cm-2025-c2db6-default-rtdb.europe-west1.firebasedatabase.app/',
);


  Future<void> create({
    required String path,
    required Map<String, dynamic> data,
  }) async {
    final DatabaseReference ref = database.ref().child(path);

    try{
      await ref.set(data);
    }catch(e){
      debugPrint('\n\n\n\nErro ao criar dados no caminho $path: $e');
      rethrow;
    }
  }


  Future<DataSnapshot?> read({required String path}) async {
    final DatabaseReference ref = database.ref().child(path);
    final DataSnapshot snapshot = await ref.get();
    return snapshot.exists ? snapshot : null;
  }


  Future<void> update({
    required String path,
    required Map<String, dynamic> data,
  })async{
    final DatabaseReference ref = database.ref().child(path);
    await ref.update(data);
  }


  Future<void> delete({required String path}) async {
    final DatabaseReference ref = database.ref().child(path);
    return ref.remove();
  }
}
