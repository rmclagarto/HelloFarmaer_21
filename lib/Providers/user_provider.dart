import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:flutter/material.dart';
import 'package:hellofarmer/Model/custom_user.dart';
import 'package:hellofarmer/Model/store.dart';
import 'package:hellofarmer/Services/database_service.dart';

class UserProvider with ChangeNotifier {
  final DatabaseService _dbService = DatabaseService();
  final fb_auth.FirebaseAuth _auth = fb_auth.FirebaseAuth.instance;

  
  CustomUser? _user;
  CustomUser? get user => _user;

  Future<void> loadUserAccount(String uid) async {
    final snapshot = await _dbService.read(path: 'users/$uid');

    if (snapshot != null) {
      final data = Map<String, dynamic>.from(snapshot.value as Map);

       if (data['historicoCompras'] is! List) {
      data['historicoCompras'] = [];
    }
    if (data['myStoreList'] is! List) {
      data['myStoreList'] = [];
    }

      final user = CustomUser(
        idUser: data['idUser'],
        nomeUser: data['nomeUser'],
        email: data['email'],
        telefone: data['telefone'],
        grupo: data['grupo'],
        historicoCompras: List<String>.from(data['historicoCompras'] ?? []),
        myStoreList: List<String>.from(data['myStoreList'] ?? []),
        imagemPerfil: data['imagemPerfil'],
      );

      setUser(user);
    } else {
      debugPrint('[loadUser] Nenhum dado encontrado para o UID: $uid');
      throw Exception("Utilizador não encontrado.");
    }
  }

  Future<void> deleteUserAccount() async {
    final fbUser = _auth.currentUser;
    if(fbUser== null){
      throw Exception("Nenhum utilizador autenticado");
    }

    final uid = fbUser.uid;




    if (_user == null) return;

    try {
      // await _dbService.delete(path: 'users/${_user!.idUser}');

      await _dbService.delete(path: 'users/$uid'); 
      await fbUser.delete();
      
      clearUser();
    } catch (e) {
      debugPrint('[deleteUserAccount] Erro: $e');
      rethrow;
    }
  }


  Future<void> addStoreToUser(String storeId) async {
  if (_user == null) return;
  
  final currentStores = List<String>.from(_user!.myStoreList ?? []);
  
  if (!currentStores.contains(storeId)) {
    currentStores.add(storeId);
    
    // Use set() em vez de update() para listas
    await _dbService.update(
      path: 'users/${_user!.idUser}',
      data: {
        'myStoreList': currentStores,
      },
    );
    
    _user = _user!.copyWith(myStoreList: currentStores);
    notifyListeners();
  }
 
}

  void setUser(CustomUser user) {
    _user = user;
    notifyListeners();
  }

  void updateUser(CustomUser updatedUser) {
    _user = updatedUser;
    notifyListeners();
  }


  void addUserStores(Store store){
    notifyListeners();
  }

  void clearUser() {
    _user = null;
    notifyListeners();
  }
}
