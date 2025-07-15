// import 'package:firebase_auth/firebase_auth.dart' as fb_auth;

// class CustomUser {
//   final String idUser;
//   final String nomeUser;
//   final String email;
//   String? telefone;
//   final String? grupo; // "VIP, Regular, Novo"
//   List<String>? historicoCompras; // armazena os nome, data, preco, codigo
//   List<String>? myStoresList;
//   String? imagemPerfil;

//   CustomUser({
//     required this.idUser,
//     required this.nomeUser,
//     required this.email,
//     this.telefone,
//     this.grupo = "Novo",
//     this.historicoCompras = const [],
//     this.myStoresList = const [],
//     this.imagemPerfil,
//   });

//   Map<String, dynamic> toJson() {
//     return {
//       'idUser': idUser,
//       'nomeUser': nomeUser,
//       'email': email,
//       'telefone': telefone,
//       'grupo': grupo,
//       'historicoCompras': historicoCompras,
//       'myStoresList': myStoresList, // ← faltava aqui
//       'imagemPerfil': imagemPerfil,
//     };
//   }

//   factory CustomUser.fromFirebaseUser(fb_auth.User user) {
//     return CustomUser(
//       idUser: user.uid,
//       nomeUser: user.displayName ?? '',
//       email: user.email ?? '',
//     );
//   }

//   CustomUser copyWith({
//     String? idUser,
//     String? nomeUser,
//     String? email,
//     String? telefone,
//     String? grupo,
//     List<String>? historicoCompras,
//     List<String>? myStoresList, // ← adicionar
//     String? imagemPerfil,
//   }) {
//     return CustomUser(
//       idUser: idUser ?? this.idUser,
//       nomeUser: nomeUser ?? this.nomeUser,
//       email: email ?? this.email,
//       telefone: telefone ?? this.telefone,
//       grupo: grupo ?? this.grupo,
//       historicoCompras: historicoCompras ?? this.historicoCompras,
//       myStoresList: myStoresList ?? this.myStoresList, // ← incluir aqui
//       imagemPerfil: imagemPerfil ?? this.imagemPerfil,
//     );
//   }


//   // In your CustomUser model
// List<String> get myStoresList {
//   if (_myStoresList is Map) {
//     return Map.from(_myStoresList).keys.toList();
//   } else if (_myStoresList is List) {
//     return List<String>.from(_myStoresList);
//   }
//   return [];
// }
// }





import 'package:firebase_auth/firebase_auth.dart' as fb_auth;

class CustomUser {
  final String idUser;
  final String nomeUser;
  final String email;
  String? telefone;
  final String? grupo;
  List<String>? historicoCompras;
  List<String>? myStoreList; // Nome consistente (sem o 's' em Stores)
  String? imagemPerfil;

  CustomUser({
    required this.idUser,
    required this.nomeUser,
    required this.email,
    this.telefone,
    this.grupo = "Novo",
    this.historicoCompras = const [],
    this.myStoreList = const [], // Nome consistente
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
      'myStoreList': myStoreList, // Nome consistente
      'imagemPerfil': imagemPerfil,
    };
  }

  factory CustomUser.fromJson(Map<String, dynamic> json) {
    return CustomUser(
      idUser: json['idUser'],
      nomeUser: json['nomeUser'],
      email: json['email'],
      telefone: json['telefone'],
      grupo: json['grupo'],
      historicoCompras: json['historicoCompras'] != null 
          ? List<String>.from(json['historicoCompras'])
          : [],
      myStoreList: json['myStoreList'] != null
          ? List<String>.from(json['myStoreList'])
          : [],
      imagemPerfil: json['imagemPerfil'],
    );
  }

  factory CustomUser.fromFirebaseUser(fb_auth.User user) {
    return CustomUser(
      idUser: user.uid,
      nomeUser: user.displayName ?? '',
      email: user.email ?? '',
    );
  }

  CustomUser copyWith({
    String? idUser,
    String? nomeUser,
    String? email,
    String? telefone,
    String? grupo,
    List<String>? historicoCompras,
    List<String>? myStoreList, // Nome consistente
    String? imagemPerfil,
  }) {
    return CustomUser(
      idUser: idUser ?? this.idUser,
      nomeUser: nomeUser ?? this.nomeUser,
      email: email ?? this.email,
      telefone: telefone ?? this.telefone,
      grupo: grupo ?? this.grupo,
      historicoCompras: historicoCompras ?? this.historicoCompras,
      myStoreList: myStoreList ?? this.myStoreList, // Nome consistente
      imagemPerfil: imagemPerfil ?? this.imagemPerfil,
    );
  }

}