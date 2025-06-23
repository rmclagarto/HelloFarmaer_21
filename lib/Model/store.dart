class Store {
  final String id;
  final String nome;
  final String descricao;
  final String telefone;
  final Map<String, String> endereco;
  final double avaliacoes;

  Store({
    required this.id,
    required this.nome,
    required this.descricao,
    required this.telefone,
    required this.endereco,
    required this.avaliacoes
  });
}