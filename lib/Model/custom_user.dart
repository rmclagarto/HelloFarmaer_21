import 'package:firebase_auth/firebase_auth.dart' as fb_auth;

class CustomUser {
  final String idUser;
  final String nomeUser;
  final String email;
  String? telefone;
  final String? grupo; // "VIP, Regular, Novo"
  List<String>? historicoCompras; // armazena os nome, data, preco, codigo
  final String? imagemPerfil;

  CustomUser({
    required this.idUser,
    required this.nomeUser,
    required this.email,
    this.telefone,
    this.grupo = "Novo",
    this.historicoCompras = const [],
    this.imagemPerfil,
  });
  

 Map<String, dynamic> toJson() {
  return {
    'idUser': idUser,
    'nomeUser': nomeUser,
    'email': email,
    'telefone': telefone,
    'grupo': grupo,
    'historicoCompras': historicoCompras,
    'imagemPerfil': imagemPerfil,
  };
}

  factory CustomUser.fromFirebaseUser(fb_auth.User user) {
    return CustomUser(
      idUser: user.uid,
      nomeUser: user.displayName ?? '',
      email: user.email ?? '',
    );
  }
  
  @override
  String toString() {
    return 'CustomUser(idUser: $idUser, nomeUser: $nomeUser, email: $email, telefone: $telefone, grupo: $grupo, historicoCompras: $historicoCompras, imagemPerfil: $imagemPerfil)';
  }
}