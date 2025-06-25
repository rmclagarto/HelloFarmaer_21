import 'package:flutter/material.dart';
import 'package:projeto_cm/Core/constants.dart';
import 'package:projeto_cm/Core/image_assets.dart';


import 'package:projeto_cm/Widgets/auth_widgets/forms/recover_password_form.dart';

class RecoverPasswordScreen extends StatefulWidget {
  const RecoverPasswordScreen({super.key});

  @override
  State<RecoverPasswordScreen> createState() => _RecoverPasswordScreenState();
}

class _RecoverPasswordScreenState extends State<RecoverPasswordScreen> {
  // final AuthService _authService = AuthService();
  

  @override
  void initState() {
    super.initState();

  }

  Future<void> handlePasswordRecovery(String email) async {
    try {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Verifica o teu e-mail para redefinir a senha.')),
      );

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao tentar recuperar senha.')),
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
      body: Padding(
        padding: const EdgeInsets.only(top: 100),
        child: Column(
          children: <Widget>[
            _buildLogoHeaderImage(),
            Expanded(
              child: Center(
                child: RecoverPasswordForm(
                  onSendRecoveryEmail: handlePasswordRecovery,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
