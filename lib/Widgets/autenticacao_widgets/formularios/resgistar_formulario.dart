
import 'package:flutter/material.dart';
import 'package:hellofarmer/Core/cores.dart';
import 'package:hellofarmer/Core/rotas.dart';


class RegistrarFormulario extends StatefulWidget {
  final Function(
    String nome,
    String email, 
    String senha,
    String confirmarSenha, 
    String telefone) onRegister;

  const RegistrarFormulario({
    super.key, 
    required this.onRegister
  });

  @override
  State<RegistrarFormulario> createState() => _RegistrarFormularioState();
}

class _RegistrarFormularioState extends State<RegistrarFormulario> {
  final _chaveFormulario = GlobalKey<FormState>();
  final TextEditingController _controladorNome = TextEditingController();
  final TextEditingController _controladorEmail = TextEditingController();
  final TextEditingController _controladorTelefone = TextEditingController();
  final TextEditingController _controladorSenha = TextEditingController();
  final TextEditingController _controladorConfirmarSenha =TextEditingController();
  bool _senhaOculta = true;

  @override
  void dispose() {
    _controladorNome.dispose();
    _controladorEmail.dispose();
    _controladorTelefone.dispose();
    _controladorSenha.dispose();
    _controladorConfirmarSenha.dispose();
    super.dispose();
  }

  void _enviarFormulario() {
    if (_chaveFormulario.currentState!.validate()) {
      widget.onRegister(
        _controladorNome.text.trim(),
        _controladorEmail.text.trim(),
        _controladorSenha.text.trim(),
        _controladorTelefone.text.trim(),
        _controladorConfirmarSenha.text.trim(),
      );

      Navigator.pushReplacementNamed(context, Rotas.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(28.0),
        child: Form(
          key: _chaveFormulario,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                const Text(
                  "Registrar",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 40),
                _campoNome(),
                const SizedBox(height: 10),
                _campoEmail(),
                const SizedBox(height: 10),
                _campoTelefone(),
                const SizedBox(height: 10),
                _campoSenha(),
                const SizedBox(height: 10),
                _campoConfirmarSenha(),
                const SizedBox(height: 40),
                _botaoRegistrar(),
                const SizedBox(height: 20),
                _botaoIrParaLogin(context),
              ],
            ),
          ),
        ),
      ),
    );
  }


  Widget _campoNome() {
    return TextFormField(
      controller: _controladorNome,
      keyboardType: TextInputType.name,
      textInputAction: TextInputAction.next,
      cursorColor: Colors.grey,
      decoration: InputDecoration(
        labelText: 'Nome',
        labelStyle: const TextStyle(color: Colors.grey),
        prefixIcon: const Icon(Icons.person),
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
      validator: (valor) => valor == null || valor.isEmpty ? 'Por favor, insira seu nome' : null,
    );
  }

  Widget _campoEmail() {
    return TextFormField(
      controller: _controladorEmail,
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
      validator: (valor) {
        if (valor == null || valor.isEmpty) return 'Por favor, insira seu email';
        if (!valor.contains('@') || !valor.contains('.')) return 'Por favor, insira um email válido';
        return null;
      },
    );
  }

  Widget _campoTelefone(){
    return TextFormField(
      controller: _controladorTelefone,
      keyboardType: TextInputType.phone,
      textInputAction: TextInputAction.next,
      cursorColor: Colors.grey,
      decoration: InputDecoration(
        labelText: 'Telefone',
        labelStyle: const TextStyle(color: Colors.grey),
        prefixIcon: const Icon(Icons.phone),
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
      validator: (valor) {
        if (valor == null || valor.length < 9) return 'Por favor, insira um número válido';
        return null;
      },
      onFieldSubmitted: (_) => _enviarFormulario(),
    );
  }

  Widget _campoSenha() {
    return TextFormField(
      controller: _controladorSenha,
      obscureText: _senhaOculta,
      textInputAction: TextInputAction.done,
      cursorColor: Colors.grey,
      decoration: InputDecoration(
        labelText: 'Senha',
        labelStyle: const TextStyle(color: Colors.grey),
        prefixIcon: const Icon(Icons.lock),
        suffixIcon: IconButton(
          icon: Icon(
            _senhaOculta ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: () {
            setState(() {
              _senhaOculta = !_senhaOculta;
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
      validator: (valor) => valor == null || valor.isEmpty ? 'Por favor, insira sua senha' : null,
      onFieldSubmitted: (_) => _enviarFormulario(),
    );
  }

  Widget _campoConfirmarSenha() {
    return TextFormField(
      controller: _controladorConfirmarSenha,
      obscureText: _senhaOculta,
      textInputAction: TextInputAction.done,
      cursorColor: Colors.grey,
      decoration: InputDecoration(
        labelText: 'Senha',
        labelStyle: const TextStyle(color: Colors.grey),
        prefixIcon: const Icon(Icons.lock),
        suffixIcon: IconButton(
          icon: Icon(
            _senhaOculta ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: () {
            setState(() {
              _senhaOculta = !_senhaOculta;
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
      validator: (valor) => valor == null || valor.isEmpty ? 'Por favor, confirme sua senha' : null,
      onFieldSubmitted: (_) => _enviarFormulario(),
    );
  }

  Widget _botaoRegistrar() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _enviarFormulario,
        style: ElevatedButton.styleFrom(
          backgroundColor: PaletaCores.corSecundaria(context),
          padding: const EdgeInsets.symmetric(
            vertical: 15,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40),
          ),
        ),
        child: const Text(
          "Acessar",
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
    );
  }

  Widget _botaoIrParaLogin(BuildContext context) {
    return TextButton(
      onPressed: () => Navigator.pushReplacementNamed(context, Rotas.login),
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
