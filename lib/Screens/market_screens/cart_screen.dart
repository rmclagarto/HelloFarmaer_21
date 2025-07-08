import 'package:flutter/material.dart';
import 'package:projeto_cm/Core/constants.dart';
import 'package:projeto_cm/Providers/cart_provider.dart';
import 'package:projeto_cm/Widgets/market_widgets/cart/cart_item_widget.dart';
import 'package:projeto_cm/Widgets/market_widgets/cart/cart_total_widget.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final cartItems = cartProvider.items;

    final subtotal = cartItems.fold<double>(
      0,
      (sum, item) => sum + item.unitPrice * item.quantity,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Meu Carrinho",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
              itemCount: cartItems.length,
              separatorBuilder: (context, index) => Divider(height: 1),

              itemBuilder: (context, index) {
                final item = cartItems[index];
                return CartItemWidget(
                  item: {
                    'name': item.product.title,
                    'price': item.product.price,
                    'quantity': item.quantity,
                    'image': item.product.image,
                    'inStock': true,
                  },
                  onQuantityChanged: (newQuantity) {
                    setState(() {
                      final dif = newQuantity - item.quantity;
                      if (dif > 0) {
                        cartProvider.incrementQuantity(index);
                      } else if (dif < 0) {
                        cartProvider.decrementQuantity(index);
                      }
                    });
                  },
                  onDelete: () {
                    setState(() {
                      cartProvider.removeProduct(index);
                    });
                  },
                );
              },
            ),
          ),
          CartTotalWidget(cartItems: cartItems, subtotal: subtotal),
        ],
      ),
    );
  }
}
