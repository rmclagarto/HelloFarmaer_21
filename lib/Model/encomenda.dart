enum StatusEncomenda { pendente, concluida, cancelada }

class Encomenda {

  final String idEncomenda;
  List<String>? pedidos; // lista com os id dos produtos
  final String compradorId;
  final String vendedorId;
  final DateTime dataPedido;
  final StatusEncomenda status;
  final String code;

  Encomenda({
    required this.idEncomenda,
    this.pedidos = const [],
    required this.compradorId,
    required this.vendedorId,
    required this.dataPedido,
    this.status = StatusEncomenda.pendente,
    required this.code,
  });

  Map<String, dynamic> toJson() {
    return {
      'idEncomenda': idEncomenda,
      'pedidos': pedidos,
      'compradorId': compradorId,
      'vendedorId': vendedorId,
      'dataPedido': dataPedido.toIso8601String(),
      'status': status.toString().split('.').last,
      'code': code,
    };
  }

  factory Encomenda.fromJson(Map<String, dynamic> json) {
    return Encomenda(
      idEncomenda: json['idEncomenda'] as String,
      pedidos: (json['pedidos'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
      compradorId: json['compradorId'] as String,
      vendedorId: json['vendedorId'] as String,
      dataPedido: DateTime.parse(json['dataPedido'] as String),
      status: StatusEncomenda.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
        orElse: () => StatusEncomenda.pendente,
      ),
      code: json['code'] as String,
    );
  }
}
