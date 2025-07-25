import 'package:flutter/material.dart';
import 'package:hellofarmer/Core/cores.dart';
import 'package:hellofarmer/Model/utilizador.dart';
// import 'package:hellofarmer/Model/custom_user.dart';
import 'package:hellofarmer/Model/encomenda.dart';
import 'package:hellofarmer/Model/produto.dart';
import 'package:hellofarmer/Model/loja.dart';
import 'package:hellofarmer/Services/basedados.dart';
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
  final Map<String, Produto> _produtosCache = {};
  final Map<String, Utilizador> _usersCache = {};
  Loja? _store;

  final BancoDadosServico _dbService = BancoDadosServico();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });

    _loadStoreAndEcomendas();
  }

  Future<void> _loadStoreAndEcomendas() async {
    // Primeiro busca a store
    final storeSnapshot = await _dbService.read(
      caminho: 'stores/${widget.storeId}',
    );
    if (storeSnapshot == null || storeSnapshot.value == null) {
      debugPrint('Loja não encontrada');
      return;
    }

    final storeData = Map<String, dynamic>.from(storeSnapshot.value as Map);
    final List<String> listaIDs = List<String>.from(
      storeData['listEncomendasId'] ?? [],
    );

    _store = Loja.fromJson(storeData);

    // Verificar se há encomendas
    if (listaIDs.isEmpty) {
      setState(() {
        _encomendas = [];
      });
      return;
    }

    List<Encomenda> encomendas = [];

    for (String id in listaIDs) {
      final doc = await _dbService.read(caminho: 'orders/$id');
      if (doc != null && doc.value != null) {
        try {
          final docData = Map<String, dynamic>.from(doc.value as Map);
          final encomenda = Encomenda.fromJson(docData);
          encomendas.add(encomenda);
        } catch (e) {
          debugPrint("Erro ao processar encomenda $id: $e");
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
        caminho: 'orders/$orderId',
        dados: {'status': newStatus.toString().split('.').last},
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

 



void _showDetalhesEncomenda(BuildContext context, Encomenda encomenda) {
  final TextEditingController codigoEntregaController = TextEditingController();

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => Padding(
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

            
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Produtos:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                if (encomenda.produtosInfo.isEmpty)
                  const Text("Nenhum produto encontrado")
                else
                  Column(
                    children: encomenda.produtosInfo.map((produto) {
                      final nome = produto['nome']?.toString() ?? 'Produto desconhecido';
                      final qtd = produto['quantidade']?.toString() ?? '0';
                      final precoUnitario = produto['preco'] != null 
                          ? double.tryParse(produto['preco'].toString()) 
                          : null;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 4,
                              child: Text('• $nome'),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text('Qtd: $qtd'),
                            ),
                            // Expanded(
                            //   flex: 3,
                            //   child: Text(
                            //     precoTotal != null 
                            //         ? '${precoTotal.toStringAsFixed(2)} €' 
                            //         : 'Preço indisponível',
                            //     textAlign: TextAlign.end,
                            //   ),
                            // ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
              ],
            ),

            const SizedBox(height: 12),
            
            
            _detailRow("Preço Total", "${encomenda.valor.toStringAsFixed(2)} €"),
            _detailRow("Comprador", encomenda.compradorInfo['nome'] ?? "Comprador desconhecido"),
            _detailRow("Email", encomenda.compradorInfo['email'] ?? "Email não disponível"),
            _detailRow("Telefone", encomenda.compradorInfo['telefone'] ?? "Telefone não disponível"),
            _detailRow("Data", _formatDate(encomenda.dataPedido)),
            _detailRow("Estado", _statusLabel(encomenda.status)),

            const SizedBox(height: 24),

            if (encomenda.status == StatusEncomenda.pendente) ...[
              const Text("Código de Entrega", style: TextStyle(fontWeight: FontWeight.w500)),
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
                  
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () async {
                      final inputCode = codigoEntregaController.text.trim();
                      if (inputCode == encomenda.code.toString()) {
                        await _updateOderStatus(
                          encomenda.idEncomenda,
                          StatusEncomenda.concluida
                        );
                        if (mounted) Navigator.pop(context);
                      }
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
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
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
    }
  }

  Color _statusColor(StatusEncomenda status) {
    switch (status) {
      case StatusEncomenda.pendente:
        return Colors.orange;
      case StatusEncomenda.concluida:
        return Colors.green;
    }
  }

  String _statusLabel(StatusEncomenda status) {
    switch (status) {
      case StatusEncomenda.pendente:
        return "Pendente";
      case StatusEncomenda.concluida:
        return "Concluída";
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

        // final produto = encomenda.pedidos != null && encomenda.pedidos!.isNotEmpty
        //     ? _produtosCache[encomenda.pedidos!.first]
        //     : null;
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
              encomenda.produtosInfo.isNotEmpty
                  ? encomenda.produtosInfo.first['nome'] ??
                      "Produto desconhecido"
                  : "Produto desconhecido",
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),

            subtitle: Text(
              "Comprador: ${encomenda.compradorInfo['nome'] ?? "Desconhecido"}",
            ),
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
        backgroundColor: PaletaCores.corPrimaria(context),
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
            
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildListaEncomendas(_pendentes),
          _buildListaEncomendas(_concluidas),
        ],
      ),
    );
  }
}
