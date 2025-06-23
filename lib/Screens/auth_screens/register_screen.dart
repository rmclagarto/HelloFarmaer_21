import 'package:flutter/material.dart';
import 'package:projeto_cm/Core/constants.dart';
import 'package:projeto_cm/Core/image_assets.dart';
import 'package:projeto_cm/Widgets/auth_widgets/forms/register_from.dart';
import 'package:projeto_cm/Services/auth_service.dart';


class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}


class _RegisterScreenState extends State<RegisterScreen> {
  final AuthService _authService = AuthService();

  void _handleRegister(String email, String password, String confirmPassword) async {
    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('As passwords não coincidem')),
      );
      return;
    }

    final user = await _authService.registerWithEmailPassword(email, password);

    if (user != null) {
      Navigator.pushReplacementNamed(context, '/home', arguments: user);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Falha ao criar a conta')),
      );
    }

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
      body: Padding(padding: const EdgeInsets.only(top: 100),
      child: Column(
        children: <Widget> [
          _buildLogoHeaderImage(),
            Expanded(
              child: Center(
                child: RegisterFrom(
                  onRegister: _handleRegister,
                ),
              ),
            ),
        ],
      ),),
    );
  }
}
