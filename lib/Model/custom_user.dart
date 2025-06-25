import 'package:firebase_auth/firebase_auth.dart' as fb_auth;

class CustomUser {
  final String id;
  final String name;
  final String email;
  final String grupo; // "VIP, regular, novo"
  final List<String> historicoCompras;

  CustomUser({
    required this.id,
    required this.name,
    required this.email,
    this.grupo = "regular",
    this.historicoCompras = const [],
    //UUID
    // telefone (op)
    // 
  });
  
  // Convert user to map for storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
    };
  }
  
  // Create user from map
  factory CustomUser.fromMap(Map<String, dynamic> map) {
    return CustomUser(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
    );
  }


  factory CustomUser.fromFirebaseUser(fb_auth.User user) {
    return CustomUser(
      id: user.uid,
      name: user.displayName ?? '',
      email: user.email ?? '',
    );
  }
  
  @override
  String toString() => 'User(id: $id, name: $name, email: $email, grupo: $grupo)';
}