// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/widgets.dart';
// import 'package:projeto_cm/Model/custom_user.dart';
// import 'package:projeto_cm/Services/firebase_auth_service.dart';

// class AuthProvider with ChangeNotifier {
//   final FirebaseAuthService _authService;
//   CustomUser? _currentUser;
//   bool _isLoading = false;
//   String? _errorMessage;

//   AuthProvider(this._authService) {
//     _loadCurrentUser();
//   }

//   CustomUser? get currentUser => _currentUser;
//   bool get isLoading => _isLoading;
//   String? get errorMessage => _errorMessage;

//   Future<void> _loadCurrentUser() async {
//     final user = _authService.currentUser;
//     if (user != null) {
//       _currentUser = CustomUser.fromFirebaseUser(user);
//     }
//     notifyListeners();
//   }

//   Future<bool> register(String email, String password, String name) async {
//     try {
//       _setLoading(true);
//       _clearError();

//       final fbUser = await _authService.registerWithEmailPassword(
//         email,
//         password,
//       );

//       if (fbUser != null) {
//         await fbUser.updateDisplayName(name);

//         _currentUser = CustomUser(
//           id: fbUser.uid,
//           name: name,
//           email: fbUser.email ?? email,
//         );

//         notifyListeners();
//         return true;
//       }
//       return false;
//     } catch (e) {
//       _setError(e.toString());

//       return false;
//     } finally {
//       _setLoading(false);
//     }
//   }


//   Future<bool> login(String email, String password) async {
//     try{
//       _setLoading(true);
//       _clearError();

//       final fbUser = await _authService.signInWithEmailPassword(email, password);

//       if(fbUser != null){
//         _currentUser = CustomUser.fromFirebaseUser(fbUser);
//         notifyListeners();
//         return true;
//       }
//       return false;
//     }catch (e){
//       _setError(_parseAuthError(e));
//       return false;
//     }finally {
//       _setLoading(false);
//     }
//   }

//   Future<void> logout() async {
//     try{
//       _setLoading(true);
//       await _authService.signOut();
//       _currentUser = null;
//       notifyListeners();
//     }catch(e){
//       _setError(e.toString());
//     }finally{
//       _setLoading(false);
//     }
//   }


//   Future<bool> resetPassword(String email) async {
//     try {
//       _setLoading(true);
//       await _authService.sendPasswordResetEmail(email);
//       return true;
//     } catch (e) {
//       _setError(_parseAuthError(e));
//       return false;
//     } finally {
//       _setLoading(false);
//     }
//   }


//   void _setLoading(bool loading) {
//     _isLoading = loading;
//     notifyListeners();
//   }

//   void _setError(String message) {
//     _errorMessage = message;
//     notifyListeners();
//   }

//   void _clearError() {
//     _errorMessage = null;
//     notifyListeners();
//   }

//   String _parseAuthError(dynamic error) {
//     if (error is FirebaseAuthException) {
//       switch (error.code) {
//         case 'user-not-found':
//           return 'Utilizador não encontrado';
//         case 'wrong-password':
//           return 'Senha incorreta';
//         case 'email-already-in-use':
//           return 'Email já registrados';
//         default:
//           return 'Erro no acesso: ${error.message}';
//       }
//     }
//     return error.toString();
//   }
// }
