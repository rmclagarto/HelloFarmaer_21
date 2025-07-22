
enum StatusEncomenda { pendente, concluida }

class Encomenda {

  final String idEncomenda;
  final String compradorId;
  final String vendedorId;
  final DateTime dataPedido;
  final StatusEncomenda status;
  final int code;
  final double valor;
  Map<String, dynamic> compradorInfo;
  final int quantidade;
  List<Map<String,dynamic>> produtosInfo;

  Encomenda({
    required this.idEncomenda,
    required this.compradorId,
    required this.vendedorId,
    required this.dataPedido,
    this.status = StatusEncomenda.pendente,
    required this.code,
    required this.valor,
    this.quantidade = 0,
    this.compradorInfo = const {
      "nome": "",
      "email": "",
      "telefone": "",
    },
    this.produtosInfo = const []
  });

  Map<String, dynamic> toJson() {
    return {
      'idEncomenda': idEncomenda,
      'compradorId': compradorId,
      'vendedorId': vendedorId,
      'dataPedido': dataPedido.toIso8601String(),
      'status': status.toString().split('.').last,
      'code': code,
      'valor': valor,
      'quantidade': quantidade,
      'compradorInfo': compradorInfo,
      'produtosInfo': produtosInfo,
    };
  }

  factory Encomenda.fromJson(Map<String, dynamic> json) {
    return Encomenda(
      idEncomenda: json['idEncomenda'] as String,
      compradorId: json['compradorId'] as String,
      vendedorId: json['vendedorId'] as String,
      dataPedido: DateTime.parse(json['dataPedido'] as String),
      status: StatusEncomenda.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
        orElse: () => StatusEncomenda.pendente,
      ),
      code: json['code'] as int,
      valor: (json['valor'] as num?)?.toDouble() ?? 0.0,
      quantidade: json['quantidade'] as int,
      compradorInfo: Map<String, dynamic>.from(json['compradorInfo'] ?? {}),
      produtosInfo: (json['produtosInfo'] as List<dynamic>?)
              ?.map((e) => Map<String, dynamic>.from(e))
              .toList() ??
          [],
    );
  }
}
