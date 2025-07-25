
import 'package:flutter/material.dart';
import 'package:hellofarmer/Core/cores.dart';
import 'package:hellofarmer/Model/produto.dart';


class PainelInferior extends StatelessWidget {
  final List<Produto> anuncios;
  final void Function(Produto ad)? aoTocarNoAnuncio;

  const PainelInferior({super.key, required this.anuncios, this.aoTocarNoAnuncio});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.1,
      minChildSize: 0.1,
      maxChildSize: 0.5,
      builder: (context, scrollController) {
        return LayoutBuilder(
          builder: (context, constraints) {
            final altura = constraints.maxHeight;
            final bool mostrarConteudo = altura > 120;

            return Container(
              decoration: _decoracao(),
              child: Column(
                children: [
                  _indicador(),
                  _conteudo(mostrarConteudo, scrollController),
                ],
              ),
            );
          },
        );
      },
    );
  }

  BoxDecoration _decoracao() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
    );
  }

  Widget _indicador() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        width: 40,
        height: 5,
        decoration: BoxDecoration(
          color: Colors.grey[400],
          borderRadius: BorderRadius.circular(2.5),
        ),
      ),
    );
  }

  Widget _conteudo(bool visible, ScrollController scrollController) {
    return Expanded(
      child: Opacity(
        opacity: visible ? 1.0 : 0.0,
        child: ListView.builder(
          controller: scrollController,
          itemCount: anuncios.length,
          itemBuilder: (context, index) {
            final ad = anuncios[index];
            return GestureDetector(
              onTap: () => aoTocarNoAnuncio?.call(ad),
              child: cartaoAnuncio(context, ad.nomeProduto),
            );
          },
        ),
      ),
    );
  }

  Widget cartaoAnuncio(BuildContext context, String adText) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Card(
        elevation: 3,
        color: PaletaCores.corPrimaria(context),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              const Icon(Icons.campaign, color: Colors.black),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  adText,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
