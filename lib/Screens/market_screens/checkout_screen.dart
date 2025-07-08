import 'dart:math';

import 'package:flutter/material.dart';
import 'package:projeto_cm/Core/constants.dart';
import 'package:projeto_cm/Model/cart.dart';
import 'package:projeto_cm/Services/notification_service.dart';

class CheckoutScreen extends StatefulWidget {
  final List<CartItem> cartItems;
  final double subtotal;

  const CheckoutScreen({
    super.key,
    required this.cartItems,
    required this.subtotal,
  });

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final TextEditingController _couponController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  double discount = 0.0;
  String? appliedCoupon;
  String deliveryMethod = 'pickup'; // 'pickup' ou 'delivery'
  bool hasAvailableItems = false;


  @override
  void initState() {
    super.initState();
    _checkAvailableItems();
    initNotifications();
  }

  void _checkAvailableItems() {
    for(var i = 0; i < widget.cartItems.length; i++){
      if(widget.cartItems[i].inStock == true){
        hasAvailableItems = true;
        return;
      }
    }
    hasAvailableItems = false;
  }

  void _applyCoupon() {
    final code = _couponController.text.trim();

    if (code.toUpperCase() == 'PROMO10') {
      setState(() {
        discount = widget.subtotal * 0.1;
        appliedCoupon = code;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cupom aplicado com sucesso!')),
      );
    } else {
      setState(() {
        discount = 0.0;
        appliedCoupon = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cupom inválido.')),
      );
    }
  }
  
  double get total {
    return widget.subtotal - discount;
  }

  int gerarCodigoPedido(){
    return Random().nextInt(100);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Finalizar Pedido', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Constants.primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildOrderSummary(),
              const SizedBox(height: 20),
              _buildCouponField(),
              const SizedBox(height: 20),
              _buildDeliveryMethodSelector(),
              if (deliveryMethod == 'delivery') ...[
                const SizedBox(height: 16),
                _buildAddressField(),
              ],
              const SizedBox(height: 20),
              _buildTotalSection(),
              const SizedBox(height: 20),
              _buildFinishButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrderSummary() {

    List<Widget> widgets = [];
    
    widgets.add(
      Text(
        'Resumo do Pedido', 
        style: TextStyle(
          fontSize: 18, 
          fontWeight: FontWeight.bold,
        ),
      ),
    );
    widgets.add(SizedBox(height: 10));
    
    
    for (var i = 0; i < widget.cartItems.length; i++) {
      for (var item in widget.cartItems) {
      if (!item.inStock) continue;

      widgets.add(ListTile(
        title: Text(item.product.title),
        subtitle: Text('Qtd: ${item.quantity}'),
        trailing: Text('${(double.parse(item.product.price) * item.quantity).toStringAsFixed(2)} €'),
      ));
    }

    }
    
    // if (outOfStockCount > 0) {
    //   widgets.insert(2, Padding(
    //     padding: EdgeInsets.only(bottom: 8),
    //     child: Text(
    //       '$outOfStockCount item(s) esgotado(s) removido(s) do pedido',
    //       style: TextStyle(color: Colors.red),
    //     ),
    //   ));
    // }
    
    widgets.add(Divider(height: 32));
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widgets,
    );
  }

  Widget _buildCouponField() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _couponController,
            decoration: const InputDecoration(
              labelText: 'Código de Promocional',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        const SizedBox(width: 10),
        ElevatedButton(
          onPressed: _applyCoupon,
          style: ElevatedButton.styleFrom(backgroundColor: Constants.primaryColor),
          child: Text(
            'Aplicar',
            style: TextStyle(
              color: Colors.white,
            ),
            
          ),
        ),
      ],
    );
  }

  Widget _buildDeliveryMethodSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Método de Entrega', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ListTile(
          title: const Text('Retirar na loja'),
          leading: Radio<String>(
            value: 'pickup',
            groupValue: deliveryMethod,
            onChanged: (value) {
              setState(() {
                deliveryMethod = value!;
              });
            },
          ),
        ),
        ListTile(
          title: const Text('Entrega em domicílio'),
          leading: Radio<String>(
            value: 'delivery',
            groupValue: deliveryMethod,
            onChanged: (value) {
              setState(() {
                deliveryMethod = value!;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAddressField() {
    return TextField(
      controller: _addressController,
      decoration: const InputDecoration(
        labelText: 'Endereço para entrega',
        border: OutlineInputBorder(),
        hintText: 'Digite seu endereço completo',
      ),
      maxLines: 2,
    );
  }

  Widget _buildTotalSection() {
    return Column(
      children: [
        _buildRow('Subtotal:', widget.subtotal),
        _buildRow('Desconto:', -discount, isDiscount: true),
        const Divider(height: 20),
        _buildRow('Total:', total, isTotal: true),
      ],
    );
  }

  Widget _buildRow(String label, double value, {bool isDiscount = false, bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? Colors.black : Colors.grey[700],
            ),
          ),
          Text(
            '${value.toStringAsFixed(2)} €',
            style: TextStyle(
              fontSize: isTotal ? 18 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isDiscount
                  ? Colors.red
                  : (isTotal ? Constants.primaryColor : Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFinishButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Constants.primaryColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onPressed: () async {
          if (deliveryMethod == 'delivery' && _addressController.text.trim().isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Por favor, informe o endereço para entrega.')),
            );
            return;
          }
          final codigoPedido = gerarCodigoPedido();
          await mostrarNotificacao(codigoPedido.toString(), context);


          // Aqui você pode enviar o pedido para o backend ou navegar para uma tela de sucesso
          // ScaffoldMessenger.of(context).showSnackBar(
          //   const SnackBar(content: Text('Pedido finalizado com sucesso!')),
          // );
        },
        child: const Text(
          'Finalizar Pedido',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }
}