class Store {
  final String idLoja;
  final String nomeLoja;
  final String descricao;
  final String telefone;
  final Map<String, dynamic> endereco;
  final double avaliacoes;
  String? imagem;
  final double? faturamento;
  List<String>? listProductsId;

  Store.myStore({
    required this.idLoja,
    required this.nomeLoja,
    required this.descricao,
    required this.telefone,
    required this.endereco,
    required this.avaliacoes,
    this.imagem = "",
    required this.faturamento,
    this.listProductsId = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      "idLoja": idLoja,
      "nomeLoja": nomeLoja,
      "descricao": descricao,
      "telefone": telefone,
      "endereco": endereco,
      "avaliacoes": avaliacoes,
      "imagem": imagem,
      "faturamento": faturamento,
      "listaProdutosId": listProductsId,
    };
  }

  factory Store.fromJson(Map<String, dynamic> json) {
    return Store.myStore(
      idLoja: json['idLoja'],
      nomeLoja: json['nomeLoja'],
      descricao: json['descricao'],
      telefone: json['telefone'],
      endereco: Map<String, dynamic>.from(json['endereco']),
      avaliacoes: (json['avaliacoes'] as num).toDouble(),
      imagem: json['imagem'] ?? '',
      faturamento: (json['faturamento'] as num?)?.toDouble(),
      listProductsId: List<String>.from(json['listaProdutosId'] ?? []),
    );
  }
}
