
import 'package:flutter/material.dart';
import 'package:hellofarmer/Model/cart_item.dart';
import 'package:hellofarmer/Model/produtos.dart';

class CartProvider with ChangeNotifier {
  
  final List<CartItem> _cartItens = [];
  List<CartItem> get items => _cartItens;
  int get itemCount => _cartItens.length;


  double get totalPrice {
    double total = 0.0;

    for(var i = 0; i < _cartItens.length;  i++){
      var item = _cartItens[i];
      total += item.totalPrice;
    }

    return total;
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
