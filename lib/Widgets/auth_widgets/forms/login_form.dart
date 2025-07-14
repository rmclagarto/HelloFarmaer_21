
import 'package:flutter/material.dart';
import 'package:hellofarmer/Core/constants.dart';
import 'package:hellofarmer/Core/image_assets.dart';
import 'package:hellofarmer/Core/routes.dart';
import 'package:hellofarmer/Model/custom_user.dart';


class LoginForm extends StatefulWidget {
  final Function(String email, String password) onLogin;
  final bool isLoading;
  final String? errorMessage;

  const LoginForm({
    super.key,
    required this.onLogin,
    this.isLoading = false,
    this.errorMessage,
  });

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      widget.onLogin(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Constants.borderRadiusCard),
      ),
      child: Padding(
        padding: const EdgeInsets.all(28.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                _buildTitle(),
                const SizedBox(height: Constants.spacingMedium),
                _buildEmailField(),
                const SizedBox(height: Constants.spacingMedium),
                _buildPasswordField(),
                if (widget.errorMessage != null) ...[
                  const SizedBox(height: Constants.spacingSmall),
                  _buildErrorText(),
                ],
                const SizedBox(height: Constants.spacingSmall),
                _buildForgotPassword(context),
                const SizedBox(height: Constants.spacingMedium),
                _buildLoginButton(),
                const SizedBox(height: Constants.spacingLarge),
                _buildDivider(),
                const SizedBox(height: Constants.spacingLarge),
                _buildSocialButtons(),
                const SizedBox(height: Constants.spacingSmall - 4),
                _buildSignUp(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return const Text(
      Constants.loginTitle,
      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      cursorColor: Colors.grey,
      decoration: InputDecoration(
        labelText: 'Email',
        labelStyle: const TextStyle(color: Colors.grey),
        prefixIcon: const Icon(Icons.email),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Constants.borderRadiusLarge),
        ),
        filled: true,
        fillColor: Colors.white,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Constants.borderRadiusLarge),
          borderSide: const BorderSide(color: Colors.grey),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor, insira seu email';
        }
        if (!value.contains('@') || !value.contains('.')) {
          return 'Por favor, insira um email válido';
        }
        return null;
      },
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      textInputAction: TextInputAction.done,
      cursorColor: Colors.grey,
      decoration: InputDecoration(
        labelText: 'Senha',
        labelStyle: const TextStyle(color: Colors.grey),
        prefixIcon: const Icon(Icons.lock),
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          },
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Constants.borderRadiusLarge),
        ),
        filled: true,
        fillColor: Colors.white,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Constants.borderRadiusLarge),
          borderSide: const BorderSide(color: Colors.grey),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor, insira sua senha';
        }
        return null;
      },
      onFieldSubmitted: (_) => _submitForm(),
    );
  }

  Widget _buildErrorText() {
    return Text(
      widget.errorMessage!,
      style: const TextStyle(color: Colors.red, fontSize: 14),
    );
  }

  Widget _buildForgotPassword(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed:
            () =>
                Navigator.pushReplacementNamed(context, Routes.recoverPassword),
        child: const Text(
          Constants.forgotPassword,
          style: TextStyle(color: Constants.textColor, fontSize: 14),
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: widget.isLoading ? null : _submitForm,
        style: ElevatedButton.styleFrom(
          backgroundColor: Constants.secondaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(
            vertical: Constants.buttonVerticalPadding,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Constants.spacingLarge),
          ),
          elevation: 5,
        ),
        child:
            widget.isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text(
                  Constants.loginButton,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
      ),
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        const Expanded(child: Divider()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(Constants.orDivider),
        ),
        const Expanded(child: Divider()),
      ],
    );
  }

  Widget _buildSocialButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        _socialBtn('Google'),
        const SizedBox(width: 8),
        _socialBtn('Facebook'),
        const SizedBox(width: 8),
        _socialBtn('IOS'),
      ],
    );
  }

  Widget _socialBtn(String name) {
    String assetPath;
    switch (name) {
      case 'Google':
        assetPath = ImageAssets.googleLogo;
        break;
      case 'Facebook':
        assetPath = ImageAssets.facebookLogo;
        break;
      case 'IOS':
        assetPath = ImageAssets.iosLogo;
        break;
      default:
        assetPath = 'assets/default_logo.png';
    }

    return ElevatedButton(
      onPressed: () {
        if (name == "Google") {
          final fakeUser = CustomUser(
            idUser: 'anon',
            email: 'anon@google.com',
            nomeUser: 'Usuário Google',
            telefone: "12345678901"
            // preencha os campos necessários no seu CustomUser
          );

          Navigator.pushReplacementNamed(
            context,
            Routes.home,
            arguments: fakeUser,
          );
        }
      },

      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        minimumSize: const Size(48, 48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      child: Image(
        image: AssetImage(assetPath),
        height: 24,
        width: 24,
        fit: BoxFit.contain,
      ),
    );
  }

  Widget _buildSignUp(BuildContext context) {
    return TextButton(
      onPressed: () => Navigator.pushReplacementNamed(context, Routes.register),
      child: RichText(
        text: const TextSpan(
          style: TextStyle(color: Colors.black, fontSize: 16),
          children: [
            TextSpan(text: Constants.notAMember),
            TextSpan(
              text: Constants.signUpNow,
              style: TextStyle(color: Colors.blue),
            ),
          ],
        ),
      ),
    );
  }
}
