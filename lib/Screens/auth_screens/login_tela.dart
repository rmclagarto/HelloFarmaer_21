
import 'package:flutter/material.dart';
import 'package:hellofarmer/Core/constants.dart';
import 'package:hellofarmer/Core/image_assets.dart';
import 'package:hellofarmer/Core/routes.dart';
import 'package:hellofarmer/Providers/user_provider.dart';
import 'package:hellofarmer/Services/firebase_auth_service.dart';
import 'package:hellofarmer/Widgets/autenticacao_widgets/formularios/login_formulario.dart';
import 'package:provider/provider.dart';


class LoginTela extends StatefulWidget {
  const LoginTela({super.key});

  @override
  State<LoginTela> createState() => _LoginTelaState();
}

class _LoginTelaState extends State<LoginTela> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final AutenticacaoFirebaseServico _firebaseAuthService = AutenticacaoFirebaseServico();
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _handleLogin(String email, String password) async {
    email = email.trim();
    password = password.trim();

    if (email.isEmpty || password.isEmpty) {
      setState(() => _errorMessage = 'Por favor preencha todos os campos.');
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
        await userProvider.loadUserAccount(user.idUtilizador);

        if (!mounted) return;
        Navigator.pushReplacementNamed(context, Rotas.home);
      }else{
        setState(() {
          _errorMessage = 'Credenciais inválidas. Tente novamente.';
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
        image: AssetImage(Imagens.logotipo),
        height: 120,
        fit: BoxFit.contain,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PaletaCores.corPrimaria,
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
