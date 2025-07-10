import 'package:flutter/foundation.dart';
import 'package:hellofarmer/Model/produtos.dart';
import 'package:hellofarmer/Model/store.dart';

class MyStoreProvider with ChangeNotifier {
  List<Produtos> _todosProdutos = [];

  List<Produtos> getProdutosDaLoja(Store loja) {
  // Aqui você precisa filtrar os produtos da sua lista geral de produtos
  // por exemplo:
  return _todosProdutos.where((p) => p.loja.id == loja.id).toList();
}


  void addStore(){
    notifyListeners();
  }

  void removeStore(){
    notifyListeners();
  }

}