import 'package:flutter/material.dart';
import 'dart:typed_data';
import '../services/pdf_service.dart';
import '../admin/pages/generate_report.dart';

class PdfUtils {
  /// Quick function to generate and show PDF for all emergency reports
  static Future<void> generateAllReportsPDF(BuildContext context) async {
    _showLoadingDialog(context, 'Generating All Reports PDF...');
    
    try {
      final pdfService = PdfService();
      final pdfBytes = await pdfService.generateAllReportsPDF();
      
      if (!context.mounted) return;
      Navigator.of(context).pop(); // Remove loading dialog
      
      _showPdfOptionsDialog(context, pdfBytes, 'All Emergency Reports');
      
    } catch (e) {
      if (!context.mounted) return;
      Navigator.of(context).pop(); // Remove loading dialog
      _showErrorSnackBar(context, 'Failed to generate PDF: ${e.toString()}');
    }
  }

  /// Quick function to generate and show PDF for a specific emergency report
  static Future<void> generateSingleReportPDF(BuildContext context, String reportId, String reportTitle) async {
    _showLoadingDialog(context, 'Generating Single Report PDF...');
    
    try {
      final pdfService = PdfService();
      final pdfBytes = await pdfService.generateSingleReportPDF(reportId);
      
      if (!context.mounted) return;
      Navigator.of(context).pop(); // Remove loading dialog
      
      _showPdfOptionsDialog(context, pdfBytes, reportTitle);
      
    } catch (e) {
      if (!context.mounted) return;
      Navigator.of(context).pop(); // Remove loading dialog
      _showErrorSnackBar(context, 'Failed to generate PDF: ${e.toString()}');
    }
  }

  /// Show loading dialog
  static void _showLoadingDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFF2A2A2A),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(color: Color(0xFF6C63FF)),
              const SizedBox(height: 16),
              Text(
                message,
                style: const TextStyle(color: Colors.white, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Show PDF options dialog
  static void _showPdfOptionsDialog(BuildContext context, Uint8List pdfBytes, String pdfTitle) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2A2A2A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          '$pdfTitle Generated!',
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'What would you like to do with the PDF?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => PdfViewPage(pdfBytes: pdfBytes),
                ),
              );
            },
            child: const Text(
              'View PDF',
              style: TextStyle(color: Color(0xFF6C63FF)),
            ),
          ),
          TextButton(
            onPressed: () async {
              try {
                final pdfService = PdfService();
                final timestamp = DateTime.now().millisecondsSinceEpoch;
                final filename = '${pdfTitle.toLowerCase().replaceAll(' ', '-')}-$timestamp.pdf';
                final filePath = await pdfService.savePDFToDevice(pdfBytes, filename);
                
                if (!context.mounted) return;
                Navigator.of(context).pop();
                
                _showSuccessSnackBar(context, 'PDF saved to: $filePath');
              } catch (e) {
                if (!context.mounted) return;
                Navigator.of(context).pop();
                _showErrorSnackBar(context, 'Failed to save PDF: ${e.toString()}');
              }
            },
            child: const Text(
              'Save to Device',
              style: TextStyle(color: Color(0xFF6C63FF)),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  /// Show success snackbar
  static void _showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  /// Show error snackbar
  static void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 5),
        action: SnackBarAction(
          label: 'Retry',
          onPressed: () {
            // You can implement retry logic here
          },
        ),
      ),
    );
  }
} 