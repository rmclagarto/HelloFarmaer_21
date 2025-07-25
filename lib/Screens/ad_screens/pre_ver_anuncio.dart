
import 'package:flutter/material.dart';
import 'package:hellofarmer/Core/cores.dart';
import 'package:hellofarmer/Core/imagens.dart';
import 'package:hellofarmer/Widgets/ad_widgets/add_to_cart_button.dart';
import 'package:hellofarmer/Widgets/ad_widgets/delivery_option.dart';
import 'package:hellofarmer/Widgets/ad_widgets/description_section.dart';
import 'package:hellofarmer/Widgets/ad_widgets/price_quantity_low.dart';
import 'package:hellofarmer/Widgets/ad_widgets/product_header.dart';
import 'package:hellofarmer/Widgets/ad_widgets/product_image.dart';
import 'package:hellofarmer/Widgets/home_widgets/seller_info.dart';




class PreviewAd extends StatelessWidget {
  final String nome;
  final String descricao;
  final String localizacao;
  final String telefone;
  final double quantidade;
  final double preco;

  const PreviewAd({
    super.key,
    required this.nome,
    required this.descricao,
    required this.localizacao,
    required this.telefone,
    required this.quantidade,
    required this.preco,
  });

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: PaletaCores.corPrimaria(context),
        title: const Text('HelloFarmer'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ProductHeader(productName: nome),
            const SizedBox(height: 16),

            ProductImage(imagePath: Imagens.alface),

            const SizedBox(height: 16),

            PriceQuantityRow(
              quantity: quantidade.toInt(), 
              unit: '8 Litros', 
              pricePerUnit: preco
            ),
            const SizedBox(height: 24),

            DescriptionSection(
              description:
                  // 'Balde de zinco com capacidade de 8 litros. Resistente, '
                  // 'durável e ideal para uso doméstico em ambientes rurais ou '
                  // 'coletivos. Fabricado em zinco de alta qualidade.',
                  descricao,
            ),
            const SizedBox(height: 24),

            const Text(
              'Opções de Entrega',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            DeliveryOption(onTap: () => debugPrint('Entrega selecionada')),
            const SizedBox(height: 24),

            const Text(
              'Dados do Vendedor',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            SellerInfo(
              sellerName: 'Artindo Feliz',
              rating: '4.8 ★ (120)',
              onTap: () {
                // Add what should happen when the seller info is tapped
                debugPrint('Seller info tapped');
              },
              address: localizacao,
              phone: telefone,
            ),

            const SizedBox(height: 32),

            // ... resto do código permanece igual ...
            AddToCartButton(
              onPressed: () {
                // Add what should happen when the button is pressed
                debugPrint('Add to cart button pressed');
                // Typically you would add logic to add the item to cart here
              },
            ),
          ],
        ),
      ),
    );
  }
}
