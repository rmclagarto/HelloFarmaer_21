import 'package:projeto_cm/Model/produtos.dart';
import 'package:projeto_cm/Model/custom_user.dart';

enum StatusEncomenda { pendente, concluida, cancelada }

class Encomenda {
  final String id;               // ID única da encomenda
  final Produtos produto;        // Produto comprado
  final CustomUser comprador;          // Quem comprou
  final int quantidade;          // Quantidade comprada
  final DateTime dataPedido;     // Data da encomenda
  final StatusEncomenda status;  // Status da encomenda
  final String? observacoes;     // Observações adicionais

  Encomenda({
    required this.id,
    required this.produto,
    required this.comprador,
    required this.quantidade,
    required this.dataPedido,
    this.status = StatusEncomenda.pendente,
    this.observacoes,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'produto': produto.title, // ou produto.id se for melhor
      'comprador': comprador.toMap(),
      'quantidade': quantidade,
      'dataPedido': dataPedido.toIso8601String(),
      'status': status.name, // grava apenas "pendente", "concluida", etc.
      'observacoes': observacoes,
    };
  }

  static Encomenda fromMap(Map<String, dynamic> map, Produtos produto) {
    StatusEncomenda status = StatusEncomenda.values.firstWhere(
      (e) => e.name == map['status'],
      orElse: () => StatusEncomenda.pendente,
    );

    return Encomenda(
      id: map['id'],
      produto: produto,
      comprador: CustomUser.fromMap(map['comprador']),
      quantidade: map['quantidade'],
      dataPedido: DateTime.parse(map['dataPedido']),
      status: status,
      observacoes: map['observacoes'],
    );
  }
}
