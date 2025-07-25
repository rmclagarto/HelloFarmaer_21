import 'package:flutter/material.dart';
import 'package:hellofarmer/Core/cores.dart';
import 'package:hellofarmer/Model/loja.dart';
import 'package:hellofarmer/Providers/utilizador_provider.dart';
import 'package:hellofarmer/Screens/store_screens/my_strore_screen.dart';
import 'package:hellofarmer/Services/basedados.dart';
import 'package:hellofarmer/Widgets/store_widgets/forms/criar_loja_form.dart';
import 'package:hellofarmer/Widgets/store_widgets/cartao_loja.dart';
import 'package:provider/provider.dart';

class ListStorePanelScreen extends StatefulWidget {
  const ListStorePanelScreen({super.key});

  @override
  State<ListStorePanelScreen> createState() => _ListStorePanelScreenState();
}

class _ListStorePanelScreenState extends State<ListStorePanelScreen> {
  final BancoDadosServico _dbService = BancoDadosServico();
  List<Loja> _stores = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadUserStores();
  }

  Future<void> _loadUserStores() async {
    final userProvider = Provider.of<UtilizadorProvider>(context, listen: false);
    final user = userProvider.utilizador;

    if (user == null) {
      setState(() {
        _errorMessage = 'Usuário não autenticado';
        _isLoading = false;
      });
      return;
    }
    try {
      final List<Loja> loadedStores = [];

      // Buscar cada loja individualmente pelos IDs

      for (final storeId in user.minhasLojas ?? []) {
        final storeData = await _dbService.read(caminho: 'stores/$storeId');
        if (storeData?.value != null) {
          loadedStores.add(
            Loja.fromJson(Map<String, dynamic>.from(storeData!.value as Map)),
          );
        }
      }

      if (!mounted) return;

      setState(() {
        _stores = loadedStores;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _errorMessage = 'Erro ao carregar lojas: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Minhas Lojas",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: PaletaCores.corPrimaria(context),
        centerTitle: true,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator(color: Colors.blueAccent,))
              : _errorMessage != null
              ? Center(child: Text(_errorMessage!))
              : _stores.isEmpty
              ? const Center(
                child: Text("Ainda não possui lojas."),
              )
              : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _stores.length,
                itemBuilder: (context, index) {
                  final store = _stores[index];
                  return CartaoLoja(
                    loja: store,
                    onTap: () => irParaLoja(context, store),
                  );
                },
              ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: PaletaCores.corPrimaria(context),
        onPressed: () => criarNovaLoja(context),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Future<void> irParaLoja(BuildContext context, Loja store) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => MainStoreScreen(loja: store)),
    );

    if (result == true) {
      await _loadUserStores();
    }
  }

  Future<void> criarNovaLoja(BuildContext context) async {
    final lojaNova = await Navigator.push<Loja>(
      context,
      MaterialPageRoute(builder: (_) => const CriarLojaForm()),
    );

    if (lojaNova != null) {
      
      final userProvider = Provider.of<UtilizadorProvider>(context, listen: false);
      await userProvider.adicionarLojaAoUtilizador(lojaNova.idLoja);
      await _loadUserStores();
    }
  }
}
