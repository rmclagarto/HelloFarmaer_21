
// import 'package:flutter/material.dart';
// import 'package:hellofarmer/Core/constants.dart';
// import 'package:hellofarmer/Widgets/store_widgets/forms/create_produto_form.dart';


// class PublicarProdutoScreen extends StatelessWidget {
//   final _formKey = GlobalKey<FormState>();

//   PublicarProdutoScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Novo Produto',
//           style: theme.textTheme.headlineSmall?.copyWith(
//             color: Colors.white,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         elevation: 0,
//         centerTitle: true,
//         iconTheme: const IconThemeData(color: Colors.white),
//         backgroundColor: Constants.primaryColor, // Cor conforme seu layout
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: ProdutoForm(formKey: _formKey),
//         ),
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:hellofarmer/Core/constants.dart';
import 'package:hellofarmer/Widgets/store_widgets/forms/create_produto_form.dart';

class PublicarProdutoScreen extends StatefulWidget {
  final String storeId;
  const PublicarProdutoScreen({super.key, required this.storeId});

  @override
  State<PublicarProdutoScreen> createState() => _PublicarProdutoScreenState();
}

class _PublicarProdutoScreenState extends State<PublicarProdutoScreen> {
  final _formKey = GlobalKey<FormState>();

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
        backgroundColor: PaletaCores.corPrimaria,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ProdutoForm(
            formKey: _formKey,
            storeId: widget.storeId,
          ),
        ),
      ),
    );
  }
}