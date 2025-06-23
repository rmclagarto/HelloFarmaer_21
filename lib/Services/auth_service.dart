import 'package:projeto_cm/Model/users.dart';

class AuthService {
  User? _currentUser;

  User? get currentUser => _currentUser;

  bool get isLoggedIn => _currentUser != null;

  Future<User> login(String email, String password) async {
    try {
      _currentUser = User(name: "Test User", email: email);

      return _currentUser!;
    } catch (e) {
      throw Exception('Login failed: ${e.toString()}');
    }
  }

  Future<void> logout() async {
    _currentUser = null;
  }

  Future<User> register(String name, String email, String password) async {
    try {
      // Validate inputs
      if (name.isEmpty || email.isEmpty || password.isEmpty) {
        throw Exception('All fields are required');
      }

      // Here you would typically call your registration API

      // For now we'll simulate successful registration
      _currentUser = User(name: name, email: email);

      return _currentUser!;
    } catch (e) {
      throw Exception('Registration failed: ${e.toString()}');
    }
  }

  Future<User> recoverPassword(String email) async {
    return _currentUser!;
  }
}
