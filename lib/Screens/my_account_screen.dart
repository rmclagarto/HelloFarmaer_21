import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hellofarmer/Core/cores.dart';
import 'package:hellofarmer/Core/imagens.dart';
import 'package:hellofarmer/Model/utilizador.dart';
import 'package:hellofarmer/Screens/auth_screens/login_tela.dart';
import 'package:hellofarmer/Screens/historico_encomendas_screen.dart';
import 'package:hellofarmer/Services/basedados.dart';
// import 'package:hellofarmer/l10n/app_localizations.dart';

class MeuPerfilTela extends StatelessWidget {
  final Utilizador utilizador;

  const MeuPerfilTela({super.key, required this.utilizador});

  Future<void> apagarConta(String idUtilizador) async {
    final bancoDados = BancoDadosServico();

    try {
      /// 1. Obter lista de lojas do usuário
      final snapshotLojas = await bancoDados.read(
        caminho: 'users/$idUtilizador/minhasLojas',
      );

      List<String> idLojas = [];
      if (snapshotLojas?.value != null) {
        final dados = snapshotLojas?.value;
        if (dados is List) {
          idLojas = dados.whereType<String>().toList();
        } else if (dados is Map) {
          idLojas = dados.values.whereType<String>().toList();
        }
      }

      /// 2. Para cada loja, apagar produtos e encomendas associados
      for (final lojaId in idLojas) {
        /// 2.1 Apagar produtos da loja
        final snapshotProdutos = await bancoDados.read(
          caminho: 'stores/$lojaId/listProductsId',
        );

        if (snapshotProdutos?.value != null) {
          final dadosProdutos = snapshotProdutos?.value;
          final idProdutos =
              dadosProdutos is List
                  ? dadosProdutos.whereType<String>().toList()
                  : (dadosProdutos is Map
                      ? dadosProdutos.values.whereType<String>().toList()
                      : <String>[]);

          for (final produtoId in idProdutos) {
            await bancoDados.delete(caminho: 'products/$produtoId');
          }
        }

        /// 2.2 Apagar encomendas da loja
        final snapshotEncomendasLoja = await bancoDados.read(
          caminho: 'stores/$lojaId/listEncomendasId',
        );

        if (snapshotEncomendasLoja?.value != null) {
          final dadosEncomendas = snapshotEncomendasLoja?.value;
          final idEncomendas =
              dadosEncomendas is List
                  ? dadosEncomendas.whereType<String>().toList()
                  : (dadosEncomendas is Map
                      ? dadosEncomendas.values.whereType<String>().toList()
                      : <String>[]);

          for (final encomendaId in idEncomendas) {
            await bancoDados.delete(caminho: 'orders/$encomendaId');
          }
        }

        /// 2.3 Apagar loja inteira
        await bancoDados.delete(caminho: 'stores/$lojaId');
      }

      /// 3. Apagar encomendas do usuário (listEncomendas + minhasEncomendas)
      final snapshotEncomendasUser1 = await bancoDados.read(
        caminho: 'users/$idUtilizador/listEncomendas',
      );
      final snapshotEncomendasUser2 = await bancoDados.read(
        caminho: 'users/$idUtilizador/minhasEncomendas',
      );

      List<String> encomendasUser = [];

      for (final snapshot in [
        snapshotEncomendasUser1,
        snapshotEncomendasUser2,
      ]) {
        if (snapshot?.value != null) {
          final dados = snapshot?.value;
          final ids =
              dados is List
                  ? dados.whereType<String>().toList()
                  : (dados is Map
                      ? dados.values.whereType<String>().toList()
                      : <String>[]);
          encomendasUser.addAll(ids);
        }
      }

      for (final encomendaId in encomendasUser.toSet()) {
        await bancoDados.delete(caminho: 'orders/$encomendaId');
      }

      /// 4. Apagar o próprio nó do usuário
      await bancoDados.delete(caminho: 'users/$idUtilizador');

      print('Conta e todos os dados foram apagados com sucesso.');
    } catch (e) {
      print('Erro ao apagar conta: $e');
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    // final l10n = AppLocalizations.of(context)!;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Minha Conta",
          style: TextStyle(
            color: PaletaCores.textValue(context),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: PaletaCores.corPrimaria(context),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Cabeçalho do Perfil
            _buildProfileHeader(context),
            const SizedBox(height: 32),

            // Seção de Informações Pessoais
            _buildPersonalInfoSection(context),
            const SizedBox(height: 32),

            // Ações Rápidas
            _buildQuickActionsSection(context),
            const SizedBox(height: 82),

            // Botão de Encerrar Conta (Centralizado)
            Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: screenWidth * 0.8),
                child: _buildDeleteAccountButton(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: PaletaCores.corPrimaria(context),
              width: 3,
            ),
          ),
          child: ClipOval(
            child: Image.asset(Imagens.agricultor, fit: BoxFit.cover),
          ),
        ),
      ],
    );
  }

  Widget _buildPersonalInfoSection(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildInfoTile(
              context: context,
              icon: Icons.person_outline,
              title: 'Nome Completo',
              value: utilizador.nomeUtilizador,
            ),
            const Divider(height: 24, thickness: 0.5),
            _buildInfoTile(
              context: context,
              icon: Icons.email_outlined,
              title: 'Email',
              value: utilizador.email,
            ),
            const Divider(height: 24, thickness: 0.5),
            _buildInfoTile(
              context: context,
              icon: Icons.phone_outlined,
              title: 'Telefone',
              value: utilizador.telefone ?? 'Não informado',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 24, color: PaletaCores.corPrimaria(context)),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActionsSection(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 120,
        child: Column(
          children: [
            _buildActionButton(
              context: context,
              icon: Icons.shopping_bag_outlined,
              label: 'Encomendas',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => HistoricoEncomendasScreen(
                          userId: utilizador.idUtilizador,
                        ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 56,
            decoration: BoxDecoration(
              color: PaletaCores.corPrimaria(context),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 28, color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildDeleteAccountButton(BuildContext context) {
    return OutlinedButton.icon(
      icon: const Icon(Icons.delete_outline, size: 20),
      label: const Text(
        'APAGAR CONTA',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      style: OutlinedButton.styleFrom(
        foregroundColor: PaletaCores.dangerColor(context),
        side: BorderSide(color: PaletaCores.dangerColor(context)),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onPressed: () => _showDeleteConfirmationDialog(context),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text('Confirmar Exclusão'),
            content: const Text(
              'Tens certeza que deseja encerrar sua conta? Esta ação não pode ser desfeita.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () async {
                  final FirebaseAuth auth = FirebaseAuth.instance;
                  final user = auth.currentUser;

                  if (user == null) {
                    print('Nenhum utilizador autenticado.');
                    return;
                  }

                  try {
                    await apagarConta(utilizador.idUtilizador);
                    await user.delete();
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'requires-recent-login') {
                      print(
                        'Reautentique o usuário para poder apagar a conta.',
                      );
                      // Aqui você pode solicitar que o usuário faça login novamente e depois tente apagar.
                    } else {
                      print('Erro na exclusão da conta: ${e.message}');
                    }
                  } catch (e) {
                    print('Erro inesperado: $e');
                  }

                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => LoginTela()),
                    (route) => false,
                  );
                  // Adicione aqui a lógica para deletar a conta
                },
                child: Text(
                  'Encerrar Conta',
                  style: TextStyle(color: PaletaCores.dangerColor(context)),
                ),
              ),
            ],
          ),
    );
  }
}
