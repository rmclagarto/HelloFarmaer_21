import 'package:flutter/material.dart';
import 'package:projeto_cm/Model/produtos.dart';
import 'package:projeto_cm/Core/constants.dart';
import 'package:projeto_cm/Model/custom_user.dart';
import 'package:projeto_cm/Services/encomenda_service.dart';


class EncomendasSection extends StatefulWidget {
  

  const EncomendasSection({
    super.key,
  });

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
        ...List.generate(3 - sampleProducts.length, (i) => sampleProducts[i % sampleProducts.length])
    ];

    if (products.isNotEmpty) {
      orders.add(Encomenda(
        id: 'e1',
        produto: products[0],
        comprador: CustomUser(id: "1",name: 'Ana Silva', email: 'ana@email.com'),
        quantidade: 2,
        dataPedido: DateTime.now().subtract(const Duration(days: 1)),
        status: StatusEncomenda.pendente,
        observacoes: "Por favor entregar até sexta-feira.",
      ));
    }

    if (products.length > 1) {
      orders.add(Encomenda(
        id: 'e2',
        produto: products[1],
        comprador: CustomUser(id: "2",name: 'Carlos', email: 'carlos@email.com'),
        quantidade: 1,
        dataPedido: DateTime.now().subtract(const Duration(days: 3)),
        status: StatusEncomenda.concluida,
      ));
    }

    if (products.length > 2) {
      orders.add(Encomenda(
        id: 'e3',
        produto: products[2],
        comprador: CustomUser(id:"3",name: 'Joana Mendes', email: 'joana@email.com'),
        quantidade: 1,
        dataPedido: DateTime.now().subtract(const Duration(days: 2)),
        status: StatusEncomenda.cancelada,
        observacoes: "Cancelado pelo cliente",
      ));
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

  void _showDetalhesEncomenda(Encomenda encomenda) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Detalhes da Encomenda"),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _detailRow("Produto:", encomenda.produto.title),
              _detailRow("Preço:", encomenda.produto.price.toString()),
              _detailRow("Descrição:", encomenda.produto.description),
              const SizedBox(height: 12),
              _detailRow("Comprador:", encomenda.comprador.name),
              _detailRow("Email:", encomenda.comprador.email),
              const SizedBox(height: 12),
              _detailRow("Quantidade:", encomenda.quantidade.toString()),
              _detailRow("Data do pedido:", _formatDate(encomenda.dataPedido)),
              _detailRow(
                "Status:",
                _statusLabel(encomenda.status),
              ),
              if (encomenda.observacoes != null)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Text(
                    "Observações: ${encomenda.observacoes}",
                    style: const TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Fechar"),
          ),
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(color: Colors.black87, fontSize: 14),
          children: [
            TextSpan(
              text: "$label ",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: value),
          ],
        ),
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
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
            onTap: () => _showDetalhesEncomenda(encomenda),
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