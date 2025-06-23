import 'package:flutter/material.dart';
import 'package:projeto_cm/Core/constants.dart';
import 'package:projeto_cm/Core/routes.dart';

class RecoverPasswordForm extends StatefulWidget {
  final Function()? onSuccess;

  const RecoverPasswordForm({super.key, this.onSuccess});

  @override
  State<RecoverPasswordForm> createState() => _RecoverPasswordFormState();
}

class _RecoverPasswordFormState extends State<RecoverPasswordForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleSendRecoveryLink() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // Simular chamada à API
      await Future.delayed(const Duration(seconds: 2));

      // Se sucesso:
      if (widget.onSuccess != null) {
        widget.onSuccess!();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao enviar link: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _handleBackToLogin() {
    Navigator.pop(context);
    Navigator.restorablePushNamed(context, Routes.login);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Center(
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Constants.borderRadiusCard),
          ),
          child: Padding(
            padding: const EdgeInsets.all(28.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildForgetPasswordTitleText(),
                  const SizedBox(height: 40),
                  _buildEmailInputField(),
                  const SizedBox(height: 30),
                  _buildSendRecoveryLinkButton(),
                  const SizedBox(height: 20),
                  _buildBackToLoginLink(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildForgetPasswordTitleText() {
    return const Text(
      'Recuperar Senha',
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Constants.textColor,
      ),
    );
  }

  Widget _buildEmailInputField() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.done,
      cursorColor: Colors.grey,
      decoration: InputDecoration(
        labelText: 'Email',
        labelStyle: const TextStyle(color: Colors.grey),
        hintText: 'Digite seu email',
        prefixIcon: const Icon(Icons.email, color: Colors.grey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Constants.borderRadiusLarge),
        ),
        filled: true,
        fillColor: Colors.white,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Constants.borderRadiusLarge),
          borderSide: const BorderSide(color: Colors.grey),
        )
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor, digite seu email';
        }
        if (!value.contains('@') || !value.contains('.')) {
          return 'Por favor, digite um email válido';
        }
        return null;
      },
    );
  }

  Widget _buildSendRecoveryLinkButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _handleSendRecoveryLink,
        style: ElevatedButton.styleFrom(
          backgroundColor: Constants.secondaryColor, // Cor azul
          foregroundColor: Colors.white, // Cor do texto
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Constants.borderRadiusLarge),
          ),
          elevation: 5, // Sombra do botão
        ),
        child: const Text(
          'ENVIAR LINK DE RECUPERAÇÃO',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildBackToLoginLink() {
    return TextButton(
      onPressed: _handleBackToLogin,
      child: const Text(
        'Voltar ao Login',
        style: TextStyle(
          color: Constants.secondaryColor,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
