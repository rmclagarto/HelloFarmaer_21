class Produtos {
  

  bool isAsset;

  String idProduto;
  String nomeProduto;
  String categoria;
  String imagem;
  String descricao;
  double preco;
  double quantidade;
  String unidadeMedida;
  DateTime data;
  int? cliques;
  int? comprado;
  List<int>? historicoCliques;
  bool? promovido;
  int? diasPromovido;


  Produtos({
    required this.idProduto,
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
    this.historicoCliques = const [],
    this.promovido = false,
    this.diasPromovido = 0
  });
  

  

}
