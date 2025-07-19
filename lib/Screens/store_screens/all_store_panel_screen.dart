import 'package:flutter/material.dart';
import 'package:hellofarmer/Core/constants.dart';
import 'package:hellofarmer/Model/store.dart';
import 'package:hellofarmer/Providers/store_provider.dart';
import 'package:hellofarmer/Providers/user_provider.dart';
import 'package:hellofarmer/Screens/store_screens/my_strore_screen.dart';
import 'package:hellofarmer/Services/database_service.dart';
import 'package:hellofarmer/Widgets/store_widgets/forms/create_store_form.dart';
import 'package:hellofarmer/Widgets/store_widgets/store_card.dart';
import 'package:provider/provider.dart';

class ListStorePanelScreen extends StatefulWidget {
  const ListStorePanelScreen({super.key});

  @override
  State<ListStorePanelScreen> createState() => _ListStorePanelScreenState();
}

class _ListStorePanelScreenState extends State<ListStorePanelScreen> {
  final DatabaseService _dbService = DatabaseService();
  List<Store> _stores = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadUserStores();
  }

  Future<void> _loadUserStores() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final user = userProvider.user;

    if (user == null) {
      setState(() {
        _errorMessage = 'Usuário não autenticado';
        _isLoading = false;
      });
      return;
    }
    try {
      final List<Store> loadedStores = [];

      // Buscar cada loja individualmente pelos IDs

      for (final storeId in user.myStoreList ?? []) {
        final storeData = await _dbService.read(path: 'stores/$storeId');
        if (storeData?.value != null) {
          loadedStores.add(
            Store.fromJson(Map<String, dynamic>.from(storeData!.value as Map)),
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

  // @override
  // Widget build(BuildContext context) {
  //   final userProvider = Provider.of<UserProvider>(context);
  //   final storeProvider = Provider.of<StoreProvider>(context);

  //   if (userProvider.user == null) {
  //     return const Center(child: CircularProgressIndicator());
  //   }

  //   return Scaffold(
  //     appBar: AppBar(
  //       title: const Text(
  //         "Minhas Lojas",
  //         style: TextStyle(
  //           color: Colors.white,
  //           fontWeight: FontWeight.bold
  //         ),
  //       ),
  //       backgroundColor: Constants.primaryColor,
  //       centerTitle: true,
  //       elevation: 0,
  //       iconTheme: const IconThemeData(color: Colors.white),
  //     ),
  //     body: StreamBuilder<List<Store>>(
  //       stream: storeProvider.getUserStores(userProvider.user!.idUser),
  //       builder: (context, snapshot) {
  //         if (snapshot.connectionState == ConnectionState.waiting) {
  //           return const Center(child: CircularProgressIndicator());
  //         }

  //         if (snapshot.hasError) {
  //           return Center(child: Text('Erro: ${snapshot.error}'));
  //         }

  //         final stores = snapshot.data ?? [];
  //         if (stores.isEmpty) {
  //           return const Center(
  //             child: Text("Você ainda não possui lojas cadastradas."),
  //           );
  //         }

  //         return ListView.builder(
  //           padding: const EdgeInsets.all(16),
  //           itemCount: stores.length,
  //           itemBuilder: (context, index) {
  //             final store = stores[index];
  //             return StoreCard(
  //               store: store,
  //               onTap: () => _navigateToStore(context, store),
  //             );
  //           },
  //         );
  //       },
  //     ),
  //     floatingActionButton: FloatingActionButton(
  //       backgroundColor: Constants.primaryColor,
  //       onPressed: () => _createNewStore(context),
  //       child: const Icon(Icons.add, color: Colors.white,),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    // if (_isLoading) {
    //   return const Center(child: CircularProgressIndicator());
    // }

    // if (_errorMessage != null) {
    //   return Center(child: Text(_errorMessage!));
    // }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Minhas Lojas",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Constants.primaryColor,
        centerTitle: true,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _errorMessage != null
              ? Center(child: Text(_errorMessage!))
              : _stores.isEmpty
              ? const Center(
                child: Text("Você ainda não possui lojas."),
              )
              : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _stores.length,
                itemBuilder: (context, index) {
                  final store = _stores[index];
                  return StoreCard(
                    store: store,
                    onTap: () => _navigateToStore(context, store),
                  );
                },
              ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Constants.primaryColor,
        onPressed: () => _createNewStore(context),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Future<void> _navigateToStore(BuildContext context, Store store) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => MainStoreScreen(loja: store)),
    );

    if (result == true) {
      // Atualize a UI se necessário
      // setState(() {});
      await _loadUserStores();
    }
  }

  Future<void> _createNewStore(BuildContext context) async {
    final newStore = await Navigator.push<Store>(
      context,
      MaterialPageRoute(builder: (_) => const CreateStoreForm()),
    );

    if (newStore != null) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      await userProvider.addStoreToUser(newStore.idLoja);
      await _loadUserStores();
    }
  }
}
