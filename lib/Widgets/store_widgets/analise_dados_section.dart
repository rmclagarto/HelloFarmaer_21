import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:hellofarmer/Core/constants.dart';
import 'package:hellofarmer/Services/database_service.dart';
import 'package:hellofarmer/Services/finance_report_service.dart';
import 'package:share_plus/share_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';



class AnalisesFinanceirasSection extends StatefulWidget {
  final String storeId;
  const AnalisesFinanceirasSection({super.key, required this.storeId});

  @override
  State<AnalisesFinanceirasSection> createState() =>
      _AnalisesFinanceirasSectionState();
}

class _AnalisesFinanceirasSectionState extends State<AnalisesFinanceirasSection>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final DatabaseService _dbService = DatabaseService();

  double _faturamentoTotal = 0.0;
  double _despesas = 0;
  double _lucro = 0;
  bool _isLoading = true;
  String? _errorMessage;

  

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 1, vsync: this);
    _loadFinancialData();
  }

  Future<void> _loadFinancialData() async {
    try {
      final snapshot = await _dbService.read(path: 'stores/${widget.storeId}');
      if(snapshot?.value == null){
        throw Exception('Loja não encontrada');
      }

      final data = Map<String, dynamic>.from(snapshot!.value as Map);
      
      setState(() {
        _faturamentoTotal = (data['faturamento'] ?? 0).toDouble();
        _despesas = (data['despesas'] ?? 0).toDouble();
        _lucro = _faturamentoTotal - _despesas;
        
        _isLoading = false;
      });
    
    }catch(e){
      setState(() {
          _errorMessage = 'Erro ao carregar dados: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _salvarOuCompartilharRelatorio() async {
    final service = FinanceReportService(
      faturamentoTotal: _faturamentoTotal,
      despesas: _despesas,
      lucro: (_faturamentoTotal - _despesas),
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
                const SizedBox(height: 20),
                _buildCard(
                  'Faturamento Total Ano',
                  ' ${_faturamentoTotal.toStringAsFixed(2)} €',
                  Icons.attach_money,
                  Colors.green,
                ),
                 const SizedBox(height: 20),
                _buildCard(
                  'Despesas',
                  ' ${_despesas.toStringAsFixed(2)} €',
                  Icons.money_off,
                  Colors.red,
                ),
                _buildCard(
                  'Lucro',
                  '${_lucro.toStringAsFixed(2)} €',
                  Icons.trending_up,
                  Colors.blue,
                ),
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
