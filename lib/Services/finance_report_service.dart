import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import 'dart:typed_data';

class FinanceReportService {
  final double faturamentoTotal;
  final double despesas;
  final double lucro;
  final Map<String, double> faturamentoMensal;
  final Map<String, double> canaisDeVendas;

  FinanceReportService({
    required this.faturamentoTotal,
    required this.despesas,
    required this.lucro,
    required this.faturamentoMensal,
    required this.canaisDeVendas,
  });

  Future<Uint8List> generatePDF() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return [
            // Cabeçalho
            pw.Header(
              level: 0,
              child: pw.Text(
                'Relatório Financeiro',
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            pw.SizedBox(height: 20),

            // 1. Resumo Financeiro
            pw.Text(
              "Resumo Financeiro",
              style: pw.TextStyle(
                fontSize: 18,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.blue,
              ),
            ),
            pw.TableHelper.fromTextArray(
              context: context,
              data: [
                ['Faturamento Total', '${faturamentoTotal.toStringAsFixed(2)} €'],
                ['Despesas', '${despesas.toStringAsFixed(2)} €'],
                ['Lucro', '${lucro.toStringAsFixed(2)} €'],
              ],
            ),
            pw.SizedBox(height: 30),

            // 2. Faturamento Mensal
            pw.Text(
              'Faturamento Mensal',
              style: pw.TextStyle(
                fontSize: 18,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.blue,
              ),
            ),
            pw.TableHelper.fromTextArray(
              context: context,
              headers: ['Mês', 'Valor (€)'],
              data: faturamentoMensal.entries
                  .map((e) => [e.key, e.value.toStringAsFixed(2)])
                  .toList(),
            ),
            pw.SizedBox(height: 30),

            // 3. Canais de Vendas
            pw.Text(
              'Canais de Vendas',
              style: pw.TextStyle(
                fontSize: 18,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.blue,
              ),
            ),
            pw.TableHelper.fromTextArray(
              context: context,
              headers: ['Canal', 'Valor (€)'],
              data: canaisDeVendas.entries
                  .map((e) => [e.key, e.value.toStringAsFixed(2)])
                  .toList(),
            ),
          ];
        },
      ),
    );

    return pdf.save();
  }
}