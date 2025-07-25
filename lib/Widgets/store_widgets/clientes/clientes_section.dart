import 'package:flutter/material.dart';
import 'package:hellofarmer/Core/cores.dart';
import 'package:hellofarmer/Model/utilizador.dart';
import 'package:hellofarmer/Services/basedados.dart';

class ClientesSection extends StatefulWidget {
  final String storeId;
  const ClientesSection({super.key, required this.storeId});

  @override
  State<ClientesSection> createState() => _ClientesSectionState();
}

class _ClientesSectionState extends State<ClientesSection> {
  final  _bancoDados = BancoDadosServico();
  List<Utilizador> clientes = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    carregarClientes();
  }

  Future<void> carregarClientes() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final clientesRaw = await lerClientesDaLoja(widget.storeId);

      final listaClientes =
          clientesRaw.map((map) {
            final mapa = Map<String, dynamic>.from(
              map.map((key, value) => MapEntry(key.toString(), value)),
            );

            return Utilizador(
              idUtilizador: mapa['id'] ?? '',
              nomeUtilizador: mapa['nome'] ?? '',
              email: mapa['email'] ?? '',
            );
          }).toList();

      setState(() {
        clientes = listaClientes;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Erro ao carregar clientes: $e';
        isLoading = false;
      });
    }
  }

  Future<List<Map<String, dynamic>>> lerClientesDaLoja(String storeId) async {
    final snapshot = await _bancoDados.read(caminho: 'stores/$storeId/clientes');

    if (snapshot == null || snapshot.value == null) return [];

    if (snapshot.value is List) {
      final rawList = snapshot.value as List;

      // Convertendo cada item individualmente para Map<String, dynamic>
      return rawList
          .where((item) => item is Map) // ignora null ou valores inválidos
          .map(
            (item) => Map<String, dynamic>.from(
              (item as Map).map(
                (key, value) => MapEntry(key.toString(), value),
              ),
            ),
          )
          .toList();
    }

    return [];
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
        backgroundColor: PaletaCores.corPrimaria(context),
        centerTitle: true,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: Colors.grey[100],
      body:
          isLoading
              ? const Center(
                child: CircularProgressIndicator(color: Colors.blueAccent),
              )
              : errorMessage != null
              ? Center(
                child: Text(
                  errorMessage!,
                  style: theme.textTheme.bodyLarge?.copyWith(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              )
              : clientes.isEmpty
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
                itemCount: clientes.length,
                itemBuilder: (context, index) {
                  final cliente = clientes[index];
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
                          cliente.nomeUtilizador.isNotEmpty
                              ? cliente.nomeUtilizador.substring(0, 1)
                              : '',
                          style: const TextStyle(
                            color: Colors.teal,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      title: Text(
                        cliente.nomeUtilizador,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        ),
                      ),
                      subtitle: Text(
                        cliente.email,
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
