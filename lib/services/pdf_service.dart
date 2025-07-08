import 'dart:typed_data';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path_provider/path_provider.dart';

class PdfService {
  static const String baseUrl = 'http://146.190.85.190/api/reports';
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  /// Get stored JWT token for authentication
  Future<String?> _getAuthToken() async {
    return await _storage.read(key: 'jwt_token');
  }

  /// Generate PDF for all emergency reports
  Future<Uint8List> generateAllReportsPDF() async {
    try {
      final token = await _getAuthToken();
      if (token == null) {
        throw Exception('Authentication token not found');
      }

      final response = await http.get(
        Uri.parse('$baseUrl/pdf/all'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/pdf',
        },
      );

      if (response.statusCode == 200) {
        return response.bodyBytes;
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Please login again');
      } else if (response.statusCode == 500) {
        throw Exception('Server error: Failed to generate PDF');
      } else {
        throw Exception('Failed to generate PDF: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error downloading PDF: $e');
    }
  }

  /// Generate PDF for a specific emergency report
  Future<Uint8List> generateSingleReportPDF(String reportId) async {
    try {
      final token = await _getAuthToken();
      if (token == null) {
        throw Exception('Authentication token not found');
      }

      final response = await http.get(
        Uri.parse('$baseUrl/pdf/$reportId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/pdf',
        },
      );

      if (response.statusCode == 200) {
        return response.bodyBytes;
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Please login again');
      } else if (response.statusCode == 404) {
        throw Exception('Report not found');
      } else if (response.statusCode == 500) {
        throw Exception('Server error: Failed to generate PDF');
      } else {
        throw Exception('Failed to generate PDF: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error downloading PDF: $e');
    }
  }

  /// Save PDF to device storage
  Future<String> savePDFToDevice(Uint8List pdfBytes, String filename) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$filename');
      await file.writeAsBytes(pdfBytes);
      return file.path;
    } catch (e) {
      throw Exception('Error saving PDF: $e');
    }
  }
} 