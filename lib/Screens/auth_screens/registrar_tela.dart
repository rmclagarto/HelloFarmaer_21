import 'package:flutter/material.dart';
import 'package:hellofarmer/Core/cores.dart';
import 'package:hellofarmer/Core/imagens.dart';
import 'package:hellofarmer/Model/utilizador.dart';
import 'package:hellofarmer/Providers/utilizador_provider.dart';
import 'package:hellofarmer/Services/basedados.dart';
import 'package:hellofarmer/Services/autenticacao_firebase.dart';
import 'package:hellofarmer/Widgets/autenticacao_widgets/formularios/resgistar_formulario.dart';
import 'package:provider/provider.dart';

class RegistrarTela extends StatefulWidget {
  const RegistrarTela({super.key});

  @override
  State<RegistrarTela> createState() => _RegistrarTelaState();
}

class _RegistrarTelaState extends State<RegistrarTela> {
  final AutenticacaoFirebaseServico _autenticacao = AutenticacaoFirebaseServico();

  void _registrar(
    String nome,
    String email,
    String senha,
    String telefone,
    String confirmarSenha,
  ) async {
    if (senha != confirmarSenha) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('As senhas não coincidem')),
      );
      return;
    }

    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator(color: Colors.blueAccent,)),
      );

      final firebaseUser = await _autenticacao.registarComEmailEPassword(
        email,
        senha,
      );

      if (!mounted) return;

      if (firebaseUser != null) {
        final novoUser = Utilizador(
          idUtilizador: firebaseUser.idUtilizador,
          nomeUtilizador: nome,
          email: firebaseUser.email,
          telefone: telefone,
          historicoCompras: [],
          imagemPerfil: '',
        );

        // Salvar no banco de dados
        final banco = BancoDadosServico();
        await banco.create(
          caminho: 'users/${novoUser.idUtilizador}',
          dados: novoUser.toJson(),
        );

        
        Provider.of<UtilizadorProvider>(context, listen: false).setUser(novoUser);

        Navigator.pushReplacementNamed(context, '/home', arguments: novoUser);
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

  Widget _cabecalhoComLogo() {
    return Center(
      child: Image.asset(
        Imagens.logotipo,
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
              child: Center(child: RegistrarFormulario(onRegister: _registrar)),
            ),
          ],
        ),
      ),
    );
  }
}
