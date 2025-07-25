import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;


class RelatorioFinanceiro {
  final double faturamentoTotal;
  final double despesas;
  final double lucro;


  RelatorioFinanceiro({
    required this.faturamentoTotal,
    required this.despesas,
    required this.lucro,
  });

  // Gera um documento PDF com o resumo financeiro.
  Future<Uint8List> gerarPDF() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return [
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
            
          ];
        },
      ),
    );

    return pdf.save();
  }
}