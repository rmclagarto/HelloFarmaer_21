
import 'package:flutter/material.dart';
import 'package:hellofarmer/Core/constants.dart';
import 'package:hellofarmer/Core/routes.dart' show Rotas;



class RecuperarSenhaFormulario extends StatefulWidget {
  final void Function(String email)? enviarEmailRecuperacao;

  const RecuperarSenhaFormulario({
    super.key, 
    this.enviarEmailRecuperacao
  });

  @override
  State<RecuperarSenhaFormulario> createState() => _RecuperarSenhaFormularioState();
}

class _RecuperarSenhaFormularioState extends State<RecuperarSenhaFormulario> {
  final _chaveFormulario = GlobalKey<FormState>();
  final TextEditingController _controladorEmail = TextEditingController();
  bool _carregando = false;

  @override
  void dispose() {
    _controladorEmail.dispose();
    super.dispose();
  }

  Future<void> _enviarLinkRecuperacao() async {
    if (!_chaveFormulario.currentState!.validate()) return;

    setState(() => _carregando = true);

    try {
      if (widget.enviarEmailRecuperacao != null) {
        widget.enviarEmailRecuperacao!(_controladorEmail.text.trim());

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
        setState(() => _carregando = false);
      }
    }
  }

  void _voltarParaLogin() {
    Navigator.pop(context);
    Navigator.restorablePushNamed(context, Rotas.login);
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
              key: _chaveFormulario,
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
                  _campoEmail(),
                  const SizedBox(height: 30),
                  _botaoEnviarLink(),
                  const SizedBox(height: 20),
                  _linkVoltarLogin(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _campoEmail() {
    return TextFormField(
      controller: _controladorEmail,
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

  Widget _botaoEnviarLink() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _carregando ? null : _enviarLinkRecuperacao,
        style: ElevatedButton.styleFrom(
          backgroundColor: PaletaCores.corSecundaria,
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

  Widget _linkVoltarLogin() {
    return TextButton(
      onPressed: _voltarParaLogin,
      child: const Text(
        'Voltar ao Login',
        style: TextStyle(
          color: PaletaCores.corSecundaria,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
