
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';
import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;

Future<Uint8List> generateReportPdf() async {
  try {
    //TODO: Fetch reports from database
    final reports = [];
    final font = pw.Font.ttf(await rootBundle.load('assets/fonts/Roboto-Regular.ttf'));
    final boldFont = pw.Font.ttf(await rootBundle.load('assets/fonts/Roboto-Bold.ttf'));

    final pdf = pw.Document();
    final now = DateTime.now();
    final dateStr = DateFormat('dd MMMM yyyy, HH:mm').format(now);

    pdf.addPage(
      pw.MultiPage(
        pageTheme: pw.PageTheme(
          margin: const pw.EdgeInsets.all(32),
          theme: pw.ThemeData.withFont(
            base: font,
            bold: boldFont,
          ),
        ),
        build: (context) => [
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Community Emergency Report', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold, color: PdfColors.indigo800)),
                  pw.Container(
                    padding: const pw.EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: pw.BoxDecoration(
                      color: PdfColors.indigo100,
                      borderRadius: pw.BorderRadius.circular(8),
                    ),
                    child: pw.Text(dateStr, style: pw.TextStyle(fontSize: 12, color: PdfColors.indigo900)),
                  ),
                ],
              ),
              pw.SizedBox(height: 12),
              pw.Divider(),
              pw.SizedBox(height: 16),
              pw.Text('Summary', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold, color: PdfColors.indigo700)),
              pw.SizedBox(height: 8),
              pw.Text('This report contains a summary of all emergency reports submitted by the community. Each entry includes the user, description, and timestamp.'),
              pw.SizedBox(height: 24),
              pw.Table.fromTextArray(
                border: null,
                cellAlignment: pw.Alignment.centerLeft,
                headerDecoration: pw.BoxDecoration(color: PdfColors.indigo100),
                headerHeight: 32,
                cellHeight: 32,
                headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.indigo900),
                cellStyle: const pw.TextStyle(fontSize: 10),
                rowDecoration: pw.BoxDecoration(border: pw.Border(bottom: pw.BorderSide(color: PdfColors.grey300, width: .5))),
                headers: ['User', 'Description', 'Time'],
                data: reports.map((r) => [
                  r['user'] ?? '-',
                    r['description'] ?? '-',
                  r['timestamp'] != null ? DateFormat('dd MMM yyyy, HH:mm').format(r['timestamp']) : '-',
                ]).toList(),
              ),
              if (reports.isEmpty)
                pw.Padding(
                  padding: const pw.EdgeInsets.only(top: 32),
                  child: pw.Text('No reports found.', style: pw.TextStyle(color: PdfColors.grey600)),
                ),
            ],
          ),
        ],
      ),
    );
    return pdf.save();
  } catch (e) {
    throw Exception('Failed to generate PDF: ${e.toString()}');
  }
}
