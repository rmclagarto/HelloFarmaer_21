import 'package:flutter/material.dart';
import 'package:hellofarmer/Core/constants.dart';
import 'package:hellofarmer/Core/image_assets.dart';
import 'package:hellofarmer/Model/produto.dart';
import 'package:hellofarmer/Providers/store_provider.dart';
import 'package:hellofarmer/Services/database_service.dart';
import 'package:provider/provider.dart';

class MyProductDetailScreen extends StatefulWidget {
  final Produto produto;

  const MyProductDetailScreen({super.key, required this.produto});

  @override
  State<MyProductDetailScreen> createState() => _MyProductDetailScreen();
}

class _MyProductDetailScreen extends State<MyProductDetailScreen> {
  late TextEditingController _precoController;
  late TextEditingController _stockController;

  @override
  void initState() {
    super.initState();
    _precoController = TextEditingController(
      text: widget.produto.preco.toString(),
    );
    _stockController = TextEditingController(
      text: widget.produto.quantidade.toString(),
    );
  }

  @override
  void dispose() {
    _precoController.dispose();
    _stockController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.produto.nomeProduto,
          style: theme.textTheme.headlineSmall?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: PaletaCores.corPrimaria,
        actions: [
          IconButton(
            onPressed: () => _confirmDelete(context),
            icon: const Icon(Icons.delete_forever, color: Colors.redAccent),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                Imagens.alface,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            
            const SizedBox(height: 16),
            
            Text(
              "${widget.produto.preco.toString()}€ / ${widget.produto.unidadeMedida}",
              style: TextStyle(fontSize: 18, color: PaletaCores.corSecundaria),
            ),
            
            const SizedBox(height: 4),
            
            Text(
              "Publicado em ${widget.produto.data.toString()}",
              style: const TextStyle(color: Colors.grey),
            ),
            
            const SizedBox(height: 20),
            
            const Text(
              'Descrição',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            
            const SizedBox(height: 6),
            
            Text(widget.produto.descricao, style: const TextStyle(height: 1.4)),
            
            const SizedBox(height: 24),
            
            const Text(
              'Estatísticas',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 12),

            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                
                _buildStatCard(
                  'Cliques',
                  widget.produto.cliques.toString(),
                  Icons.touch_app,
                ),
                
                _buildStatCard(
                  'Compras',
                  widget.produto.comprado.toString(),
                  Icons.shopping_cart,
                ),

              ],
            ),
            
            const SizedBox(height: 24),
            
            const Text(
              'Gestão de Produto',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 12),

            TextField(
              controller: _precoController,
              decoration: InputDecoration(
                labelText: 'Preço (€)',
                prefixIcon: const Icon(Icons.euro),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),

            const SizedBox(height: 12),

            TextField(
              controller: _stockController,
              decoration: InputDecoration(
                labelText: 'Stock Disponível',
                prefixIcon: const Icon(Icons.inventory),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              keyboardType: TextInputType.number,
            ),

            const SizedBox(height: 20),
       
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.save, color: Colors.white),
                label: const Text(
                  'Guardar Alterações',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: PaletaCores.corPrimaria,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  textStyle: const TextStyle(fontSize: 16),
                ),
                onPressed: () {
                  final updatedProduct = widget.produto.copyWith(
                    preco: double.parse(_precoController.text),
                    quantidade: int.tryParse(_stockController.text) ?? 0,
                  );

                  Navigator.pop(
                    context,
                    updatedProduct,
                  ); 

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Alterações guardadas!')),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.trending_up),
                label: const Text('Promover Produto'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: PaletaCores.corPrimaria,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  side: BorderSide(color: PaletaCores.corPrimaria, width: 2),
                ),
                onPressed: () => _showPromotionSheet(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Icon(icon, color: PaletaCores.corPrimaria),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  title,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }



  Widget _buildPlanTile({required String title,required String subtitle, required IconData icon, required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: PaletaCores.corPrimaria),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.radio_button_off),
      onTap: onTap,
    );
  }


  void _promoverProduto(int dias, double valor) async {
    final storeProvider = Provider.of<StoreProvider>(context, listen: false);
    final BancoDadosServico _dbService = BancoDadosServico();


    try{
      final storeId = await storeProvider.findStoreIdForProduct(widget.produto.idProduto);
      if(storeId == null){
        throw Exception("Loja não encontrada para este produto");
      }

      final snapshot = await _dbService.read(path: 'stores/$storeId/despesas');
      final double despesasAtuais;

      if (snapshot?.value == null) {
        despesasAtuais = 0.0;
      } else if (snapshot!.value is int) {
        despesasAtuais = (snapshot.value as int).toDouble();
      } else if (snapshot.value is double) {
        despesasAtuais = snapshot.value as double;
      } else if (snapshot.value is String) {
        despesasAtuais = double.parse(snapshot.value as String);
      } else {
        despesasAtuais = 0.0;
      }

      await _dbService.update(
        path: 'stores/$storeId',
        data: {'despesas': (despesasAtuais + valor)}
      );

      final atualizado = widget.produto.copyWith(
        promovido: true,
        diasPromovido: dias,
      );


      await storeProvider.updateProduct(atualizado);

      if(!mounted) return;

      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Produto promovido com sucesso!')),
      );

    }catch(e){
      if(!mounted) return;
    
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao promover produto: ${e.toString()}')),
      );
    }
  }

  void _showPromotionSheet(BuildContext context){
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Wrap(
            runSpacing: 16,
            children: [
              Text(
                'Escolha um Plano de Promoção',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              _buildPlanTile(
                title:'Plano Básico', 
                subtitle:'3 dias - 2.99€', 
                icon: Icons.bolt,
                onTap: () => _promoverProduto(3, 2.99)
              ),

              _buildPlanTile(
                title: 'Plano Plus', 
                subtitle: '7 dias - 5.99€',
                icon:  Icons.star,
                onTap: () => _promoverProduto(7, 5.99)
              ),

              _buildPlanTile(
                title: 'Plano Premium',
                subtitle: '15 dias - 9.99€',
                icon: Icons.workspace_premium,
                onTap: () => _promoverProduto(15, 9.99),
              ),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.check_circle_outline, color: Colors.white,),
                  label:  Text('Confirmar e Pagar', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: PaletaCores.corPrimaria,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Produto promovido com sucesso!'),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _confirmDelete(BuildContext context) {
    final storeProvider = Provider.of<StoreProvider>(context, listen: false);

    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Confirmar eliminação'),
            content: const Text(
              'Tem certeza de que deseja eliminar este produto?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () async {
                  
                  Navigator.pop(context);

                  
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder:
                        (context) =>
                            const Center(child: CircularProgressIndicator()),
                  );

                  try {
                    final storeId = await storeProvider.findStoreIdForProduct(
                      widget.produto.idProduto,
                    );

                    if (storeId == null) {
                      if (mounted) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Não foi possível encontrar a loja do produto",
                            ),
                          ),
                        );
                      }
                      return;
                    }

                    
                    await storeProvider.deleteProduct(
                      storeId: storeId,
                      productId: widget.produto.idProduto,
                    );

                    
                    if (mounted) {
                      Navigator.pop(context);
                      Navigator.pop(
                        context,
                        true,
                      ); 
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Produto eliminado com sucesso!"),
                        ),
                      );
                    }
                  } catch (e) {
                    if (mounted) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "Erro ao excluir produto: ${e.toString()}",
                          ),
                        ),
                      );
                    }
                  }
                },
                child: const Text(
                  'Eliminar',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );
  }
}
