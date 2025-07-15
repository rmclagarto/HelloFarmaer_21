import 'package:flutter/material.dart';
import 'package:hellofarmer/Core/constants.dart';
import 'package:hellofarmer/Core/image_assets.dart';
import 'package:hellofarmer/Model/custom_user.dart';
import 'package:hellofarmer/Providers/user_provider.dart';
import 'package:hellofarmer/Services/database_service.dart';
import 'package:hellofarmer/Services/firebase_auth_service.dart';
import 'package:hellofarmer/Widgets/auth_widgets/forms/register_from.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final FirebaseAuthService _authService = FirebaseAuthService();

  void _handleRegister(
    String nome,
    String email,
    String password,
    String telefone,
    String confirmPassword,
  ) async {
    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('As passwords não coincidem')),
      );
      return;
    }

    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      final firebaseUser = await _authService.registerWithEmailPassword(
        email,
        password,
      );

      if (!mounted) return;

      if (firebaseUser != null) {
        final user = CustomUser(
          idUser: firebaseUser.idUser,
          nomeUser: nome,
          email: firebaseUser.email,
          telefone: telefone,
          grupo: 'cliente',
          historicoCompras: [],
          imagemPerfil: '',
        );

        // 👉 SALVA NO REALTIME DATABASE
        final dbService = DatabaseService();
        await dbService.create(
          path: 'users/${user.idUser}',
          data: user.toJson(),
        );

        // 👉 PASSA O USER PARA O PROVIDER
        Provider.of<UserProvider>(context, listen: false).setUser(user);

        Navigator.pushReplacementNamed(context, '/home', arguments: user);
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Falha ao criar a conta')));
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro: ${e.toString()}')));
    }
  }

  Widget _buildLogoHeaderImage() {
    return Center(
      child: Image.asset(
        ImageAssets.logotipo,
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
            Expanded(
              child: Center(child: RegisterFrom(onRegister: _handleRegister)),
            ),
          ],
        ),
      ),
    );
  }
}
