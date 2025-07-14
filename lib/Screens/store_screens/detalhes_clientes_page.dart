
// import 'package:flutter/material.dart';
// import 'package:hellofarmer/Core/constants.dart';
// import 'package:hellofarmer/Model/custom_user.dart';


// class DetalhesClientePage extends StatelessWidget {
//   final CustomUser cliente;

//   const DetalhesClientePage({super.key, required this.cliente});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(cliente.nomeUser),
//         backgroundColor: Constants.primaryColor,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [

//               Text(
//                 'Email: ${cliente.email}', 
//                 style: const TextStyle(fontSize: 16),
//               ),

//               const SizedBox(height: 12),

//               Text(
//                 'Grupo: ${cliente.grupo}',
//                 style: const TextStyle(
//                   fontWeight: FontWeight.bold, 
//                   fontSize: 16,
//                 ),
//               ),

//               const Divider(height: 30),

//               const Text(
//                 'Histórico de Compras:', 
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold, 
//                   fontSize: 18,
//                 ),
//               ),

//               if (cliente.historicoCompras!.isEmpty)
//                 const Padding(
//                   padding: EdgeInsets.only(top: 8.0),
//                   child: Text('Nenhuma compra registrada.', style: TextStyle(fontStyle: FontStyle.italic)),
//                 ),
//               ...cliente.historicoCompras.map(
//                 (compra) => Padding(
//                   padding: const EdgeInsets.only(top: 6),
//                   child: Text('• $compra', style: const TextStyle(fontSize: 16)),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
