import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:neighborhub/services/pdf_service.dart';
import 'package:neighborhub/admin/pages/generate_report.dart';

class PdfGenerationWidget {
  static void showPdfOptions(BuildContext context, {
    required String reportId,
    required String reportTitle,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF2A2A2A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF6C63FF).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.picture_as_pdf,
                    color: Color(0xFF6C63FF),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Generate PDF Report',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Choose an option to generate a PDF report:',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 16),
            _buildOptionButton(
              context,
              'Single Report PDF',
              'Generate PDF for this specific report',
              Icons.description,
              () => _generateSingleReportPDF(context, reportId),
            ),
            const SizedBox(height: 12),
            _buildOptionButton(
              context,
              'All Reports PDF',
              'Generate comprehensive PDF with all reports',
              Icons.library_books,
              () => _generateAllReportsPDF(context),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  static Widget _buildOptionButton(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onPressed,
  ) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF6C63FF).withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF6C63FF).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: const Color(0xFF6C63FF), size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.white70,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  static Future<void> _generateSingleReportPDF(BuildContext context, String reportId) async {
    Navigator.of(context).pop(); // Close bottom sheet
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: Color(0xFF6C63FF)),
            SizedBox(height: 16),
            Text(
              'Generating Single Report PDF...',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ],
        ),
      ),
    );

    try {
      final pdfService = PdfService();
      final pdfBytes = await pdfService.generateSingleReportPDF(reportId);
      
      if (!context.mounted) return;
      Navigator.of(context).pop(); // Remove loading dialog
      
      _showPdfSuccessDialog(context, pdfBytes, 'Single Report PDF');
      
    } catch (e) {
      if (!context.mounted) return;
      Navigator.of(context).pop(); // Remove loading dialog
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to generate PDF: ${e.toString()}'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
        ),
      );
    }
  }

  static Future<void> _generateAllReportsPDF(BuildContext context) async {
    Navigator.of(context).pop(); // Close bottom sheet
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: Color(0xFF6C63FF)),
            SizedBox(height: 16),
            Text(
              'Generating All Reports PDF...',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ],
        ),
      ),
    );

    try {
      final pdfService = PdfService();
      final pdfBytes = await pdfService.generateAllReportsPDF();
      
      if (!context.mounted) return;
      Navigator.of(context).pop(); // Remove loading dialog
      
      _showPdfSuccessDialog(context, pdfBytes, 'All Reports PDF');
      
    } catch (e) {
      if (!context.mounted) return;
      Navigator.of(context).pop(); // Remove loading dialog
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to generate PDF: ${e.toString()}'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
        ),
      );
    }
  }

  static void _showPdfSuccessDialog(BuildContext context, Uint8List pdfBytes, String pdfType) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2A2A2A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          '$pdfType Generated Successfully!',
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'Your PDF report has been generated. What would you like to do with it?',
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
                final filename = '${pdfType.toLowerCase().replaceAll(' ', '-')}-$timestamp.pdf';
                final filePath = await pdfService.savePDFToDevice(pdfBytes, filename);
                
                if (!context.mounted) return;
                Navigator.of(context).pop();
                
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('PDF saved to: $filePath'),
                    backgroundColor: Colors.green,
                    duration: const Duration(seconds: 3),
                  ),
                );
              } catch (e) {
                if (!context.mounted) return;
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Failed to save PDF: ${e.toString()}'),
                    backgroundColor: Colors.red,
                    duration: const Duration(seconds: 3),
                  ),
                );
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
} 