
import 'package:flutter/material.dart';
import 'package:hellofarmer/Core/cores.dart';

import 'package:hellofarmer/Core/rotas.dart';



class LoginForm extends StatefulWidget {
  final Function(String email, String password) aoEntrar;
  final bool estaCarregando;
  final String? mensagemErro;

  const LoginForm({
    super.key,
    required this.aoEntrar,
    this.estaCarregando = false,
    this.mensagemErro,
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
      widget.aoEntrar(
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
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(28.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                _titulo(),
                const SizedBox(height: 20),
                _campoEmail(),
                const SizedBox(height: 20),
                _campoSenha(),
                if (widget.mensagemErro != null) ...[
                  const SizedBox(height: 10),
                  _mensagemErro(),
                ],
                const SizedBox(height: 10),
                _esqueceuSenha(context),
                const SizedBox(height: 20),
                _botaoEntrar(),
                const SizedBox(height: 160),
                _botaoRegistrar(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _titulo() {
    return const Text(
      "Entrar",
      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    );
  }

  Widget _campoEmail() {
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
          borderRadius: BorderRadius.circular(40),
        ),
        filled: true,
        fillColor: Colors.white,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(40),
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

  Widget _campoSenha() {
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
          borderRadius: BorderRadius.circular(40),
        ),
        filled: true,
        fillColor: Colors.white,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(40),
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

  Widget _mensagemErro() {
    return Text(
      widget.mensagemErro!,
      style: const TextStyle(color: Colors.red, fontSize: 14),
    );
  }

  Widget _esqueceuSenha(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed:
            () =>
                Navigator.pushReplacementNamed(context, Rotas.recuperarSenha),
        child: const Text(
          "Recuperar Palavra-Passe",
          style: TextStyle(color: Colors.black, fontSize: 14),
        ),
      ),
    );
  }

  Widget _botaoEntrar() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: widget.estaCarregando ? null : _submitForm,
        style: ElevatedButton.styleFrom(
          backgroundColor: PaletaCores.corSecundaria(context),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(
            vertical: 15,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40),
          ),
          elevation: 5,
        ),
        child:
            widget.estaCarregando
                ? const CircularProgressIndicator(color: Colors.blueAccent)
                : const Text(
                  "Acessar",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
      ),
    );
  }

  Widget _botaoRegistrar(BuildContext context) {
    return TextButton(
      onPressed: () => Navigator.pushReplacementNamed(context, Rotas.registrar),
      child: RichText(
        text: const TextSpan(
          style: TextStyle(color: Colors.black, fontSize: 16),
          children: [
            TextSpan(text: "Não é membro?"),
            TextSpan(
              text: "Adere já",
              style: TextStyle(color: Colors.blue),
            ),
          ],
        ),
      ),
    );
  }
}
