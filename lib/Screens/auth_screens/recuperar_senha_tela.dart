
import 'package:flutter/material.dart';
import 'package:hellofarmer/Core/cores.dart';
import 'package:hellofarmer/Core/imagens.dart';
import 'package:hellofarmer/Widgets/autenticacao_widgets/formularios/recuperar_senha_formulario.dart';


class RecuperarSenhaTela extends StatefulWidget {
  const RecuperarSenhaTela({super.key});

  @override
  State<RecuperarSenhaTela> createState() => _RecuperarSenhaTelaState();
}

class _RecuperarSenhaTelaState extends State<RecuperarSenhaTela> {

  @override
  void initState() {
    super.initState();
  }

  Future<void> _enviarLinkRecuperacao(String email) async {
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

  Widget _cabecalhoComLogo() {
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
      backgroundColor: PaletaCores.corPrimaria(context),
      body: Padding(
        padding: const EdgeInsets.only(top: 100),
        child: Column(
          children: <Widget>[
            _cabecalhoComLogo(),
            Expanded(
              child: Center(
                child: RecuperarSenhaFormulario(
                  enviarEmailRecuperacao: _enviarLinkRecuperacao,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
