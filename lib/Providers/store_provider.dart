import 'package:flutter/foundation.dart';
import 'package:hellofarmer/Model/encomenda.dart';
import 'package:hellofarmer/Model/produtos.dart';
import 'package:hellofarmer/Model/store.dart';

class StoreProvider with ChangeNotifier {
  final List<Store> _stores = [];
  final List<Produtos> _products = [];
  final List<Encomenda> _encomendas = [];
  // final Map<String, StoreMetrics> _metrics = {};

  List<Store> get userStore => _stores;

  List<Produtos> getProdutosDaLoja(String storeId){
    return _products.where((p) => p.idProduto == storeId).toList(); 
  }


  List<Encomenda> getEncomendasDaLoja(){ // incompleto
    return _encomendas;
  }


  void addStore(Store store){
    _stores.add(store);
    notifyListeners();
  }

  void removeStore(Store store){
    _stores.remove(store);
    notifyListeners();
  }

  void addProduct(Produtos produto){
    _products.add(produto);
    notifyListeners();
  }

  void removeProduct(Produtos produto){
    _products.remove(produto);
    notifyListeners();
  }




}