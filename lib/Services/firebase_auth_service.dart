
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:hellofarmer/Model/user.dart';
import 'package:hellofarmer/Services/database_service.dart';

class AutenticacaoFirebaseServico {
  final fb_auth.FirebaseAuth _auth = fb_auth.FirebaseAuth.instance;
  final BancoDadosServico _databaseService = BancoDadosServico();

  Future<Utilizador?> registerWithEmailPassword(
    String email,
    String password,
  ) async {
    try {
      final result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = result.user;

      if (user != null) {

        await user.reload();

        final Utilizador customUser = Utilizador(
          idUtilizador: user.uid,
          nomeUtilizador: '',
          email: user.email ?? email,
          telefone: '',
          historicoCompras: [],
          minhasLojas: [],
          imagemPerfil: '',
        );


        await _databaseService.criar(
          caminho: 'users/${user.uid}',
          dados: customUser.toJson(),
        );

        return customUser;
      }
    } on fb_auth.FirebaseAuthException catch (e) {
      debugPrint("\n Firebase Auth Error: ${e.code} - ${e.message} \n");
      
    } catch (e) {
      debugPrint("\n General Error: $e \n");
    }
    
    return null;
  }

  Future<Utilizador?> signInWithEmailPassword(
    String email,
    String password,
  ) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = result.user;

      if (user != null) {
        return Utilizador(
          idUtilizador: user.uid,
          nomeUtilizador: user.displayName ?? '',
          email: user.email ?? email,
          telefone: '', // Or use a stored value if available

        );
      }
      return null;
    } on fb_auth.FirebaseAuthException catch (e) {
      debugPrint("\n Firebase Auth Error: ${e.code} - ${e.message} \n");
      return null;
    } catch (e) {
      debugPrint("\n General Error: $e \n");
      return null;
    }
  }



  Future<void> signOut() async {
    await _auth.signOut();
  }

  Utilizador? get currentUser {
    final user = _auth.currentUser;
    return user != null ? Utilizador.fromFirebaseUser(user) : null;
  }
}