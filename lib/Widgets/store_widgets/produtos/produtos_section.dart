
import 'package:flutter/material.dart';
import 'package:hellofarmer/Core/constants.dart';
import 'package:hellofarmer/Model/produtos.dart';
import 'package:hellofarmer/Screens/store_screens/criar_produto_screen.dart';
import 'package:hellofarmer/Widgets/store_widgets/produtos/produto_card.dart';
import 'package:hellofarmer/Widgets/store_widgets/produtos/search_bar.dart';



class ProdutosSection extends StatefulWidget {
  const ProdutosSection({super.key});

  @override
  State<ProdutosSection> createState() => _ProdutosSectionState();
}

class _ProdutosSectionState extends State<ProdutosSection> {
  late List<Produtos> ads;

  @override
  void initState() {
    super.initState();
    ads = Produtos.sampleAds();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Gestão de Produtos',
          style: theme.textTheme.headlineSmall?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
        backgroundColor: Constants.primaryColor,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SearchBarWidget(),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: ads.length,
                itemBuilder: (context, index) {
                  return ProdutoCard(
                    produto: ads[index],
                    onDelete: () {
                      setState(() {
                        ads.removeAt(index);
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Produto eliminado com sucesso!'),
                        ),
                      );
                    },
                    onUpdate: (Produtos produtoAtualizado) {
                      setState(() {
                        ads[index] = produtoAtualizado;
                      });
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final novoProduto = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PublicarProdutoScreen()),
          );

          if (novoProduto != null) {
            setState(() {
              ads.add(novoProduto);
            });
          }
        },
        backgroundColor: Constants.primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
