
import 'package:flutter/material.dart';
import 'package:hellofarmer/Model/cart.dart';
import 'package:hellofarmer/Model/produtos.dart';

class CartProvider with ChangeNotifier {
  
  final List<CartItem> _cartItens = [];
  List<CartItem> get items => _cartItens;

  int get itemCount => _cartItens.length;

  double get totalPrice {
    return _cartItens.fold(0, (sum, item) => sum + item.totalPrice);
  }


  void addProduct(Produtos product){
    _cartItens.add(CartItem(product: product));
    notifyListeners();
  }


  void removeProduct(int index){
    _cartItens.removeAt(index);
    notifyListeners();
  }

  void incrementQuantity(int index){
    _cartItens[index].quantity++;
    notifyListeners();
  }

  void decrementQuantity(int index){
    if(_cartItens[index].quantity > 1){
      _cartItens[index].quantity--;
    }else{
      _cartItens.removeAt(index);
    }
    notifyListeners();
  }
  
  void clearCart(){
    _cartItens.clear();
    notifyListeners();
  }

}
