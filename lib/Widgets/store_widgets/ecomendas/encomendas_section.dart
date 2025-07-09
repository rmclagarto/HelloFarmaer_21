
import 'package:flutter/material.dart';
import 'package:hellofarmer/Core/constants.dart';
import 'package:hellofarmer/Model/custom_user.dart';
import 'package:hellofarmer/Model/produtos.dart';
import 'package:hellofarmer/Services/encomenda_service.dart';


class EncomendasSection extends StatefulWidget {
  const EncomendasSection({super.key});

  @override
  State<EncomendasSection> createState() => _EncomendasSectionState();
}

class _EncomendasSectionState extends State<EncomendasSection>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late List<Encomenda> _encomendas;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _encomendas = _createSampleOrders();
    _tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Helper method to create sample orders safely
  List<Encomenda> _createSampleOrders() {
    final sampleProducts = Produtos.sampleAds();
    final orders = <Encomenda>[];

    final products = [
      ...sampleProducts,
      if (sampleProducts.isNotEmpty && sampleProducts.length < 3)
        ...List.generate(
          3 - sampleProducts.length,
          (i) => sampleProducts[i % sampleProducts.length],
        ),
    ];

    if (products.isNotEmpty) {
      orders.add(
        Encomenda(
          id: 'e1',
          produto: products[0],
          comprador: CustomUser(
            id: "1",
            name: 'Ana Silva',
            email: 'ana@email.com',
          ),
          quantidade: 2,
          dataPedido: DateTime.now().subtract(const Duration(days: 1)),
          status: StatusEncomenda.pendente,
          observacoes: "Por favor entregar até sexta-feira.",
        ),
      );
    }

    if (products.length > 1) {
      orders.add(
        Encomenda(
          id: 'e2',
          produto: products[1],
          comprador: CustomUser(
            id: "2",
            name: 'Carlos',
            email: 'carlos@email.com',
          ),
          quantidade: 1,
          dataPedido: DateTime.now().subtract(const Duration(days: 3)),
          status: StatusEncomenda.concluida,
        ),
      );
    }

    if (products.length > 2) {
      orders.add(
        Encomenda(
          id: 'e3',
          produto: products[2],
          comprador: CustomUser(
            id: "3",
            name: 'Joana Mendes',
            email: 'joana@email.com',
          ),
          quantidade: 1,
          dataPedido: DateTime.now().subtract(const Duration(days: 2)),
          status: StatusEncomenda.cancelada,
          observacoes: "Cancelado pelo cliente",
        ),
      );
    }

    return orders;
  }

  List<Encomenda> get _pendentes =>
      _encomendas.where((e) => e.status == StatusEncomenda.pendente).toList();

  List<Encomenda> get _concluidas =>
      _encomendas.where((e) => e.status == StatusEncomenda.concluida).toList();

  List<Encomenda> get _canceladas =>
      _encomendas.where((e) => e.status == StatusEncomenda.cancelada).toList();

  // final List<Encomenda> _encomendas = _createSampleOrders();

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
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 20),

            _detailRow("Produto", encomenda.produto.title),
            _detailRow("Preço", "${encomenda.produto.price} €"),
            _detailRow("Descrição", encomenda.produto.description),
            _detailRow("Comprador", encomenda.comprador.name),
            _detailRow("Email", encomenda.comprador.email),
            _detailRow("Quantidade", encomenda.quantidade.toString()),
            _detailRow("Data", _formatDate(encomenda.dataPedido)),
            _detailRow("Estado", _statusLabel(encomenda.status)),

            if (encomenda.observacoes != null &&
                encomenda.observacoes!.isNotEmpty)
              _detailRow("Observações", encomenda.observacoes!),

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
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      final codigo = codigoEntregaController.text.trim();
                      // Podes validar ou processar o código aqui
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
                        fontWeight: FontWeight.bold
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
                      fontWeight: FontWeight.bold
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
              encomenda.produto.title,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Text("Comprador: ${encomenda.comprador.name}"),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Qtd: ${encomenda.quantidade}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
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
