import 'package:firebase_auth/firebase_auth.dart' as fb_auth;

class Utilizador {
  final String idUtilizador;
  final String nomeUtilizador;
  final String email;
  String? telefone;

  List<String>? historicoCompras;
  List<String>? minhasLojas;
  List<String>? meusProdutosFavoritos;
  String? imagemPerfil;

  Utilizador({
    required this.idUtilizador,
    required this.nomeUtilizador,
    required this.email,
    this.telefone,

    this.historicoCompras = const [],
    this.minhasLojas = const [],
    this.meusProdutosFavoritos = const [],
    this.imagemPerfil,
  });

  Map<String, dynamic> toJson() {
    return {
      'idUtilizador': idUtilizador,
      'nomeUtilizador': nomeUtilizador,
      'email': email,
      'telefone': telefone,
      'historicoCompras': historicoCompras,
      'minhasLojas': minhasLojas,
      'meusProdutosFavoritos': meusProdutosFavoritos,
      'imagemPerfil': imagemPerfil,
    };
  }

  factory Utilizador.fromJson(Map<String, dynamic> json) {
    return Utilizador(
      idUtilizador: json['idUtilizador'] ?? '',
      nomeUtilizador: json['nomeUtilizador'] ?? '',
      email: json['email'] ?? '',
      telefone: json['telefone'],
      historicoCompras:
          json['historicoCompras'] is List
              ? List<String>.from(json['historicoCompras'])
              : [],
      minhasLojas:
          json['minhasLojas'] is List
              ? List<String>.from(json['minhasLojas'])
              : [],
      meusProdutosFavoritos:
          json['meusProdutosFavoritos'] is List
              ? List<String>.from(json['meusProdutosFavoritos'])
              : [],
      imagemPerfil: json['imagemPerfil'],
    );
  }

  factory Utilizador.fromFirebaseUser(fb_auth.User user) {
    return Utilizador(
      idUtilizador: user.uid,
      nomeUtilizador: user.displayName ?? '',
      email: user.email ?? '',
      telefone: '',
      historicoCompras: [],
      minhasLojas: [],
      meusProdutosFavoritos: [],
      imagemPerfil: '',
    );
  }

  Utilizador copiar({
    String? idUtilizador,
    String? nomeUtilizador,
    String? email,
    String? telefone,

    List<String>? historicoCompras,
    List<String>? minhasLojas,
    List<String>? meusProdutosFavoritos,
    String? imagemPerfil,
  }) {
    return Utilizador(
      idUtilizador: idUtilizador ?? this.idUtilizador,
      nomeUtilizador: nomeUtilizador ?? this.nomeUtilizador,
      email: email ?? this.email,
      telefone: telefone ?? this.telefone,
      historicoCompras: historicoCompras ?? this.historicoCompras,
      minhasLojas: minhasLojas ?? this.minhasLojas,
      meusProdutosFavoritos:
          meusProdutosFavoritos ?? this.meusProdutosFavoritos,
      imagemPerfil: imagemPerfil ?? this.imagemPerfil,
    );
  }
}
