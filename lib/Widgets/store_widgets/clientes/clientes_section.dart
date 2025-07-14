
import 'package:flutter/material.dart';
import 'package:hellofarmer/Core/constants.dart';
import 'package:hellofarmer/Model/custom_user.dart';
import 'package:hellofarmer/Screens/store_screens/detalhes_clientes_page.dart';



class ClientesSection extends StatefulWidget {
  const ClientesSection({super.key});

  @override
  State<ClientesSection> createState() => _ClientesSectionState();
}

class _ClientesSectionState extends State<ClientesSection> {
  final List<CustomUser> clientes = [
    CustomUser(
      idUser: "1",
      nomeUser: 'Ana Silva',
      email: 'ana@email.com',
      telefone: "1234567890",
      grupo: 'VIP',
      historicoCompras: ['Compra 1: 2023-04-01', 'Compra 2: 2023-05-10'],
    ),
    CustomUser(
      idUser: "2",
      nomeUser: 'Carlos Oliveira',
      email: 'carlos@email.com',
      telefone: "1234567890",
      grupo: 'Regular',
      historicoCompras: ['Compra 1: 2023-03-15'],
    ),
    CustomUser(
      idUser: "3",
      nomeUser: 'Joana Mendes',
      email: 'joana@email.com',
      telefone: "1234567890",
      grupo: 'Novo',
      historicoCompras: [],
    ),
    CustomUser(
      idUser: "4",
      nomeUser: 'Pedro Santos',
      email: 'pedro@email.com',
      telefone: "1234567890",
      grupo: 'VIP',
      historicoCompras: ['Compra 1: 2023-01-20', 'Compra 2: 2023-02-25', 'Compra 3: 2023-06-15'],
    ),
  ];

  final List<String> grupos = ['Todos', 'VIP', 'Regular', 'Novo'];

  String grupoSelecionado = 'Todos';

  List<CustomUser> get clientesFiltrados {
    if (grupoSelecionado == 'Todos') return clientes;
    return clientes.where((c) => c.grupo == grupoSelecionado).toList();
  }

  

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Clientes',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
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
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                suffixIcon: const Icon(Icons.filter_list, color: Constants.primaryColor),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: grupoSelecionado,
                  isExpanded: true,
                  items: grupos.map((grupo) {
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
            child: clientesFiltrados.isEmpty
                ? Center(
                    child: Text(
                      'Nenhum cliente encontrado.',
                      style: theme.textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: clientesFiltrados.length,
                    itemBuilder: (context, index) {
                      final cliente = clientesFiltrados[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        elevation: 3,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          leading: CircleAvatar(
                            backgroundColor: Colors.teal[200],
                            child: Text(
                              cliente.nomeUser.substring(0, 1),
                              style: const TextStyle(color: Colors.teal, fontWeight: FontWeight.bold),
                            ),
                          ),
                          title: Text(
                            cliente.nomeUser,
                            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                          ),
                          subtitle: Text(
                            cliente.email,
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                          trailing: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: cliente.grupo == 'VIP'
                                  ? Colors.amber[200]
                                  : cliente.grupo == 'Regular'
                                      ? Colors.blue[100]
                                      : Colors.green[100],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              cliente.grupo!,
                              style: const TextStyle(fontWeight: FontWeight.bold),
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
