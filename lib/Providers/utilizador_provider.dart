import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:flutter/material.dart';
import 'package:hellofarmer/Model/utilizador.dart';
// import 'package:hellofarmer/Model/loja.dart';
import 'package:hellofarmer/Services/basedados.dart';

class UtilizadorProvider with ChangeNotifier {
  final BancoDadosServico _bancoDados = BancoDadosServico();
  final fb_auth.FirebaseAuth _autenticacao = fb_auth.FirebaseAuth.instance;

  
  Utilizador? _utilizador;
  Utilizador? get utilizador => _utilizador;

  Future<void> carregarContaUtilizador(String uid) async {
    final snapshot = await _bancoDados.read(caminho: 'users/$uid');

    if (snapshot != null) {
      final dados = Map<String, dynamic>.from(snapshot.value as Map);

      if (dados['historicoCompras'] is! List) {
        dados['historicoCompras'] = [];
      }

      if (dados['minhasLojas'] is! List) {
        dados['minhasLojas'] = [];
      }

      if (dados['meusProdutosFavoritos'] is! List){ 
        dados['meusProdutosFavoritos'] = [];
      }

      // Criar instância de Utilizador com os dados obtidos
      final utilizador = Utilizador(
        idUtilizador: dados['idUtilizador'],
        nomeUtilizador: dados['nomeUtilizador'],
        email: dados['email'],
        telefone: dados['telefone'],
        historicoCompras: List<String>.from(dados['historicoCompras'] ?? []),
        minhasLojas: List<String>.from(dados['minhasLojas'] ?? []),
        meusProdutosFavoritos: List<String>.from(dados['meusProdutosFavoritos'] ?? []),
        imagemPerfil: dados['imagemPerfil'],
      );

      setUser(utilizador);
    } else {
      debugPrint('[carregarContaUtilizador] Nenhum dado encontrado para o UID: $uid');
      throw Exception("Utilizador não encontrado.");
    }
  }


  // Elimina a conta do utilizador autenticado (Firebase Auth + base de dados).
  Future<void> eliminarContaUtilizador() async {
    final utilizadorFirebase = _autenticacao.currentUser;
    if(utilizadorFirebase == null){
      throw Exception("Nenhum utilizador autenticado");
    }

    final uid = utilizadorFirebase.uid;

    if (_utilizador == null) return;

    try {
      // Apagar registo do utilizador na base de dados
      await _bancoDados.delete(caminho: 'users/$uid'); 

      // Apagar conta Firebase Auth
      await utilizadorFirebase.delete();
      
      // Limpar estado local
      limparUtilizador();
    } catch (e) {
      debugPrint('[eliminarContaUtilizador] Erro: $e');
      rethrow;
    }
  }

  // Adiciona o ID de uma loja à lista `minhasLojas` do utilizador.
  Future<void> adicionarLojaAoUtilizador(String storeId) async {
  if (_utilizador == null) return;
  
  final currentStores = List<String>.from(_utilizador!.minhasLojas ?? []);
  
  if (!currentStores.contains(storeId)) {
    currentStores.add(storeId);
    
    // Atualizar na base de dados
    await _bancoDados.update(
      caminho: 'users/${_utilizador!.idUtilizador}',
      dados: {
        'minhasLojas': currentStores,
      },
    );
    
    // Atualizar localmente
    // _utilizador = _utilizador!.copiar(minhasLojas: currentStores);
    setUser(_utilizador!.copiar(minhasLojas: currentStores));
    notifyListeners();
  }
}

  void setUser(Utilizador user) {
    _utilizador = user;
    notifyListeners();
  }

  void updateUser(Utilizador updatedUser) {
    _utilizador = updatedUser;
    notifyListeners();
  }


  void limparUtilizador() {
    _utilizador = null;
    notifyListeners();
  }
}
