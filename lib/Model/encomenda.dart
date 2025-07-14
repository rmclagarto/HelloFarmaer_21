


import 'package:hellofarmer/Model/custom_user.dart';
import 'package:hellofarmer/Model/produtos.dart';

enum StatusEncomenda { pendente, concluida, cancelada }

class Encomenda {

 

  final String idEncomenda;
  final List<Produtos> produtos;
  final CustomUser comprador;
  final CustomUser vendedor;
  final int quantidade;
  final DateTime dataPedido;
  final StatusEncomenda status;
  final String code;

  Encomenda({
    required this.idEncomenda,
    required this.produtos,
    required this.comprador,
    required this.vendedor,
    required this.quantidade,
    required this.dataPedido,
    this.status = StatusEncomenda.pendente,
    required this.code,
  });
  


  // static Encomenda fromMap(Map<String, dynamic> map, Produtos produto) {
  //   StatusEncomenda status = StatusEncomenda.values.firstWhere(
  //     (e) => e.name == map['status'],
  //     orElse: () => StatusEncomenda.pendente,
  //   );

  //   return Encomenda(
  //     id: map['id'],
  //     produto: produto,
  //     comprador: CustomUser.fromMap(map['comprador']),
  //     quantidade: map['quantidade'],
  //     dataPedido: DateTime.parse(map['dataPedido']),
  //     status: status,
  //     observacoes: map['observacoes'],
  //   );
  // }
}
