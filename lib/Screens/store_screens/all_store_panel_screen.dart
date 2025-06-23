import 'package:flutter/material.dart';
import 'package:projeto_cm/Core/constants.dart';
import 'package:projeto_cm/Screens/store_screens/my_strore_screen.dart';
import 'package:projeto_cm/Model/store.dart';
import 'package:projeto_cm/Widgets/store_widgets/forms/create_store_form.dart';
// import 'package:projeto_cm/Widgets/store_widgets/forms/create_store_form.dart';
import 'package:projeto_cm/Widgets/store_widgets/store_card.dart';

class ListStorePanelScreen extends StatefulWidget {
  const ListStorePanelScreen({super.key});

  @override
  State<ListStorePanelScreen> createState() => _ListStorePanelScreenState();
}

class _ListStorePanelScreenState extends State<ListStorePanelScreen> {
  final List<Store> _stores = []; // Armazena as lojas

  @override
  void initState() {
    super.initState();
    final lojaTeste = Store(
      id: '1',
      nome: 'Loja Exemplo',
      descricao: 'Descrição da loja exemplo para testes.',
      telefone: '12345678901',
      endereco: {
        'rua': 'Rua Teste',
        'numero': '123',
        'bairro': 'Bairro Teste',
        'cidade': 'Cidade Teste',
        'estado': 'ST',
      },
      avaliacoes: 4.5,
    );

    _addStore(lojaTeste); // Adiciona uma loja de exemplo
  }

  void _addStore(Store store) {
    setState(() {
      _stores.add(store);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            "Minhas Lojas", 
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
        ),
        backgroundColor: Constants.primaryColor,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Expanded(
            child:
                _stores.isEmpty
                    ? const Center(child: Text("Nenhuma loja cadastrada."))
                    : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _stores.length,
                      itemBuilder: (context, index) {
                        final store = _stores[index];
                        return StoreCard(
                          store: store,
                          onTap: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => MainStoreScreen(loja: store)),
                            );

                            if(result != null &&  result is Map && result['delete'] == true) {
                              setState(() {
                                _removeStore(store.id);
                              });
                            }

                            
                          },
                        );
                      },
                    ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Constants.primaryColor,
        onPressed: () async {
          final novaLoja = await Navigator.push<Store>(
            context,
            MaterialPageRoute(builder: (context) => const CreateStoreForm()),
          );
          if (novaLoja != null) _addStore(novaLoja);
        },
        child: const Icon(Icons.add, size: 32, color: Colors.white),
      ),
    );
  }

  void _removeStore(String storeId) {
  setState(() {
    _stores.removeWhere((store) => store.id == storeId);
  });
}

}
