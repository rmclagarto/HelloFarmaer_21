import 'package:flutter/widgets.dart';
import 'package:hellofarmer/Model/produtos.dart';

class FavoritesProvider with ChangeNotifier{
  final List<Produtos> _favItens = [];
  List<Produtos> get favItens => _favItens;


  void addToFavorites(Produtos produto) {
    if (!_favItens.contains(produto)) {
      _favItens.add(produto);
      notifyListeners();
    }
  }


  void removeFromFavorites(Produtos produto){
    _favItens.remove(produto);
    notifyListeners();
  }

  bool isFavorite(Produtos produto){
    return _favItens.contains(produto);
  }


}
