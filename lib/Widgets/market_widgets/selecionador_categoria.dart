
import 'package:flutter/material.dart';
import 'package:hellofarmer/Core/cores.dart';


class SeletorCategoria extends StatelessWidget {
  final List<String> categorias;
  final int indiceSelecionado;
  final ValueChanged<int> aoSelecionar;

  const SeletorCategoria({
    super.key,
    required this.categorias,
    required this.indiceSelecionado,
    required this.aoSelecionar,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(categorias.length, (indice) {
            final bool selecionado = indiceSelecionado == indice;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Text(
                  categorias[indice],
                  style: TextStyle(
                    color: selecionado ? Colors.white : Colors.black87,
                  ),
                ),
                selected: selecionado,
                selectedColor: PaletaCores.corPrimaria(context),
                backgroundColor: Colors.white,
                onSelected: (selected) {
                  if (selected) {
                    aoSelecionar(indice);
                  }
                },
              ),
            );
          }),
        ),
      ),
    );
  }
}
