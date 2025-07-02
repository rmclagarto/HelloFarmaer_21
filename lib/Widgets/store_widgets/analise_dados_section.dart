import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:path_provider/path_provider.dart';
import 'package:projeto_cm/Core/constants.dart';
import 'package:projeto_cm/Services/finance_report_service.dart';
import 'package:share_plus/share_plus.dart';

class AnalisesFinanceirasSection extends StatefulWidget {
  const AnalisesFinanceirasSection({super.key});

  @override
  State<AnalisesFinanceirasSection> createState() =>
      _AnalisesFinanceirasSectionState();
}

class _AnalisesFinanceirasSectionState extends State<AnalisesFinanceirasSection>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Dados simulados
  final double despesas = 10000;
  final double lucro = 15000;

  final Map<String, double> canaisDeVendas = {
    'Loja Física': 12000,
    'Online': 8000,
    'Marketplace': 5000,
  };

  // Faturamento mensal simulado para gráfico de linha
  final Map<String, double> faturamentoMensal = {
    'Jan': 18000,
    'Fev': 20000,
    'Mar': 21000,
    'Abr': 25000,
    'Mai': 23000,
    'Jun': 26000,
    'Jul': 27000,
    'Ago': 30000,
    'Set': 28000,
    'Out': 32000,
    'Nov': 35000,
    'Dez': 40000,
  };

  final List<String> conversasRelatorio = [
    "Cliente A: Pedido confirmado e entregue.",
    "Cliente B: Pedido cancelado.",
    "Cliente C: Solicitação de troca atendida.",
  ];

  double get faturamentoTotal =>
      faturamentoMensal.values.reduce((a, b) => a + b);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  //   import 'package:file_picker/file_picker.dart';
  // import 'package:share_plus/share_plus.dart';
  // import 'package:path_provider/path_provider.dart';
  // import 'dart:io';

  Future<void> _salvarOuCompartilharRelatorio() async {
    final service = FinanceReportService(
      faturamentoTotal: faturamentoTotal,
      despesas: despesas,
      lucro: lucro,
      faturamentoMensal: faturamentoMensal,
      canaisDeVendas: canaisDeVendas,
    );

    try {
      // 1. Gerar PDF
      final pdfBytes = await service.generatePDF();

      // 2. Mostrar opções ao usuário
      final action = await _mostrarDialogoOpcoes(context);

      if (action == 'salvar') {
        await _salvarEmLocalEscolhido(pdfBytes);
      } else if (action == 'compartilhar') {
        await _compartilharRelatorio(pdfBytes);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erro: ${e.toString()}')));
      }
    }
  }

  Future<String?> _mostrarDialogoOpcoes(BuildContext context) async {
    return await showDialog<String>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Escolha uma ação'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, 'salvar'),
                child: const Text('Salvar em dispositivo'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, 'compartilhar'),
                child: const Text('Compartilhar'),
              ),
            ],
          ),
    );
  }

  Future<void> _salvarEmLocalEscolhido(Uint8List pdfBytes) async {
    // Permitir que o usuário escolha o local
    final String? directoryPath = await FilePicker.platform.getDirectoryPath();

    if (directoryPath != null) {
      final file = File('$directoryPath/relatorio_financeiro_hellofarmer.pdf');
      await file.writeAsBytes(pdfBytes);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Relatório salvo com sucesso!')),
        );
      }
    }
  }

  Future<void> _compartilharRelatorio(Uint8List pdfBytes) async {
    try {
      // 1. Criar arquivo temporário
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/relatorio_financeiro_hellofarmer.pdf');
      await file.writeAsBytes(pdfBytes);

      // 2. Compartilhar usando o método CORRETO (shareXFiles)
      await Share.shareXFiles(
        [XFile(file.path)], // Note o uso de XFile
        text: 'Relatório Financeiro',
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao partilhar: ${e.toString()}')),
        );
      }
    }
  }

  Widget _buildCard(String title, String subtitle, IconData icon, Color color) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color,
          child: Icon(icon, color: Colors.white),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        trailing: Text(subtitle, style: const TextStyle(fontSize: 16)),
      ),
    );
  }

  Widget _buildLineChart() {
    final spots =
        faturamentoMensal.entries.toList().asMap().entries.map((entry) {
          final x = entry.key.toDouble();
          final y = entry.value.value;
          return FlSpot(x, y);
        }).toList();

    final maxY = faturamentoMensal.values.reduce((a, b) => a > b ? a : b) * 1.2;

    return LineChart(
      LineChartData(
        minY: 0,
        maxY: maxY,
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 1,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index >= 0 && index < faturamentoMensal.length) {
                  return Text(
                    faturamentoMensal.keys.elementAt(index),
                    style: const TextStyle(fontSize: 10),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: true, interval: maxY / 5),
          ),
        ),
        gridData: FlGridData(show: true),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            barWidth: 3,
            color: Colors.green,
            dotData: FlDotData(show: true),
          ),
        ],
      ),
    );
  }

  Widget _buildPieChart() {
    final total = canaisDeVendas.values.reduce((a, b) => a + b);
    final sections =
        canaisDeVendas.entries.map((entry) {
          final percentage = entry.value / total * 100;
          final color =
              Colors.primaries[canaisDeVendas.keys.toList().indexOf(entry.key) %
                  Colors.primaries.length];
          return PieChartSectionData(
            value: entry.value,
            title: '${percentage.toStringAsFixed(1)}%',
            color: color,
            radius: 70,
            titleStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          );
        }).toList();

    return PieChart(
      PieChartData(
        sections: sections,
        centerSpaceRadius: 40,
        sectionsSpace: 4,
        borderData: FlBorderData(show: false),
      ),
    );
  }

  Widget _buildBarChart() {
    final maxY = (despesas > lucro ? despesas : lucro) * 1.2;

    return BarChart(
      BarChartData(
        maxY: maxY,
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: maxY / 5,
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toInt().toString(),
                  style: const TextStyle(fontSize: 12),
                );
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                switch (value.toInt()) {
                  case 0:
                    return const Padding(
                      padding: EdgeInsets.only(top: 8),
                      child: Text(
                        'Despesas',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    );
                  case 1:
                    return const Padding(
                      padding: EdgeInsets.only(top: 8),
                      child: Text(
                        'Lucro',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    );
                }
                return const SizedBox.shrink();
              },
              reservedSize: 40,
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        barGroups: [
          BarChartGroupData(
            x: 0,
            barRods: [
              BarChartRodData(toY: despesas, color: Colors.red, width: 26),
            ],
          ),
          BarChartGroupData(
            x: 1,
            barRods: [
              BarChartRodData(toY: lucro, color: Colors.blue, width: 26),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCanaisList() {
    if (canaisDeVendas.isEmpty) {
      return const Center(
        child: Text(
          'Nenhum canal de venda registrado.',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }
    return ListView(
      padding: const EdgeInsets.all(12),
      children:
          canaisDeVendas.entries
              .map(
                (e) => _buildCard(
                  e.key,
                  '${e.value.toStringAsFixed(2)} €',
                  Icons.storefront,
                  Colors.orange,
                ),
              )
              .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Análises Financeiras",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Constants.primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: 'Faturamento'),
            Tab(text: 'Finanças'),
            Tab(text: 'Canais'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Tab 1 - Faturamento com gráfico de linha e card resumo
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 250, child: _buildLineChart()),
                const SizedBox(height: 20),
                _buildCard(
                  'Faturamento Total Ano',
                  ' ${faturamentoTotal.toStringAsFixed(2)} €',
                  Icons.attach_money,
                  Colors.green,
                ),
              ],
            ),
          ),

          // Tab 2 - Finanças com gráfico de barras e cards
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              children: [
                SizedBox(height: 250, child: _buildBarChart()),
                const SizedBox(height: 20),
                _buildCard(
                  'Despesas',
                  ' ${despesas.toStringAsFixed(2)} €',
                  Icons.money_off,
                  Colors.red,
                ),
                _buildCard(
                  'Lucro',
                  '${lucro.toStringAsFixed(2)} €',
                  Icons.trending_up,
                  Colors.blue,
                ),
              ],
            ),
          ),

          // Tab 3 - Canais com gráfico de pizza + lista
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              children: [
                SizedBox(height: 250, child: _buildPieChart()),
                const SizedBox(height: 20),
                Expanded(child: _buildCanaisList()),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.download, color: Colors.white),
        label: const Text('Relatório', style: TextStyle(color: Colors.white)),
        onPressed: _salvarOuCompartilharRelatorio,
        backgroundColor: Constants.primaryColor,
      ),
    );
  }
}
