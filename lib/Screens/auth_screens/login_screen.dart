
import 'package:flutter/material.dart';
import 'package:hellofarmer/Core/constants.dart';
import 'package:hellofarmer/Core/image_assets.dart';
import 'package:hellofarmer/Core/routes.dart';
import 'package:hellofarmer/Providers/user_provider.dart';
import 'package:hellofarmer/Services/firebase_auth_service.dart';
import 'package:hellofarmer/Widgets/auth_widgets/forms/login_form.dart';
import 'package:provider/provider.dart';


class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FirebaseAuthService _firebaseAuthService = FirebaseAuthService();
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _handleLogin(String email, String password) async {
    email = email.trim();
    password = password.trim();

    if (email.isEmpty || password.isEmpty) {
      setState(() => _errorMessage = l10n.loginErrorEmptyFields);
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final user = await _firebaseAuthService.signInWithEmailPassword(email, password);
      if (!mounted) return;

      if(user != null){

        final userProvider = Provider.of<UserProvider>(context, listen: false);
        await userProvider.loadUserAccount(user.idUser);

        if (!mounted) return;
        Navigator.pushReplacementNamed(context, Routes.home);
      }else{
        setState(() {
          _errorMessage = l10n.loginErrorInvalidCredentials;
          _isLoading = false;
        });
      }
      
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceFirst('Exception: ', '');
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Widget _buildLogoHeaderImage() {
    return Center(
      child: Image(
        image: AssetImage(ImageAssets.logotipo),
        height: 120,
        fit: BoxFit.contain,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.primaryColor,
      body: Padding(
        padding: const EdgeInsets.only(top: 100),
        child: Column(
          children: <Widget>[
            _buildLogoHeaderImage(),
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            if (_isLoading)
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: CircularProgressIndicator(),
              ),
            Expanded(child: Center(child: LoginForm(onLogin: _handleLogin))),
          ],
        ),
      ),
    );
  }
}
