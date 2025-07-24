import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hellofarmer/Core/constants.dart';
import 'package:hellofarmer/Model/cart_item.dart';
import 'package:hellofarmer/Model/user.dart';
import 'package:hellofarmer/Model/encomenda.dart';
import 'package:hellofarmer/Providers/user_provider.dart';
import 'package:hellofarmer/Services/database_service.dart';
import 'package:hellofarmer/Services/notification_service.dart';
import 'package:provider/provider.dart';

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
  final TextEditingController _addressController = TextEditingController();
  double discount = 0.0;
  String deliveryMethod = 'pickup'; // 'pickup' ou 'delivery'
  bool hasAvailableItems = false;
  final BancoDadosServico _dbService = BancoDadosServico();



  @override
  void initState() {
    super.initState();
    _checkAvailableItems();
    initNotifications();
  }

  void _checkAvailableItems() {

    for (var i = 0; i < widget.cartItems.length; i++) {
      if (widget.cartItems[i].inStock == true) {
        hasAvailableItems = true;
        return;
      }
    }
    hasAvailableItems = false;
  }

  double get total {
    return widget.subtotal;
  }

  int gerarCodigoPedido() {
    return Random().nextInt(100);
  }

  Future<void> criarEncomenda(int codigo) async {
    final user = Provider.of<UserProvider>(context, listen: false).user;
    String compradorId = user!.idUtilizador;

    for (var cartItem in widget.cartItems) {
      final novaEncomendaRef = _dbService.database.ref().child('orders').push();
      final novaEncomendaId = novaEncomendaRef.key!;

      final produto = cartItem.product;
      final vendedorId = produto.idLoja;

      final encomenda = Encomenda(
        idEncomenda: novaEncomendaId,
        compradorId: compradorId,
        vendedorId: vendedorId,
        dataPedido: DateTime.now(),
        code: codigo,
        valor: (cartItem.quantity * produto.preco),
        compradorInfo: {
          "nome": user.nomeUtilizador,
          "email": user.email,
          "telemovel": user.telefone,
        },
        quantidade: cartItem.quantity,
        produtosInfo: [
          {
            'id': cartItem.product.idProduto,
            'nome': cartItem.product.nomeProduto,
            'quantidade': cartItem.quantity,
          },
        ],
      );

      await _dbService.update(
        path: "orders/$novaEncomendaId",
        data: encomenda.toJson(),
      );

      final lojaSnapshot = await _dbService.read(
        path: "stores/$vendedorId/listEncomendasId",
      );

      List<dynamic> listaLoja = [];
      if (lojaSnapshot != null && lojaSnapshot.value is List) {
        listaLoja = List<dynamic>.from(lojaSnapshot.value as List);
      }
      if (!listaLoja.contains(novaEncomendaId)) {
        listaLoja.add(novaEncomendaId);
        await _dbService.update(
          path: "stores/$vendedorId/listEncomendasId",
          data: listaLoja,
        );
      }

      // 5. Atualizar lista de encomendas do usuário
      final userSnapshot = await _dbService.read(
        path: "users/$compradorId/listEncomendasId",
      );

      List<dynamic> listaUser = [];
      if (userSnapshot != null && userSnapshot.value is List) {
        listaUser = List<dynamic>.from(userSnapshot.value as List);
      }
      if (!listaUser.contains(novaEncomendaId)) {
        listaUser.add(novaEncomendaId);
        await _dbService.update(
          path: "users/$compradorId/listEncomendasId",
          data: listaUser,
        );
      }

      // Remover o produto específico do carrinho do utilizador
      final cartSnapshot = await _dbService.read(
        path: "users/$compradorId/cartProductsList",
      );

      if (cartSnapshot != null && cartSnapshot.value is List) {
        List<dynamic> cartList = List<dynamic>.from(cartSnapshot.value as List);
        cartList.remove(cartItem.product.idProduto);
        await _dbService.update(
          path: "users/$compradorId/cartProductsList",
          data: cartList,
        );
      }



      await _atualizarEstoqueProduto(produto.idProduto, cartItem.quantity);
      await _atualizarFaturamentoLoja(vendedorId, (cartItem.quantity * produto.preco));
      await _atualizarQuantidadeComprada(produto.idProduto);
      // await _removerProdutoDoCarrinho(compradorId, produto.idProduto);
      await _registrarClienteNaLoja(vendedorId, user);
    }
  }

  Future<void> _atualizarEstoqueProduto(String produtoId, int quantidadeComprada) async{
    final snapshot = await _dbService.read(path: "products/$produtoId");
    if(snapshot != null && snapshot.value is Map){
      final data = Map<String, dynamic>.from(snapshot.value as Map);
      int estoqueAtual = data['quantidade'] ?? 0;
      int novoEstoque = (estoqueAtual - quantidadeComprada);

      await _dbService.update(
        path: "products/$produtoId", 
        data: {'quantidade': novoEstoque}
      );
    }
  }

  Future<void> _atualizarFaturamentoLoja(String lojaId, double valor) async{
    final snapshot = await _dbService.read(path: 'stores/$lojaId/faturamento');
    double atual = 0;

    if(snapshot != null && snapshot.value != null){
      atual = double.tryParse(snapshot.value.toString()) ?? 0;
    }


    await _dbService.update(
      path: 'stores/$lojaId', 
      data: {'faturamento': atual + valor,
      }
    );
  }


  Future<void> _atualizarQuantidadeComprada(String produtoId) async {
    final snapshot = await _dbService.read(path: 'products/$produtoId');
    if(snapshot != null && snapshot.value is Map){
      final data = Map<String, dynamic>.from(snapshot.value as Map);
      int quantidadeComprada = data['comprado'] ?? 0;

      await _dbService.update(
        path: 'products/$produtoId', 
        data: {'comprado': (quantidadeComprada + 1)}
      );
    }
  }

  Future<void> _registrarClienteNaLoja(String vendedorId, Utilizador user) async{
    final snapshot = await _dbService.read(path: "stores/$vendedorId/clientes");
    List<dynamic> clientes = [];

    if(snapshot != null  && snapshot.value is List){
      clientes = List<dynamic>.from(snapshot.value as List);
    }

    final clienteJaExiste = clientes.any((cliente) =>
      cliente is Map && cliente['id'] == user.idUtilizador
    );

    if(!clienteJaExiste){
      final novoCliente = {
        "id": user.idUtilizador,
        "nome": user.nomeUtilizador,
        "email": user.email,
      };

      clientes.add(novoCliente);

      await _dbService.update(
        path: "stores/$vendedorId",
        data: {"clientes": clientes},
      );

      clientes.clear();
    }   
  }
  
  // Future<void> _removerProdutoDoCarrinho(String compradorId, String produtoId) async {

  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Finalizar Pedido',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: PaletaCores.corPrimaria,
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
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
    widgets.add(SizedBox(height: 10));

    for (var item in widget.cartItems) {
      if (!item.inStock) continue;

      widgets.add(
        ListTile(
          title: Text(item.product.nomeProduto),
          subtitle: Text('Qtd: ${item.quantity}'),
          trailing: Text(
            '${(item.product.preco * item.quantity).toStringAsFixed(2)} €',
          ),
        ),
      );
    }

    widgets.add(Divider(height: 32));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widgets,
    );
  }

  Widget _buildDeliveryMethodSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Método de Entrega',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
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
        const Divider(height: 20),
        _buildRow('Total:', total, isTotal: true),
      ],
    );
  }

  Widget _buildRow(
    String label,
    double value, {
    bool isDiscount = false,
    bool isTotal = false,
  }) {
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
              color:
                  isDiscount
                      ? Colors.red
                      : (isTotal ? PaletaCores.corPrimaria : Colors.black),
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
          backgroundColor: PaletaCores.corPrimaria,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: () async {
          if (deliveryMethod == 'delivery' &&
              _addressController.text.trim().isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Por favor, informe o endereço para entrega.'),
              ),
            );
            return;
          }
          final codigoPedido = gerarCodigoPedido();
          criarEncomenda(codigoPedido);

          await mostrarNotificacao(codigoPedido.toString(), context);

          widget.cartItems.clear();

          Navigator.pop(context);
        },
        child: const Text(
          'Finalizar Pedido',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
