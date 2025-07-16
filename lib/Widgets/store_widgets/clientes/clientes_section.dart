import 'package:flutter/material.dart';
import 'package:hellofarmer/Core/constants.dart';
import 'package:hellofarmer/Model/custom_user.dart';
import 'package:hellofarmer/Screens/store_screens/detalhes_clientes_page.dart';
import 'package:hellofarmer/Services/database_service.dart';

class ClientesSection extends StatefulWidget {
  final String storeId;
  const ClientesSection({super.key, required this.storeId});

  @override
  State<ClientesSection> createState() => _ClientesSectionState();
}

class _ClientesSectionState extends State<ClientesSection> {
  final DatabaseService _dbService = DatabaseService();
  List<CustomUser> clients = [];
  bool isLoading = true;
  String? errorMessage;

  final List<String> grupos = ['Todos', 'VIP', 'Regular', 'Novo'];
  String grupoSelecionado = 'Todos';

  @override
  void initState() {
    super.initState();
    _loadClientes();
  }

  Future<void> _loadClientes() async {
    try {
      final snapshot = await _dbService.read(
        path: 'stores/${widget.storeId}/ListClientes',
      );

      if (snapshot?.value == null) {
        setState(() {
          isLoading = false;
          clients = [];
        });
        return;
      }

      final List<dynamic> clientesIds =
          snapshot!.value is List ? List.from(snapshot.value as List) : [];

      // 2. Buscar dados de cada cliente
      final List<CustomUser> clientesTemp = [];

      for (final clienteId in clientesIds) {
        final userSnapshot = await _dbService.read(path: 'users/$clienteId');

        if (userSnapshot?.value != null) {
          final userData = Map<String, dynamic>.from(
            userSnapshot!.value as Map,
          );
          clientesTemp.add(CustomUser.fromJson(userData));
        }
      }

      setState(() {
        clients = clientesTemp;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Erro ao carregar clientes: ${e.toString()}';
        isLoading = false;
      });
    }
  }

  List<CustomUser> get clientesFiltrados {
    if (grupoSelecionado == 'Todos') return clients;
    return clients.where((c) => c.grupo == grupoSelecionado).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Clientes da Loja',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Constants.primaryColor,
        centerTitle: true,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: Colors.grey[100],
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: InputDecorator(
              decoration: InputDecoration(
                labelText: 'Filtrar por grupo',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                suffixIcon: const Icon(
                  Icons.filter_list,
                  color: Constants.primaryColor,
                ),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: grupoSelecionado,
                  isExpanded: true,
                  items:
                      grupos.map((grupo) {
                        return DropdownMenuItem(
                          value: grupo,
                          child: Text(grupo),
                        );
                      }).toList(),
                  onChanged: (novoGrupo) {
                    if (novoGrupo != null) {
                      setState(() {
                        grupoSelecionado = novoGrupo;
                      });
                    }
                  },
                ),
              ),
            ),
          ),
          Expanded(
            child:
                clientesFiltrados.isEmpty
                    ? Center(
                      child: Text(
                        'Nenhum cliente encontrado.',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    )
                    : ListView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      itemCount: clientesFiltrados.length,
                      itemBuilder: (context, index) {
                        final cliente = clientesFiltrados[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            leading: CircleAvatar(
                              backgroundColor: Colors.teal[200],
                              child: Text(
                                cliente.nomeUser.substring(0, 1),
                                style: const TextStyle(
                                  color: Colors.teal,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            title: Text(
                              cliente.nomeUser,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                              ),
                            ),
                            subtitle: Text(
                              cliente.email,
                              style: TextStyle(color: Colors.grey[700]),
                            ),
                            trailing: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    cliente.grupo == 'VIP'
                                        ? Colors.amber[200]
                                        : cliente.grupo == 'Regular'
                                        ? Colors.blue[100]
                                        : Colors.green[100],
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                cliente.grupo!,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            onTap: () {
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) => DetalhesClientePage(cliente: cliente),
                              //   ),
                              // );
                            },
                          ),
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }
}
