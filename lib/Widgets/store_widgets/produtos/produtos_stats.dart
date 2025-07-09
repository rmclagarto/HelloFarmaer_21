
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:hellofarmer/Core/constants.dart';
import 'package:hellofarmer/Model/produtos.dart';



class ProdutosStats extends StatelessWidget {
  final Produtos produto;

  ProdutosStats({super.key, required this.produto});

  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final stats = produto.stats;
    final history = List<int>.from(stats['history']);
    final taxaConversao = stats['clicks'] == 0
        ? 0.0
        : (stats['conversions'] / stats['clicks']) * 100;

    _priceController.text = produto.price;
    _stockController.text = stats['stock']?.toString() ?? '0';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          produto.title,
          style: theme.textTheme.headlineSmall?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Constants.primaryColor,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.delete_forever,
              color: Colors.redAccent,

            ),
            onPressed: () => _confirmDelete(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagem
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                produto.image,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),
            // Info Principal
            Text(produto.title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text(produto.price, style: TextStyle(fontSize: 18, color: Constants.secondaryColor)),
            const SizedBox(height: 4),
            Text(produto.date, style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 20),
            // Descrição
            const Text('Descrição', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            Text(produto.description, style: const TextStyle(height: 1.4)),
            const SizedBox(height: 24),
            // Estatísticas em Cards
            const Text('Estatísticas', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _buildStatCard('Visualizações', stats['views'].toString(), Icons.remove_red_eye),
                _buildStatCard('Cliques', stats['clicks'].toString(), Icons.touch_app),
                _buildStatCard('Conversões', stats['conversions'].toString(), Icons.shopping_cart),
                _buildStatCard('Conversão', '${taxaConversao.toStringAsFixed(1)}%', Icons.percent),
              ],
            ),
            const SizedBox(height: 24),
            // Gráfico
            const Text('Histórico de Interações', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            SizedBox(
              height: 240,
              child: LineChart(
                LineChartData(
                  lineTouchData: LineTouchData(
                    handleBuiltInTouches: true,
                    touchTooltipData: LineTouchTooltipData(
                      tooltipBgColor: Colors.black87,
                      getTooltipItems: (touchedSpots) {
                        return touchedSpots.map((spot) {
                          return LineTooltipItem(
                            'Dia ${spot.x.toInt() + 1}\n${spot.y.toInt()} interações',
                            const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          );
                        }).toList();
                      },
                    ),
                  ),
                  gridData: FlGridData(show: true, drawVerticalLine: false),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, _) =>
                            Text('${value.toInt()}', style: const TextStyle(fontSize: 10)),
                        reservedSize: 30,
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, _) =>
                            Text('Dia ${value.toInt() + 1}', style: const TextStyle(fontSize: 10)),
                        reservedSize: 32,
                      ),
                    ),
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: true, border: Border.all(color: Colors.grey.shade300)),
                  minX: 0,
                  maxX: (history.length - 1).toDouble(),
                  minY: 0,
                  maxY: (history.reduce((a, b) => a > b ? a : b) + 10).toDouble(),
                  lineBarsData: [
                    LineChartBarData(
                      spots: history
                          .asMap()
                          .entries
                          .map((e) => FlSpot(e.key.toDouble(), e.value.toDouble()))
                          .toList(),
                      isCurved: true,
                      barWidth: 3,
                      dotData: FlDotData(show: true),
                      gradient: LinearGradient(
                        colors: [Constants.primaryColor, Constants.primaryColor],
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          colors: [
                            Constants.primaryColor,
                            Colors.transparent,
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),

            const Text('Gestão de Produto', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),

            // Preço
            TextField(
              controller: _priceController,
              decoration: InputDecoration(
                labelText: 'Preço (€)',
                prefixIcon: const Icon(Icons.euro),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),

            const SizedBox(height: 12),

            // Stock
            TextField(
              controller: _stockController,
              decoration: InputDecoration(
                labelText: 'Stock Disponível',
                prefixIcon: const Icon(Icons.inventory),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
              keyboardType: TextInputType.number,
            ),

            const SizedBox(height: 20),

            // Botões
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: const Text('Guardar Alterações'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Constants.primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  textStyle: const TextStyle(fontSize: 16),
                ),
                onPressed: () {
                  

                  produto.price = _priceController.text;
                  produto.stats['stock'] = int.tryParse(_stockController.text) ?? 0;

                  Navigator.pop(context, produto); // Retorna o produto modificado
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
                  foregroundColor: Constants.primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  side: BorderSide(color: Constants.primaryColor, width: 2),
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
          Icon(icon, color: Constants.primaryColor),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildPlanTile(String title, String subtitle, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: Constants.primaryColor),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.radio_button_off),
      onTap: () {},
    );
  }

  void _showPromotionSheet(BuildContext context) {
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
              const Text('Escolha um Plano de Promoção',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              _buildPlanTile('Plano Básico', '3 dias - 2.99€', Icons.bolt),
              _buildPlanTile('Plano Plus', '7 dias - 5.99€', Icons.star),
              _buildPlanTile('Plano Premium', '15 dias - 9.99€', Icons.workspace_premium),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.check_circle_outline),
                  label: const Text('Confirmar e Pagar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Constants.primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Produto promovido com sucesso!')),
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
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirmar eliminação'),
        content: const Text('Tem certeza de que deseja eliminar este produto?'),
        actions: [
          TextButton(
            onPressed: () { 
              Navigator.pop(context);
              Navigator.pop(context, true); // Fecha o diálogo e a tela atual
            },
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Aqui você pode integrar com o backend para apagar o produto
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Produto eliminado com sucesso!')),
              );
            },
            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}






  

