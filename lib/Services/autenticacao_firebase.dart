
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:hellofarmer/Model/utilizador.dart';
import 'package:hellofarmer/Services/basedados.dart';

class AutenticacaoFirebaseServico {
  final fb_auth.FirebaseAuth _autenticacao = fb_auth.FirebaseAuth.instance;
  final BancoDadosServico _bancoDados = BancoDadosServico();

  // Regista um novo utilizador com email e palavra-passe.
  Future<Utilizador?> registarComEmailEPassword(
    String email,
    String senha,
  ) async {
    try {
      final resultado = await _autenticacao.createUserWithEmailAndPassword(
        email: email,
        password: senha,
      );

      final utilizador = resultado.user;

      if (utilizador != null) {
        await utilizador.reload();

        // Cria um objeto personalizado do utilizador
        final Utilizador novoUtilizador = Utilizador(
          idUtilizador: utilizador.uid,
          nomeUtilizador: '',
          email: utilizador.email ?? email,
          telefone: '',
          historicoCompras: [],
          minhasLojas: [],
          imagemPerfil: '',
        );

        // Guarda os dados na base de dados
        await _bancoDados.create(
          caminho: 'users/${utilizador.uid}',
          dados: novoUtilizador.toJson(),
        );

        return novoUtilizador;
      }
    } on fb_auth.FirebaseAuthException catch (e) {
      debugPrint("\n[FirebaseAuthException] ${e.code}: ${e.message}\n");
    } catch (e) {
      debugPrint("\n General Error: $e \n");
    }
    
    return null;
  }


  // Inicia sessão com email e palavra-passe.
  Future<Utilizador?> iniciarSessaoComEmailEPassword(
    String email,
    String senha,
  ) async {
    try {
      final resultado = await _autenticacao.signInWithEmailAndPassword(
        email: email,
        password: senha,
      );

      final utilizador = resultado.user;

      if (utilizador != null) {
        return Utilizador(
          idUtilizador: utilizador.uid,
          nomeUtilizador: utilizador.displayName ?? '',
          email: utilizador.email ?? email,
          telefone: '',
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


  // Termina a sessão atual.
  Future<void> terminarSessao() async {
    await _autenticacao.signOut();
  }

  // Retorna o utilizador autenticado atual como objeto personalizado.
  Utilizador? get utilizadorAtual {
    final user = _autenticacao.currentUser;
    return user != null ? Utilizador.fromFirebaseUser(user) : null;
  }
}