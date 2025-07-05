import 'package:flutter/material.dart';
import 'package:projeto_cm/Core/constants.dart';
import 'package:projeto_cm/Widgets/market_widgets/cart/cart_item_widget.dart';
import 'package:projeto_cm/Widgets/market_widgets/cart/cart_total_widget.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {

  List<Map<String, dynamic>> cartItems = [
    {
      'name': 'Xbox series X',
      'description': '1 TB',
      'price': 570.00,
      'image': 'assets/img/fruta.jpg',
      'quantity': 1,
      'inStock': true,
    },
    {
      'name': 'Wireless Controller',
      'description': 'Blue',
      'price': 77.00,
      'image': 'assets/img/fruta.jpg',
      'quantity': 1,
      'inStock': true,
    },
    {
      'name': 'Razer Kaira Pro',
      'description': 'Green',
      'price': 153.00,
      'image': 'assets/img/fruta.jpg',
      'quantity': 1,
      'inStock': false,
    },
  ];


  double get subtotal {
    double sum = 0;
    for(var item in cartItems){
      if(item['inStock'] == true){
        sum += item['price'] * item['quantity'];
      }
    }
    return sum;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Meu Carrinho",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Constants.primaryColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
              itemCount:cartItems.length,
              separatorBuilder: (context, index) => Divider(height: 1,),

              itemBuilder: (context, index) {
                return CartItemWidget(
                  item: cartItems[index],
                  onQuantityChanged: (newQuantity){
                    setState((){
                      cartItems[index]['quantity'] = newQuantity;
                    });
                  },
                  onDelete:() {
                    setState((){
                      cartItems.removeAt(index);
                    });
                  },
                );
              }, 
            ),
          ),
          CartTotalWidget(cartItems: cartItems,subtotal: subtotal),
        ],
      ),
    );
  }
}