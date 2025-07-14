class Store {
  final String idLoja;
  final String nomeLoja;
  final String descricao;
  final String telefone;
  final Map<String, String> endereco;
  final double avaliacoes;
  final String imagem;
  final double? faturamento;

  Store.myStore({
    required this.idLoja,
    required this.nomeLoja,
    required this.descricao,
    required this.telefone,
    required this.endereco,
    required this.avaliacoes,
    required this.imagem,
    required this.faturamento,
  });


  // Store.viewStore({

  // });
}