
import 'package:flutter/material.dart';
import 'package:hellofarmer/Core/constants.dart';
import 'package:hellofarmer/Core/routes.dart' show Routes;



class RecoverPasswordForm extends StatefulWidget {
  final void Function(String email)? onSendRecoveryEmail;

  const RecoverPasswordForm({super.key, this.onSendRecoveryEmail});

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
      if (widget.onSendRecoveryEmail != null) {
        widget.onSendRecoveryEmail!(_emailController.text.trim());

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
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(28.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Recuperar Senha',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
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

  Widget _buildEmailInputField() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.done,
      cursorColor: Colors.grey,
      decoration: InputDecoration(
        labelText: 'Email',
        hintText: 'Digite seu email',
        prefixIcon: const Icon(Icons.email, color: Colors.grey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(40),
        ),
        filled: true,
        fillColor: Colors.white,
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
          backgroundColor: Constants.secondaryColor,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40),
          ),
          elevation: 5,
        ),
        child: const Text(
          'ENVIAR LINK DE RECUPERAÇÃO',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
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
