class Produto {
  bool isAsset;

  String idProduto;
  String idLoja;
  String nomeProduto;
  String categoria;
  String imagem;
  String descricao;
  double preco;
  int quantidade;
  String unidadeMedida;
  DateTime data;
  int? cliques;
  int? comprado;
  List<int>? historicoCliques;
  bool? promovido;
  int? diasPromovido;

  Produto({
    required this.idProduto,
    required this.idLoja,
    required this.nomeProduto,
    required this.categoria,
    required this.imagem,
    required this.isAsset,
    required this.descricao,
    required this.preco,
    required this.quantidade,
    required this.unidadeMedida,
    required this.data,
    this.cliques = 0,
    this.comprado = 0,
    this.promovido = false,
    this.diasPromovido = 0,
  });

  factory Produto.fromJson(Map<String, dynamic> json) {
    return Produto(
      idProduto: json['idProduto'],
      idLoja: json['idLoja'],
      nomeProduto: json['nomeProduto'],
      categoria: json['categoria'],
      imagem: json['imagem'],
      isAsset: json['isAsset'] ?? false,
      descricao: json['descricao'],
      preco: json['preco'].toDouble(),
      quantidade: int.tryParse(json['quantidade'].toString()) ?? 0,
      unidadeMedida: json['unidadeMedida'],
      data: DateTime.parse(json['data']),
      cliques: json['cliques'] ?? 0,
      comprado: json['comprado'] ?? 0,
      promovido: json['promovido'] ?? false,
      diasPromovido: json['diasPromovido'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idProduto': idProduto,
      'idLoja': idLoja,
      'nomeProduto': nomeProduto,
      'categoria': categoria,
      'imagem': imagem,
      'isAsset': isAsset,
      'descricao': descricao,
      'preco': preco,
      'quantidade': quantidade,
      'unidadeMedida': unidadeMedida,
      'data': data.toIso8601String(),
      'cliques': cliques,
      'comprado': comprado,
      'promovido': promovido,
      'diasPromovido': diasPromovido,
    };
  }

  Produto copyWith({
    String? idProduto,
    String? idLoja,
    String? nomeProduto,
    String? categoria,
    String? imagem,
    bool? isAsset,
    String? descricao,
    double? preco,
    int? quantidade,
    String? unidadeMedida,
    DateTime? data,
    int? cliques,
    int? comprado,
    List<int>? historicoCliques,
    bool? promovido,
    int? diasPromovido,
  }) {
    return Produto(
      idProduto: idProduto ?? this.idProduto,
      idLoja: idLoja ?? this.idLoja,
      nomeProduto: nomeProduto ?? this.nomeProduto,
      categoria: categoria ?? this.categoria,
      imagem: imagem ?? this.imagem,
      isAsset: isAsset ?? this.isAsset,
      descricao: descricao ?? this.descricao,
      preco: preco ?? this.preco,
      quantidade: quantidade ?? this.quantidade,
      unidadeMedida: unidadeMedida ?? this.unidadeMedida,
      data: data ?? this.data,
      cliques: cliques ?? this.cliques,
      comprado: comprado ?? this.comprado,
      promovido: promovido ?? this.promovido,
      diasPromovido: diasPromovido ?? this.diasPromovido,
    );
  }
}
