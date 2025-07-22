import 'package:flutter/material.dart';
import 'package:hellofarmer/Core/constants.dart';
import 'package:hellofarmer/Model/encomenda.dart';
import 'package:hellofarmer/Services/database_service.dart';

class HistoricoEncomendasScreen extends StatelessWidget {
  final String userId;
  const HistoricoEncomendasScreen({super.key, required this.userId});

  Future<List<Encomenda>> _fetchEncomendas() async {
    final DatabaseService _dbService = DatabaseService();
    final querySnapshot = await _dbService.read(path: 'users/$userId/listEncomendasId');

    if (querySnapshot == null || !querySnapshot.exists) {
      return [];
    }

    List<Encomenda> encomendas = [];
    final encomendasIds = querySnapshot.value as List<dynamic>;

    for (var id in encomendasIds) {
      final encomendaSnapshot = await _dbService.read(path: 'orders/$id');
      if (encomendaSnapshot != null && encomendaSnapshot.exists) {
        try {
          final encomendaData = Map<String, dynamic>.from(encomendaSnapshot.value as Map);
          encomendas.add(Encomenda.fromJson(encomendaData));
        } catch (e) {
          debugPrint('Erro ao processar encomenda $id: $e');
        }
      }
    }

    //Filtra apenas encomendas pendentes
    encomendas = encomendas.where((e) => e.status == StatusEncomenda.pendente).toList();
    
    // Ordena por data (mais recente primeiro)
    encomendas.sort((a, b) => b.dataPedido.compareTo(a.dataPedido));
    
    return encomendas;
  }

  String _formatStatus(StatusEncomenda status) {
    switch (status) {
      case StatusEncomenda.pendente:
        return 'Pendente';
      case StatusEncomenda.concluida:
        return 'Concluída';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Minhas Encomendas",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Constants.primaryColor,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder<List<Encomenda>>(
        future: _fetchEncomendas(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Erro ao carregar encomendas: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Ainda não tens encomendas.'));
          } else {
            final orders = snapshot.data!;
            return ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: ListTile(
                    title: Text('Encomenda #${order.idEncomenda.substring(0, 8)}'),
                    
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Código: ${order.code}'),
                        Text('Status: ${_formatStatus(order.status)}'),
                      ],
                    ),
                    
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}