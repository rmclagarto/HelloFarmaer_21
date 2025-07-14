
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:hellofarmer/Model/custom_user.dart';

class FirebaseAuthService {
  final fb_auth.FirebaseAuth _auth = fb_auth.FirebaseAuth.instance;

  Future<CustomUser?> registerWithEmailPassword(
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

        return CustomUser(
          idUser: user.uid,
          nomeUser: "", // Default empty name - you can collect this separately
          email: user.email ?? email,
        );
      }
    } on fb_auth.FirebaseAuthException catch (e) {
      debugPrint("\n Firebase Auth Error: ${e.code} - ${e.message} \n");
      
    } catch (e) {
      debugPrint("\n General Error: $e \n");
    }
    
    return null;
  }

  Future<CustomUser?> signInWithEmailPassword(
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
        return CustomUser(
          idUser: user.uid,
          nomeUser: user.displayName ?? '',
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

  CustomUser? get currentUser {
    final user = _auth.currentUser;
    return user != null ? CustomUser.fromFirebaseUser(user) : null;
  }
}