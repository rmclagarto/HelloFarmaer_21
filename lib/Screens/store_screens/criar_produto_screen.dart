import 'package:flutter/material.dart';
import 'package:projeto_cm/Core/constants.dart';
import 'package:projeto_cm/Widgets/store_widgets/forms/create_produto_form.dart';

class PublicarProdutoScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  PublicarProdutoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Novo Produto',
          style: theme.textTheme.headlineSmall?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Constants.primaryColor, // Cor conforme seu layout
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ProdutoForm(formKey: _formKey),
        ),
      ),
    );
  }
}
