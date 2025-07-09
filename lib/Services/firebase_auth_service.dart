
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
        return CustomUser(
          id: user.uid,
          name: "", // Default empty name - you can collect this separately
          email: user.email ?? email,
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
          id: user.uid,
          name: user.displayName ?? '',
          email: user.email ?? email,
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

  // Future<void> resetPassword(String email) async {
  //   try {
  //     await _auth.sendPasswordResetEmail(email: email);
  //   } catch (e) {
  //     debugPrint("\n Erro ao enviar e-mail de recuperação: $e \n");
  //     rethrow;
  //   }
  // }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  CustomUser? get currentUser {
    final user = _auth.currentUser;
    return user != null ? CustomUser.fromFirebaseUser(user) : null;
  }
}



// import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
// import 'package:flutter/material.dart';

// class FirebaseAuthService {
//   final fb_auth.FirebaseAuth _auth = fb_auth.FirebaseAuth.instance;

//   fb_auth.User? get currentUser => _auth.currentUser;

//   Future<fb_auth.User?> registerWithEmailPassword(
//     String email, 
//     String password,
//   ) async {
//     try {
//       final result = await _auth.createUserWithEmailAndPassword(
//         email: email, 
//         password: password,
//       );
//       return result.user;
//     } catch (e) {
//       debugPrint("Auth Error: $e");
//       return null;
//     }
//   }


//   Future<fb_auth.User?> signInWithEmailPassword(
//     String email, 
//     String password,
//   ) async {
//     try {
//       final result = await _auth.signInWithEmailAndPassword(
//         email: email, 
//         password: password,
//       );
//       return result.user;
//     } catch (e) {
//       debugPrint("Auth Error: $e");
//       return null;
//     }
//   }


//   Future<void> signOut() async {
//     await _auth.signOut();
//   }

//   Future<void> sendPasswordResetEmail(String email) async {
//     await _auth.sendPasswordResetEmail(email: email);
//   }

// }