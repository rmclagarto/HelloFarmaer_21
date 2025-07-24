import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:flutter/material.dart';
import 'package:hellofarmer/Model/user.dart';
import 'package:hellofarmer/Model/store.dart';
import 'package:hellofarmer/Services/database_service.dart';

class UserProvider with ChangeNotifier {
  final BancoDadosServico _dbService = BancoDadosServico();
  final fb_auth.FirebaseAuth _auth = fb_auth.FirebaseAuth.instance;

  
  Utilizador? _user;
  Utilizador? get user => _user;

  Future<void> loadUserAccount(String uid) async {
    final snapshot = await _dbService.read(path: 'users/$uid');

    if (snapshot != null) {
      final data = Map<String, dynamic>.from(snapshot.value as Map);

       if (data['historicoCompras'] is! List) {
      data['historicoCompras'] = [];
    }
    if (data['minhasLojas'] is! List) {
      data['minhasLojas'] = [];
    }

    if (data['meusProdutosFavoritos'] is! List) data['meusProdutosFavoritos'] = [];

      final user = Utilizador(
        idUtilizador: data['idUtilizador'],
        nomeUtilizador: data['nomeUtilizador'],
        email: data['email'],
        telefone: data['telefone'],
        historicoCompras: List<String>.from(data['historicoCompras'] ?? []),
        minhasLojas: List<String>.from(data['minhasLojas'] ?? []),
        meusProdutosFavoritos: List<String>.from(data['meusProdutosFavoritos'] ?? []),
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
  
  final currentStores = List<String>.from(_user!.minhasLojas ?? []);
  
  if (!currentStores.contains(storeId)) {
    currentStores.add(storeId);
    
    // Use set() em vez de update() para listas
    await _dbService.update(
      path: 'users/${_user!.idUtilizador}',
      data: {
        'minhasLojas': currentStores,
      },
    );
    
    _user = _user!.copyWith(minhasLojas: currentStores);
    notifyListeners();
  }
 
}

  void setUser(Utilizador user) {
    _user = user;
    notifyListeners();
  }

  void updateUser(Utilizador updatedUser) {
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
