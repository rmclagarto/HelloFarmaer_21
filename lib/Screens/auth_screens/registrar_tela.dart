import 'package:flutter/material.dart';
import 'package:hellofarmer/Core/constants.dart';
import 'package:hellofarmer/Core/image_assets.dart';
import 'package:hellofarmer/Model/user.dart';
import 'package:hellofarmer/Providers/user_provider.dart';
import 'package:hellofarmer/Services/database_service.dart';
import 'package:hellofarmer/Services/firebase_auth_service.dart';
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
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      final firebaseUser = await _autenticacao.registerWithEmailPassword(
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
        await banco.criar(
          caminho: 'users/${novoUser.idUtilizador}',
          dados: novoUser.toJson(),
        );

        
        Provider.of<UserProvider>(context, listen: false).setUser(novoUser);

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
      backgroundColor: PaletaCores.corPrimaria,
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
