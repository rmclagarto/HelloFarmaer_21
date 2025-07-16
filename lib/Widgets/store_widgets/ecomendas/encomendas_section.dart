import 'package:flutter/material.dart';
import 'package:hellofarmer/Core/constants.dart';
import 'package:hellofarmer/Model/custom_user.dart';
// import 'package:hellofarmer/Model/custom_user.dart';
import 'package:hellofarmer/Model/encomenda.dart';
import 'package:hellofarmer/Model/produtos.dart';
import 'package:hellofarmer/Model/store.dart';
import 'package:hellofarmer/Services/database_service.dart';
// import 'package:hellofarmer/Model/produtos.dart';

class EncomendasSection extends StatefulWidget {
  final String storeId;

  const EncomendasSection({super.key, required this.storeId});

  @override
  State<EncomendasSection> createState() => _EncomendasSectionState();
}

class _EncomendasSectionState extends State<EncomendasSection>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late List<Encomenda> _encomendas = [];
  final Map<String, Produtos> _produtosCache = {};
  final Map<String, CustomUser> _usersCache = {};
  Store? _store;

  final DatabaseService _dbService = DatabaseService();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });

    _loadStoreAndEcomendas();
  }

  Future<void> _loadStoreAndEcomendas() async {
    // Primeiro busca a store
    final storeSnapshot = await _dbService.read(
      path: 'stores/${widget.storeId}',
    );
    if (storeSnapshot == null || storeSnapshot.value == null) {
      debugPrint('Store not found');
      return;
    }

    final data = storeSnapshot.value as Map?;
    final List<String> listaIDs = List<String>.from(
      data?['listaEncomendasId'] ?? [],
    );

    _store = Store.fromJson(storeSnapshot.value as Map<String, dynamic>);

    // Load orders
    if (_store?.listEncomendasId == null || _store!.listEncomendasId!.isEmpty) {
      setState(() {
        _encomendas = [];
      });
      return;
    }

    List<Encomenda> encomendas = [];

    for (String id in listaIDs) {
      final doc = await _dbService.read(path: 'ordes/$id');
      if (doc != null && doc.value != null) {
        final docData = doc.value as Map<String, dynamic>;
        encomendas.add(Encomenda.fromJson(docData));
      }
    }

    // Load additional data for each order
    for (var encomenda in encomendas) {
      // Load product data
      if (encomenda.pedidos != null && encomenda.pedidos!.isNotEmpty) {
        for (var produtoId in encomenda.pedidos!) {
          if (!_produtosCache.containsKey(produtoId)) {
            final produtoDoc = await _dbService.read(
              path: 'products/$produtoId',
            );
            if (produtoDoc != null && produtoDoc.value != null) {
              _produtosCache[produtoId] = Produtos.fromJson(
                produtoDoc.value as Map<String, dynamic>,
              );
            }
          }
        }
      }

      // Load buyer data
      if (!_usersCache.containsKey(encomenda.compradorId)) {
        final userDoc = await _dbService.read(
          path: 'users/${encomenda.compradorId}',
        );
        if (userDoc != null && userDoc.value != null) {
          _usersCache[encomenda.compradorId] = CustomUser.fromJson(
            userDoc.value as Map<String, dynamic>,
          );
        }
      }
    }

    setState(() {
      _encomendas = encomendas;
    });
  }

  Future<void> _updateOderStatus(
    String orderId,
    StatusEncomenda newStatus,
  ) async {
    try {
      await _dbService.update(
        path: 'orders/$orderId',
        data: {'status': newStatus.toString().split('.').last},
      );

      // Reload data
      await _loadStoreAndEcomendas();
    } catch (e) {
      debugPrint('Error updating order status: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao atualizar status: $e')));
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Encomenda> get _pendentes =>
      _encomendas.where((e) => e.status == StatusEncomenda.pendente).toList();

  List<Encomenda> get _concluidas =>
      _encomendas.where((e) => e.status == StatusEncomenda.concluida).toList();

  List<Encomenda> get _canceladas =>
      _encomendas.where((e) => e.status == StatusEncomenda.cancelada).toList();

  // final List<Encomenda> _encomendas = _createSampleOrders();

  void _showDetalhesEncomenda(BuildContext context, Encomenda encomenda) {
    final TextEditingController codigoEntregaController =
        TextEditingController(text: encomenda.code);


    final produto = encomenda.pedidos != null && encomenda.pedidos!.isNotEmpty
        ? _produtosCache[encomenda.pedidos!.first]
        : null;
    
    // Get buyer info
    final comprador = _usersCache[encomenda.compradorId];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (context) => Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const Center(
                    child: Text(
                      "Detalhes da Encomenda",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  _detailRow("Produto", produto!.nomeProduto),
                  _detailRow("Preço", "${produto.preco} €"),
                  _detailRow("Descrição", produto.descricao),
                  _detailRow("Comprador", comprador!.nomeUser),
                  _detailRow("Email", comprador.email),
                  _detailRow("Telefone", comprador.telefone!),

                  _detailRow("Data", _formatDate(encomenda.dataPedido)),
                  _detailRow("Estado", _statusLabel(encomenda.status)),

                  const SizedBox(height: 24),

                  if (encomenda.status == StatusEncomenda.pendente) ...[
                    const Text(
                      "Código de Entrega",
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: codigoEntregaController,
                      decoration: InputDecoration(
                        hintText: "Introduz o código...",
                        prefixIcon: const Icon(Icons.lock_outline),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text(
                            "Cancelar",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () async{
                            await _updateOderStatus(
                              encomenda.idEncomenda,
                              StatusEncomenda.concluida
                            );

                            final codigo = double.parse(
                              codigoEntregaController.text.trim(),
                            );

                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            "Confirmar",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ] else
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          "Fechar",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
    );
  }

  Widget _detailCard(String label, String value) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Text(
                label,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            Expanded(
              flex: 5,
              child: Text(value, style: const TextStyle(color: Colors.black87)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Text(
              "$label:",
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(flex: 5, child: Text(value)),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
  }

  IconData _statusIcon(StatusEncomenda status) {
    switch (status) {
      case StatusEncomenda.pendente:
        return Icons.pending_actions;
      case StatusEncomenda.concluida:
        return Icons.check_circle;
      case StatusEncomenda.cancelada:
        return Icons.cancel;
    }
  }

  Color _statusColor(StatusEncomenda status) {
    switch (status) {
      case StatusEncomenda.pendente:
        return Colors.orange;
      case StatusEncomenda.concluida:
        return Colors.green;
      case StatusEncomenda.cancelada:
        return Colors.red;
    }
  }

  String _statusLabel(StatusEncomenda status) {
    switch (status) {
      case StatusEncomenda.pendente:
        return "Pendente";
      case StatusEncomenda.concluida:
        return "Concluída";
      case StatusEncomenda.cancelada:
        return "Cancelada";
    }
  }

  Widget _buildListaEncomendas(List<Encomenda> encomendas) {
    if (encomendas.isEmpty) {
      return const Center(
        child: Text(
          "Nenhuma encomenda encontrada.",
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: encomendas.length,
      itemBuilder: (context, index) {
        final encomenda = encomendas[index];

        final produto = encomenda.pedidos != null && encomenda.pedidos!.isNotEmpty
            ? _produtosCache[encomenda.pedidos!.first]
            : null;
        final comprador = _usersCache[encomenda.compradorId];


        return Card(
          elevation: 3,
          margin: const EdgeInsets.symmetric(vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            leading: CircleAvatar(
              radius: 26,
              backgroundColor: _statusColor(encomenda.status),
              child: Icon(
                _statusIcon(encomenda.status),
                color: Colors.white,
                size: 28,
              ),
            ),
            title: Text(
              produto?.nomeProduto ?? "Produto desconhecido",
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Text("Comprador: ${comprador?.nomeUser ?? "Desconhecido"}"),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _formatDate(encomenda.dataPedido),
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
            onTap: () => _showDetalhesEncomenda(context, encomenda),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Encomendas",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Constants.primaryColor,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: "Pendentes"),
            Tab(text: "Concluídas"),
            Tab(text: "Canceladas"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildListaEncomendas(_pendentes),
          _buildListaEncomendas(_concluidas),
          _buildListaEncomendas(_canceladas),
        ],
      ),
    );
  }
}
